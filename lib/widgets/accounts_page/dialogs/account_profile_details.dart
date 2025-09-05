import 'package:control_panel_2/models/account_model.dart';
import 'package:flutter/material.dart';

class AccountProfileDetails extends StatefulWidget {
  final Account account;

  const AccountProfileDetails({super.key, required this.account});

  @override
  State<AccountProfileDetails> createState() => _AccountProfileDetailsState();
}

class _AccountProfileDetailsState extends State<AccountProfileDetails> {
  final _imageBytes = null;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
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

                // Profile Picture
                _buildProfilePicture(),

                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),

                _buildContactInfo(),

                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),

                _buildProfessionalInfo(),
                SizedBox(height: 25),

                _buildAccountPermissions(),
                SizedBox(height: 30),

                // Submit button
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
        "تفاصيل الحساب",
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

  Widget _buildProfilePicture() {
    final type = widget.account.type == "staff" ? "إداري" : "محاسب";

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage: _imageBytes != null
                ? MemoryImage(_imageBytes!)
                : null,
            child: _imageBytes == null
                ? Icon(Icons.camera_alt_outlined, color: Colors.grey)
                : null,
          ),
          SizedBox(height: 10),
          Text(
            widget.account.fullName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            widget.account.username,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: _getStatusBgColor(type),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: _getStatusColor(type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.phone_outlined),
          SizedBox(width: 5),
          Text(
            "معلومات التواصل",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("رقم الموبايل:", style: TextStyle(color: Colors.grey)),
          Text(
            widget.account.phone,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("اسم المستخدم:", style: TextStyle(color: Colors.grey)),
          Text(
            widget.account.username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );

  Widget _buildProfessionalInfo() => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_outlined),
          SizedBox(width: 5),
          Text(
            "المعلومات المهنية",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("الدور:", style: TextStyle(color: Colors.grey)),
          Text(
            widget.account.type!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("المستوى الدراسي:", style: TextStyle(color: Colors.grey)),
          Text(
            widget.account.educationLevel,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("رقم المعرف:", style: TextStyle(color: Colors.grey)),
          Text(
            widget.account.type == "إداري" ? '2' : '3',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );

  Widget _buildAccountPermissions() => Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.shield_outlined, size: 16),
        SizedBox(width: 8),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "صلاحيات الحساب",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              widget.account.type == "إداري"
                  ? Text(
                      "للإداري صلاحية الوصول لجميع الأمور الإدارية التي تخص الطلاب، الكورسات، والدورات ودورات المناهج وكذلك للعروض الترويجية والإشعارات.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    )
                  : Text(
                      "المحاسب له صلاحية كاملة على الشؤون المالية وعرض التقارير المالية وتحديد رواتب المدرسين.",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildSubmitButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("تم"),
          ),
        ),
      ),
    ],
  );

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'إداري':
        return Colors.blue.shade100;
      default:
        return Colors.green.shade100;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'إداري':
        return Colors.blue.shade900;
      default:
        return Colors.green.shade800;
    }
  }
}
