import 'package:control_panel_2/widgets/other/nav_button.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/notifications/sections/specific_student_section.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/notifications/sections/specific_teacher_section.dart';
import 'package:flutter/material.dart';

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
          "الرسالة", // "Message"
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2),
        TextField(
          controller: _messageController,
          cursorColor: Colors.blue,
          maxLines: 3, // Allow multiline input
          textDirection: TextDirection.rtl, // Right-align Arabic text
          decoration: InputDecoration(
            hintText: "أدخل محتوى الإشعار", // "Enter notification message"
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black87),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
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
        return SpecificStudentSection();
      case "معلم محدد":
        return SpecificTeacherSection();
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
          onPressed: () {},
          child: Padding(
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
