import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/advertisements_service.dart';
import 'package:control_panel_2/models/advertisement_model.dart';
import 'package:flutter/material.dart';

// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Variables for selecting dates
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // Variables for storing the advertisement image
  String? _imageUrl;
  String? _fileName;

  /// Opens file picker to select an image for the advertisement
  ///
  /// Sets [_imageUrl] and [_fileName] when a file is selected

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

  // Date picker functions
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 2, now.month, now.day),
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
    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year, now.month, now.day + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: endDate,
      lastDate: DateTime(endDate.year + 3, endDate.month, endDate.day),
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
    if (picked != null && picked != _selectedEndDate) {
      setState(() {
        _selectedEndDate = picked;
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  // Validation functions
  String? _validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'تاريخ البدء مطلوب';
    }
    return null;
  }

  String? _validateEndDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'تاريخ الانتهاء مطلوب';
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
      startDate: _startDateController.text,
      endDate: _endDateController.text,
    );

    try {
      final token = TokenHelper.getToken();
      await advertisementsService.createAdvertisement(
        token,
        advertisement,
        _imageUrl,
        _fileName,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إنشاء الإعلان بنجاح')));
        // widget.callback();
        Navigator.pop(context);
      }
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
          _buildImageSection(),
          SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildStartDate()),
              SizedBox(width: 10),
              Expanded(child: _buildEndDate()),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the image upload section with preview capability
  Widget _buildImageSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("صورة الإعلان *", style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildStartDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ البدء *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      TextFormField(
        controller: _startDateController,
        decoration: InputDecoration(
          hintText: 'mm/dd/yyyy',
          suffixIcon: Icon(Icons.calendar_today),
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
        onTap: () => _selectStartDate(context),
        validator: _validateStartDate,
      ),
    ],
  );

  Widget _buildEndDate() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("تاريخ الإنتهاء *", style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 2),
      TextFormField(
        controller: _endDateController,
        decoration: InputDecoration(
          hintText: 'mm/dd/yyyy',
          suffixIcon: Icon(Icons.calendar_today),
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
        onTap: () => _selectEndDate(context),
        validator: _validateEndDate,
      ),
    ],
  );

  /// Builds the form submission button
  Widget _buildCreateButton() => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ElevatedButton(
        onPressed: () {
          if (_imageUrl == null) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('خطأ في إنشاء الإعلان'),
                content: Text("يجب اختيار صورة للإعلان"),
                actions: [
                  TextButton(
                    child: Text('موافق'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          } else if (_formKey.currentState!.validate()) {
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
