import 'package:control_panel_2/constants/all_financial_reciepts.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FinancialRecieptsPage extends StatefulWidget {
  const FinancialRecieptsPage({super.key});

  @override
  State<FinancialRecieptsPage> createState() => _FinancialRecieptsPageState();
}

class _FinancialRecieptsPageState extends State<FinancialRecieptsPage> {
  // Controllers for all form fields
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // State variables
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Currently selected filter value from dropdown
  String? dropdownValue = "جميع الأنواع";

  // Date picker function
  Future<void> _selectDate(
    BuildContext context,
    bool isStartDate,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[300]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          controller.text = DateFormat(
            'MM/dd/yyyy',
          ).format(_selectedStartDate!);
        } else {
          _selectedEndDate = picked;
          controller.text = DateFormat('MM/dd/yyyy').format(_selectedEndDate!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.homepageBg,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page header with title and create button
                _buildPageHeader(),
                SizedBox(height: 25),

                _buildOverviewCards(),
                SizedBox(height: 20),

                _buildReceiptsFilter(),
                SizedBox(height: 25),

                _buildReceipts(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds page header
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "التقارير المالية",
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "إدارة نسب المدرسين وروابهم، حساب الذمم المالية، وعرض تقارير مالية",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildOverviewCards() {
    final paymentReceipts = allReceipts.where(
      (receipt) => receipt.type == "دفع",
    );
    final returnReceipts = allReceipts.where(
      (receipt) => receipt.type == "ارتجاع",
    );
    final disbursementReceipts = allReceipts.where(
      (receipt) => receipt.type == "صرف",
    );

    int calculateTotalFund() {
      int total = 0;

      for (var receipt in allReceipts) {
        int amount = int.tryParse(receipt.ammount) ?? 0;

        if (receipt.type == 'دفع' || receipt.type == 'ارتجاع') {
          total += amount;
        } else if (receipt.type == 'صرف') {
          total -= amount;
        }
      }

      return total;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  "مجمل العائدات",
                  calculateTotalFund(),
                  Icon(Icons.receipt_outlined, color: Colors.grey, size: 25),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "أيصالات الدفع",
                  paymentReceipts.length,
                  null,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "إيصالات الارتجاع",
                  returnReceipts.length,
                  null,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "أوامر الصرف",
                  disbursementReceipts.length,
                  null,
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      "مجمل العائدات",
                      calculateTotalFund(),
                      Icon(
                        Icons.receipt_outlined,
                        color: Colors.grey,
                        size: 25,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildOverviewCard(
                      "أيصالات الدفع",
                      paymentReceipts.length,
                      null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildOverviewCard(
                      "إيصالات الارتجاع",
                      returnReceipts.length,
                      null,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildOverviewCard(
                      "أوامر الصرف",
                      disbursementReceipts.length,
                      null,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildOverviewCard(String title, int number, Icon? icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black87)),
              SizedBox(height: 10),
              Text(
                number.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: title == "مجمل العائدات"
                      ? number >= 0
                            ? Colors.green
                            : Colors.red.shade700
                      : null,
                ),
              ),
            ],
          ),
          if (icon != null) icon,
        ],
      ),
    );
  }

  Widget _buildReceiptsFilter() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_alt_outlined),
                  SizedBox(width: 10),
                  Text(
                    "فلترة الإيصالات",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildFilters()),
              SizedBox(width: 15),
              Expanded(child: _buildStartDate()),
              SizedBox(width: 15),
              Expanded(child: _buildEndDate()),
              SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt_outlined),
                      SizedBox(width: 10),
                      Text("تطبيق الفلاتر"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() => DropdownButtonFormField<String>(
    value: dropdownValue,
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black87),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    onChanged: (String? newValue) {
      setState(() {
        dropdownValue = newValue;
      });
    },
    items: <String>['جميع الأنواع', 'دفع', 'ارتجاع', 'صرف']
        .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        })
        .toList(),
  );

  Widget _buildStartDate() => TextFormField(
    controller: _startDateController,
    decoration: InputDecoration(
      hintText: 'mm/dd/yyyy',
      suffixIcon: Icon(Icons.calendar_month_outlined, size: 18),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black87),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    readOnly: true,
    onTap: () => _selectDate(context, true, _startDateController),
    // validator: _validateDate,
  );

  Widget _buildEndDate() => TextFormField(
    controller: _endDateController,
    decoration: InputDecoration(
      hintText: 'mm/dd/yyyy',
      suffixIcon: Icon(Icons.calendar_month_outlined, size: 18),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black87),
        borderRadius: BorderRadius.circular(6),
      ),
    ),
    readOnly: true,
    onTap: () => _selectDate(context, false, _endDateController),
    // validator: _validateDate,
  );

  Widget _buildReceipts() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt_long_outlined),
              SizedBox(width: 5),
              Text(
                "جدول الإيصالات المالية",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              // Expanded(
              //   child: TeacherCommissionTable(
              //     searchQuery: _searchController.text,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
