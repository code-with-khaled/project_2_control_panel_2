import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/notification_service.dart';
import 'package:control_panel_2/widgets/other/custom_text_field.dart';
import 'package:control_panel_2/widgets/other/nav_button.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/notifications/sections/specific_student_section.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/notifications/sections/specific_teacher_section.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddNotificationDialog extends StatefulWidget {
  const AddNotificationDialog({super.key});

  @override
  State<AddNotificationDialog> createState() => _AddNotificationDialogState();
}

class _AddNotificationDialogState extends State<AddNotificationDialog> {
  // Form key for validation and form state management
  final _formKey = GlobalKey<FormState>();

  // Controllers for notification content input fields
  final TextEditingController _messageController = TextEditingController();

  // State variables
  String _activeFilter = "جميع الطلاب"; // Currently selected section

  /// Updates the active section filter
  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  // Validation function
  String? _validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'محتوى الرسالة مطلوب';
    }
    return null;
  }

  // User id
  int? id;

  void _getId(int? id) {
    setState(() {
      this.id = id;
    });
  }

  bool _isSending = false;

  Future<void> _sendNotification() async {
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    try {
      final token = TokenHelper.getToken();
      final message = _messageController.text.trim();
      switch (_activeFilter) {
        case "جميع المعلمين":
          await _notificationService.sendToAllTeachers(token, message);
        case "طالب محدد":
          await _notificationService.sendToStudent(token, message, id!);
        case "معلم محدد":
          await _notificationService.sendToTeacher(token, message, id!);
        default:
          await _notificationService.sendToAllStudents(token, message);
      }

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
                  _buildContentForm(),
                  SizedBox(height: 20),

                  // Target Audience
                  _buildTargetAudience(),
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
          "الرسالة",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        CustomTextField(
          controller: _messageController,
          hintText: "أدخل محتوى الرسالة",
          maxLines: 3,
          validator: _validateMessage,
        ),
      ],
    );
  }

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

          // Navigation tabs for different sections
          _buildNavigationTabs(),
          SizedBox(height: 20),

          // Dynamic content section
          _buildCurrentSection(),
        ],
      ),
    );
  }

  // Builds navigation tabs for profile sections
  Widget _buildNavigationTabs() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueGrey[50],
      ),
      child: Row(
        children: [
          // All students tab
          Expanded(
            child: NavButton(
              navkey: "جميع الطلاب",
              isActive: _activeFilter == "جميع الطلاب",
              onTap: () => _setFilter("جميع الطلاب"),
            ),
          ),

          // All teachers tab
          Expanded(
            child: NavButton(
              navkey: "جميع المعلمين",
              isActive: _activeFilter == "جميع المعلمين",
              onTap: () => _setFilter("جميع المعلمين"),
            ),
          ),

          // Specific student tab
          Expanded(
            child: NavButton(
              navkey: "طالب محدد",
              isActive: _activeFilter == "طالب محدد",
              onTap: () => _setFilter("طالب محدد"),
            ),
          ),

          // Specific teacher tab
          Expanded(
            child: NavButton(
              navkey: "معلم محدد",
              isActive: _activeFilter == "معلم محدد",
              onTap: () => _setFilter("معلم محدد"),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate content section based on active filter
  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      case "جميع المعلمين":
        return Text(
          "هذا الإشعار سيكون لجميع المعلمين",
          style: TextStyle(color: Colors.grey),
        );
      case "طالب محدد":
        return SpecificStudentSection(onMessageChanged: _getId);
      case "معلم محدد":
        return SpecificTeacherSection(onMessageChanged: _getId);
      default:
        return Text(
          "هذا الإشعار سيكون لجميع الطلاب",
          style: TextStyle(color: Colors.grey),
        );
    }
  }

  // Builds send notification button
  Widget _buildSendButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (id == null &&
                  (_activeFilter == "طالب محدد" ||
                      _activeFilter == "معلم محدد")) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('خطأ في إرسال الإشعار'),
                    content: Text("يجب اختيار مستخدم محدد لإرسال الإشعار"),
                    actions: [
                      TextButton(
                        child: Text('موافق'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              } else {
                _sendNotification();
              }
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
