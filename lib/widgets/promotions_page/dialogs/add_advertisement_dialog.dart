import 'dart:typed_data';

import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/advertisements_service.dart';
import 'package:control_panel_2/models/advertisement_model.dart';
import 'package:control_panel_2/widgets/students_page/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:http/http.dart' as http;

/// A dialog widget for creating new advertisements
///
/// This dialog contains form fields for advertisement details including:
/// - Title
/// - Content
/// - Image upload
/// - Target audience selection
class AddAdvertisementDialog extends StatefulWidget {
  const AddAdvertisementDialog({super.key});

  @override
  State<AddAdvertisementDialog> createState() => _AddAdvertisementDialogState();
}

class _AddAdvertisementDialogState extends State<AddAdvertisementDialog> {
  // Form key for validation and form state management
  final _formKey = GlobalKey<FormState>();

  // Controllers for managing text input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // Variables for storing the advertisement image
  Uint8List? _imageBytes; // Stores the image bytes when uploaded
  String? _fileName; // Stores the name of the uploaded file

  // Tracks whether the advertisement targets all users
  bool _isChecked = true; // Default value is true (target all users)

  /// Opens file picker to select an image for the advertisement
  ///
  /// Sets [_imageBytes] and [_fileName] when a file is selected
  // ignore: unused_element
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true, // Ensures we get the file bytes
    );

    // Check if file was selected and contains data
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageBytes = result.files.single.bytes;
        _fileName = result.files.single.name;
      });
    }
  }

  String? _imageUrl;

  Future<void> _pickImage2() async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files?.first;
      final reader = html.FileReader();

      reader.readAsDataUrl(file!); // This reads the file as a Base64 string

      reader.onLoadEnd.listen((e) {
        _imageUrl = reader.result as String;
        _fileName = file.name;
      });
    });
  }

  // Validation functions
  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName مطلوب';
    }
    return null;
  }

  late AdvertisementsService advertisementsService;
  bool _isSubmitting = false;

  Future<void> _createAdvertisement() async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final advertisement = Advertisement(
      media: _imageUrl!,
      type: "image",
      startDate: "2025-08-23",
      endDate: "2025-08-30",
    );

    try {
      final token = TokenHelper.getToken();
      await advertisementsService.createAdvertisement(
        token,
        advertisement,
        _imageUrl,
        _fileName,
      );
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إنشاء الإعلان'),
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            actions: [
              TextButton(
                child: Text('موافق'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
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

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    advertisementsService = AdvertisementsService(apiClient: apiClient);
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
                  // Header section with close button
                  _buildHeader(),
                  SizedBox(height: 25),

                  // Advertisement details section
                  _buildAdvertisementDetails(),
                  SizedBox(height: 25),

                  // Target audience selection section
                  _buildTargetAudience(),
                  SizedBox(height: 25),

                  // Form submission button
                  _buildCreateButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the dialog header with title and close button
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

  /// Builds the advertisement details section containing:
  /// - Title field
  /// - Content field
  /// - Image upload section
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

  /// Builds the title input field
  Widget _buildTitleField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("العنوان *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل عنوان الإعلان",
        controller: _titleController,
        validator: (value) => _validateNotEmpty(value, "عنوان الإعلان"),
      ),
    ],
  );

  /// Builds the content input field with multiple lines
  Widget _buildContentField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("المضمون *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      CustomTextField(
        hintText: "أدخل مضمون الإعلان",
        maxLines: 3, // Allows for multiline input
        controller: _contentController,
        validator: (value) => _validateNotEmpty(value, "مضمون الإعلان"),
      ),
    ],
  );

  /// Builds the image upload section with preview capability
  Widget _buildImageSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("صورة الإعلان *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 5),
      InkWell(
        onTap: _pickImage2,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
          child: _imageBytes == null
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

  /// Builds the target audience selection section
  Widget _buildTargetAudience() {
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

  /// Builds the form submission button
  Widget _buildCreateButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Add form submission logic here
            _createAdvertisement();
          }
        },
        child: _isSubmitting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("إنشاء الإعلان"),
              ),
      ),
    ],
  );
}
