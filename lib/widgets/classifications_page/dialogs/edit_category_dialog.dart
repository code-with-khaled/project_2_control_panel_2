import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/category_service.dart';
import 'package:control_panel_2/models/category_model.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

class EditCategoryDialog extends StatefulWidget {
  final Category category;
  final VoidCallback callback;

  const EditCategoryDialog({
    super.key,
    required this.category,
    required this.callback,
  });

  @override
  State<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  // Form key for validation and form state management
  final _formKey = GlobalKey<FormState>();

  // Controllers for managing text input fields
  final TextEditingController _titleController = TextEditingController();

  bool _isSubmitting = false;

  // Variables for storing the advertisement image
  String? _imageUrl;
  String? _fileName;

  Future<void> _pickImage() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file!); // This reads the file as a Base64 string

      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageUrl = reader.result as String;
          _fileName = file.name;
        });
      });
    });
  }

  Future<void> _editCategory() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _categoryService.editCategory(
        token,
        widget.category.id,
        _titleController.text.trim(),
        _imageUrl,
        _fileName,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم تعديل التصنيف بنجاح')));
        widget.callback();
        Navigator.pop(context);
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
          _isSubmitting = false;
        });
      }
    }
  }

  late CategoryService _categoryService;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.category.name;

    final apiClient = ApiHelper.getClient();
    _categoryService = CategoryService(apiClient: apiClient);
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

                  // Image field
                  _buildImageSection(),
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

  /// Builds the image upload section with preview capability
  Widget _buildImageSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("صورة تصنيف *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      InkWell(
        onTap: _pickImage,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: _imageUrl == null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                    Text(
                      "اضغط لتحميل الصورة",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo, color: Colors.black54),
                    SizedBox(width: 10),
                    Text(_fileName!, overflow: TextOverflow.ellipsis),
                  ],
                ),
        ),
      ),
    ],
  );

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
            _editCategory();
          }
        },
        child: _isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("حفظ التعديلات"),
              ),
      ),
    ],
  );
}
