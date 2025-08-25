import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';

class EditCategoryDialog extends StatefulWidget {
  final String category;

  const EditCategoryDialog({super.key, required this.category});

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  // Form key for validation and form state management
  final _formKey = GlobalKey<FormState>();

  // Controllers for managing text input fields
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

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
                  // Dialog header with icon and close button
                  _buildHeader(),
                  SizedBox(height: 20),

                  // Notification content input section
                  _buildTitleField(),
                  SizedBox(height: 20),

                  // Submit button
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds dialog header with title and close button
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dialog title
        Text(
          "تعديل تصنيف", // "Send Notification"
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Spacer(),

        // Close button
        IconButton(
          icon: Icon(Icons.close, size: 20),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
      ],
    );
  }

  /// Builds the title input field
  Widget _buildTitleField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("اسم التصنيف *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل اسم التصنيف",
        controller: _titleController,
      ),
    ],
  );

  Widget _buildSubmitButton() => Row(
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
          child: Text("حفظ التعديلات"),
        ),
      ),
    ],
  );
}
