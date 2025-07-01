import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:flutter/material.dart';

class AddAdvertisementDialog extends StatefulWidget {
  const AddAdvertisementDialog({super.key});

  @override
  State<AddAdvertisementDialog> createState() => _AddAdvertisementDialogState();
}

class _AddAdvertisementDialogState extends State<AddAdvertisementDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  // Controllers for all form fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Checkbox Value
  bool _isChecked = true; // Default value

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 2),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with close button
                  _buildHeader(),
                  SizedBox(height: 25),

                  // Details
                  _buildAdvertisementDetails(),
                  SizedBox(height: 25),

                  // Target Audiance
                  _buildTargetAudiance(),
                  SizedBox(height: 25),

                  // Submit button
                  _buildCreateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إنشاء إعلان جديد",
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
  }

  Widget _buildAdvertisementDetails() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "تفاصيل الإعلان",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          _buildTitleField(),
          SizedBox(height: 25),
          _buildContentField(),
          SizedBox(height: 25),
          _buildImageSection(),
        ],
      ),
    );
  }

  Widget _buildTitleField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("العنوان *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل عنوان الإعلان",
        controller: _titleController,
        // validator: (value) => _validateNotEmpty(value, "اسم الأب"),
      ),
    ],
  );

  Widget _buildContentField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المضمون *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل مضمون الإعلان",
        maxLines: 3,
        controller: _contentController,
        // validator: (value) => _validateNotEmpty(value, "اسم الأب"),
      ),
    ],
  );

  Widget _buildImageSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("صورة الإعلان *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      InkWell(
        onTap: () {},
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.file_upload_outlined, color: Colors.grey, size: 40),
              Text(
                "اضغط لتحميل الصورة",
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildTargetAudiance() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "الفئة المستهدفة",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          Row(
            children: [
              Checkbox(
                value: _isChecked,
                checkColor: Colors.white,
                activeColor: Colors.black,
                onChanged: (bool? value) {
                  setState(() {
                    _isChecked = value ?? false;
                  });
                },
              ),

              Text("جميع المستخدمين"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Form is valid - process data
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("إنشاء الإعلان"),
        ),
      ),
    ],
  );
}
