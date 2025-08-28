import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/notification_service.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Dialog for composing and sending notifications to users
///
/// Provides title and message input fields with send functionality
class SendNotificationDialog extends StatefulWidget {
  final int id;

  const SendNotificationDialog({super.key, required this.id});

  @override
  State<SendNotificationDialog> createState() => _SendNotificationDialogState();
}

class _SendNotificationDialogState extends State<SendNotificationDialog> {
  // Form key for validation control
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _messageController = TextEditingController();

  bool _isSending = false;

  Future<void> _sendNotification() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final token = TokenHelper.getToken();
      await _notificationService.sendToStudent(
        token,
        _messageController.text.trim(),
        widget.id,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم إرسال الإشعار')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في إرسال الإشعار'),
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
          _isSending = false;
        });
      }
    }
  }

  late NotificationService _notificationService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _notificationService = NotificationService(apiClient: apiClient);
  }

  // Validation function
  String? _validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرسالة مطلوبة';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 800, // Maximum dialog width
          maxHeight:
              MediaQuery.of(context).size.height * 0.8, // 80% of screen height
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
                  _buildContentForm(),
                  SizedBox(height: 20),

                  // Send action button
                  _buildSendButton(),
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
        // Notification icon button (also closes dialog)
        IconButton(
          icon: Icon(Icons.notifications_none),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
        ),
        SizedBox(width: 7),

        // Dialog title
        Text(
          "إرسال إشعار", // "Send Notification"
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

  // Builds the notification content input form
  Widget _buildContentForm() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            "محتوى الإشعار", // "Notification Content"
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 25),

          // Message input field
          _buildMessageField(),
        ],
      ),
    );
  }

  // Builds message input field
  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الرسالة", // "Message"
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        CustomTextField(
          hintText: "أدخل محتوى الإشعار",
          controller: _messageController,
          maxLines: 2,
          validator: (value) => _validateMessage(value),
        ),
      ],
    );
  }

  // Builds send notification button
  Widget _buildSendButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _sendNotification();
            }
          },
          child: _isSending
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.send_outlined),
                      SizedBox(width: 10),
                      Text("إرسال الإشعار"), // "Send Notification"
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
