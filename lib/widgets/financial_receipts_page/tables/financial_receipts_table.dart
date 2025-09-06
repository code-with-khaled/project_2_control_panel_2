import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/receipt_service.dart';
import 'package:control_panel_2/models/order_model.dart';
import 'package:control_panel_2/models/receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancialReceiptsTable extends StatefulWidget {
  final String filter;
  final Function(int, int, int, int) callback;
  final DateTime? startDate;
  final DateTime? endDate;

  const FinancialReceiptsTable({
    super.key,
    required this.filter,
    required this.callback,
    this.startDate,
    this.endDate,
  });

  @override
  State<FinancialReceiptsTable> createState() => FinancialReceiptsTableState();
}

class FinancialReceiptsTableState extends State<FinancialReceiptsTable> {
  final ScrollController _horizontalScrollController = ScrollController();
  // Variables for API integration
  late ReceiptService _receiptService;
  bool _isLoading = true;
  bool _isDeleting = false;

  List<Receipt> _receipts = [];
  List<Order> _orders = [];

  List<dynamic> get _filteredItems {
    final allItems = [
      ..._receipts.map((r) => {'type': 'receipt', 'data': r}),
      ..._orders.map((o) => {'type': 'order', 'data': o}),
    ];

    // First filter by type
    List<dynamic> typeFilteredItems;
    switch (widget.filter) {
      case 'دفع':
        typeFilteredItems = allItems.where((item) {
          if (item['type'] == 'receipt') {
            final receipt = item['data'] as Receipt;
            return receipt.status == "مدفوع";
          }
          return false;
        }).toList();
        break;
      case 'ارتجاع':
        typeFilteredItems = allItems.where((item) {
          if (item['type'] == 'receipt') {
            final receipt = item['data'] as Receipt;
            return receipt.status == "مسترجع";
          }
          return false;
        }).toList();
        break;
      case 'صرف':
        typeFilteredItems = allItems
            .where((item) => item['type'] == 'order')
            .toList();
        break;
      default: // 'جميع الأنواع'
        typeFilteredItems = allItems;
    }

    // Then filter by date range if dates are provided
    if (widget.startDate != null || widget.endDate != null) {
      return typeFilteredItems.where((item) {
        final DateTime itemDate = item['data'].date;

        // Check if item date is after or equal to start date (if provided)
        final bool afterStartDate =
            widget.startDate == null ||
            itemDate.isAfter(widget.startDate!.subtract(Duration(days: 1)));

        // Check if item date is before or equal to end date (if provided)
        final bool beforeEndDate =
            widget.endDate == null ||
            itemDate.isBefore(widget.endDate!.add(Duration(days: 1)));

        return afterStartDate && beforeEndDate;
      }).toList();
    }

    return typeFilteredItems;
  }

  Future<void> _loadReceipts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final receipts = await _receiptService.fetchReceipts(token);
      final orders = await _receiptService.fetchOrders(token);
      setState(() {
        _receipts = receipts;
        _orders = orders;
        _isLoading = false;
      });
      final paymentReceipts = _receipts.where(
        (receipt) => receipt.status == "مدفوع",
      );
      final returnReceipts = _receipts.where(
        (receipt) => receipt.status == "مسترجع",
      );

      widget.callback(
        calculateTotalFund(),
        paymentReceipts.length,
        returnReceipts.length,
        _orders.length,
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    }
  }

  void refreshReceipts() {
    _loadReceipts();
  }

  Future<void> _deleteCategory(int id) async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من رغبتك في حذف الإيصال'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _receiptService.deleteReceipt(token, id);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حذف التصنيف بنجاح')));
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }

    _loadReceipts();
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _receiptService = ReceiptService(apiClient: apiClient);

    _loadReceipts();
  }

  int calculateTotalFund() {
    int total = 0;

    for (var receipt in _receipts) {
      int amount = receipt.amount;

      if (receipt.status == 'مدفوع' || receipt.status == 'مسترجع') {
        total += amount;
      }
    }

    for (var order in _orders) {
      int amount = order.amount;

      total -= amount;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              padding: EdgeInsets.all(20),
              strokeWidth: 2,
              color: Colors.blue,
            ),
          )
        : (_receipts.isEmpty && _orders.isEmpty)
        ? _buildEmptyState()
        : LayoutBuilder(
            builder: (context, constraints) {
              return Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DataTable(
                      // ignore: deprecated_member_use
                      dataRowHeight: 60,
                      columnSpacing: 20,
                      horizontalMargin: 20,
                      columns: [
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              "رقم الإيصال",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              "نوع الإيصال",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              "التاريخ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              "الشخص/الكيان",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              "العنصر/الخدمة",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              "القيمة",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Flexible(
                            child: Text(
                              "الإجرائيات",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: _filteredItems.map((item) {
                        final isReceipt = item['type'] == 'receipt';
                        final data = item['data'];

                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                data.id!.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeBgColor(
                                    isReceipt ? data.status : "صرف",
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  isReceipt ? data.status : "صرف",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: _getTypeColor(
                                      isReceipt ? data.status : "صرف",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(
                              Text(DateFormat('yyyy-MM-dd').format(data.date)),
                            ),
                            DataCell(
                              isReceipt
                                  ? Text(data.student)
                                  : Text(data.teacher),
                            ),
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isReceipt ? "دورة" : "راتب موظف",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    isReceipt ? data.name : data.courseName,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                data.amount.toString(),
                                style: TextStyle(
                                  color: isReceipt
                                      ? (data.status == "مدفوع"
                                            ? Colors.green
                                            : Colors.blue)
                                      : Colors.red,
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                onPressed: () => _deleteCategory(data.id!),
                                icon: _isDeleting
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.red,
                                        ),
                                      )
                                    : Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                      ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا يوجد جدول للإيصالات',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }

  Color _getTypeColor(String status) {
    switch (status) {
      case "مدفوع":
        return Colors.green.shade900;
      case "مسترجع":
        return Colors.yellow.shade900;
      default:
        return Colors.red.shade900;
    }
  }

  Color _getTypeBgColor(String status) {
    switch (status) {
      case "مدفوع":
        return Colors.green.shade100;
      case "مسترجع":
        return Colors.yellow.shade100;
      default:
        return Colors.red.shade100;
    }
  }
}
