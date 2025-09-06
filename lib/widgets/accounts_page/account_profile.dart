import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/account_service.dart';
import 'package:control_panel_2/models/account_model.dart';
import 'package:control_panel_2/widgets/accounts_page/dialogs/account_profile_details.dart';
import 'package:control_panel_2/widgets/accounts_page/dialogs/edit_account_dialog.dart';
import 'package:flutter/material.dart';

class AccountProfile extends StatefulWidget {
  final Account account;
  final VoidCallback callback;

  const AccountProfile({
    super.key,
    required this.account,
    required this.callback,
  });

  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile> {
  bool isHovered = false; // Tracks hover state for visual feedback
  bool _isDeleting = false;

  late AccountService _accountService;

  Future<void> _deleteAccount() async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        title: Text('تأكيد الحذف'),
        content: Text(
          'هل أنت متأكد من رغبتك في حذف حساب ${widget.account.fullName}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء', style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final token = TokenHelper.getToken();
      _accountService.deleteAccount(token, widget.account.id!);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حذف الحساب بنجاح')));

        widget.callback();
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _accountService = AccountService(apiClient: apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(6),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile header with avatar and name
            _buildProfileHeader(),
            SizedBox(height: 10),

            _buildAccountOverview(),
            SizedBox(height: 20),

            _buildViewButton(),
          ],
        ),
      ),
    );
  }

  // Builds profile header with avatar and name
  Widget _buildProfileHeader() => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(radius: 27, child: Icon(Icons.person)),
      SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.account.fullName,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            widget.account.username,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    ],
  );

  Widget _buildAccountOverview() {
    final type = widget.account.type == "staff" ? "إداري" : "محاسب";

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("الدور:", style: TextStyle(color: Colors.grey)),
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
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "المستوى الدراسي:",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            Flexible(
              child: Text(
                widget.account.educationLevel,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("رقم الهاتف:", style: TextStyle(color: Colors.grey)),
            Text(
              widget.account.phone,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewButton() => Row(
    children: [
      Expanded(
        child: ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) =>
                AccountProfileDetails(account: widget.account),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 17.5),
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black26),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.remove_red_eye_outlined),
              SizedBox(width: 10),
              Text(
                "عرض التفاصيل",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 5),

      ElevatedButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => EditAccountDialog(
            account: widget.account,
            callback: widget.callback,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 17.5),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Icon(Icons.edit, color: Colors.green),
      ),
      SizedBox(width: 5),

      ElevatedButton(
        onPressed: () {
          _deleteAccount();
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 17.5),
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: _isDeleting
            ? CircularProgressIndicator(strokeWidth: 2)
            : Icon(Icons.delete_forever_outlined, color: Colors.red),
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
