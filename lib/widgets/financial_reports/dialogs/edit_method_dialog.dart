import 'package:control_panel_2/models/teacher_model.dart';
import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:flutter/material.dart';

class EditMethodDialog extends StatefulWidget {
  final Teacher teacher;

  const EditMethodDialog({super.key, required this.teacher});

  @override
  State<EditMethodDialog> createState() => _EditMethodDialogState();
}

class _EditMethodDialogState extends State<EditMethodDialog> {
  // Controllers for managing text input fields
  final TextEditingController _commissionRateController = TextEditingController(
    text: "60",
  );
  final TextEditingController _salaryController = TextEditingController();

  // State variables
  bool _commissionIsChecked = true;
  bool _salaryIsChecked = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with close button
                _buildHeader(),
                SizedBox(height: 25),

                _buildTeacherInfo(),

                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),

                _buildPaymentMethod(),
                SizedBox(height: 30),

                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "تحديد طريقة الدفع",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      Spacer(),
      IconButton(
        icon: Icon(Icons.close, size: 20),
        onPressed: () => Navigator.pop(context),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      ),
    ],
  );

  Widget _buildTeacherInfo() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "معلومات المدرس",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.teacher.fullName,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              widget.teacher.username,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(children: [Text("2 كورسات"), Text("  •  "), Text("43 طالب")]),
          ],
        ),
      ),
    ],
  );

  Widget _buildPaymentMethod() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "طرق الدفع",
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 20),
      _buildCommissionRate(),
      SizedBox(height: 10),
      _buildSalary(),
    ],
  );

  Widget _buildCommissionRate() => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _commissionIsChecked,
          checkColor: Colors.white,
          activeColor: Colors.black,
          onChanged: (bool? value) {
            setState(() {
              _commissionIsChecked = value ?? false;
              _salaryIsChecked ? _salaryIsChecked = false : null;
            });
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text(
              "الدفع عن طريق العمولة",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "المدرس له نسبة عمولة على كورساته",
              style: TextStyle(color: Colors.grey),
            ),
            if (_commissionIsChecked)
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "نسبة العمولة (%)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 90,
                    child: CustomTextField(
                      hintText: "",
                      controller: _commissionRateController,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
  );

  Widget _buildSalary() => Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black26),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _salaryIsChecked,
          checkColor: Colors.white,
          activeColor: Colors.black,
          onChanged: (bool? value) {
            setState(() {
              _salaryIsChecked = value ?? false;
              _commissionIsChecked ? _commissionIsChecked = false : null;
            });
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            Text("الدفع كراتب", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "المدرس له راتب ثابت على الحصة الواحدة",
              style: TextStyle(color: Colors.grey),
            ),
            if (_salaryIsChecked)
              Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    "الراتب على الحصة (\$)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 90,
                    child: CustomTextField(
                      hintText: "",
                      controller: _salaryController,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    ),
  );

  Widget _buildSubmitButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("إلغاء"),
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        onPressed: () {
          // if (_formKey.currentState!.validate()) {
          //   // Form is valid - process data
          // }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("حفظ التعديل"),
        ),
      ),
    ],
  );
}
