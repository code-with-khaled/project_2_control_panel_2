import 'package:control_panel_2/constants/all_financial_receipts.dart';
import 'package:control_panel_2/models/financial_receipt_model.dart';
import 'package:flutter/material.dart';

class FinancialReceiptsTable extends StatefulWidget {
  final String filter;

  const FinancialReceiptsTable({super.key, required this.filter});

  @override
  State<FinancialReceiptsTable> createState() => _FinancialReceiptsTableState();
}

class _FinancialReceiptsTableState extends State<FinancialReceiptsTable> {
  final ScrollController _horizontalScrollController = ScrollController();

  List<FinancialReceipt> get _filteredReceipts {
    switch (widget.filter) {
      case 'دفع':
        return allReceipts.where((receipt) => receipt.type == "دفع").toList();
      case 'ارتجاع':
        return allReceipts
            .where((receipt) => receipt.type == "ارتجاع")
            .toList();
      case 'صرف':
        return allReceipts.where((receipt) => receipt.type == "صرف").toList();
      default: // 'جميع الأنواع'
        return allReceipts;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                        "السبب",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
                rows: _filteredReceipts
                    .map(
                      (receipt) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              receipt.number,
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
                                color: _getTypeBgColor(receipt.type),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                receipt.type,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: _getTypeColor(receipt.type),
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(receipt.date)),
                          DataCell(Text(receipt.person)),
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  receipt.item,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                receipt.service != null
                                    ? Text(
                                        receipt.service!,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      )
                                    : Text(
                                        "-",
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
                              receipt.ammount,
                              style: receipt.type == "دفع"
                                  ? TextStyle(color: Colors.green)
                                  : TextStyle(color: Colors.red),
                            ),
                          ),
                          DataCell(
                            receipt.reason != null
                                ? Text(
                                    receipt.reason!,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  )
                                : Text(
                                    "-",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getTypeColor(String status) {
    switch (status) {
      case "دفع":
        return Colors.green.shade900;
      case "ارتجاع":
        return Colors.yellow.shade900;
      default:
        return Colors.red.shade900;
    }
  }

  Color _getTypeBgColor(String status) {
    switch (status) {
      case "دفع":
        return Colors.green.shade100;
      case "ارتجاع":
        return Colors.yellow.shade100;
      default:
        return Colors.red.shade100;
    }
  }
}
