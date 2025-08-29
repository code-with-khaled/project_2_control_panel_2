import 'package:control_panel_2/models/account_model.dart';
import 'package:control_panel_2/widgets/accounts_page/dialogs/account_profile_details.dart';
import 'package:flutter/material.dart';

class AccountProfile extends StatefulWidget {
  final Account account;

  const AccountProfile({super.key, required this.account});

  @override
  State<AccountProfile> createState() => _AccountProfileState();
}

class _AccountProfileState extends State<AccountProfile> {
  bool isHovered = false; // Tracks hover state for visual feedback

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

  Widget _buildAccountOverview() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("الدور:", style: TextStyle(color: Colors.grey)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            decoration: BoxDecoration(
              color: _getStatusBgColor(widget.account.type),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.account.type,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: _getStatusColor(widget.account.type),
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
              widget.account.education,
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
            widget.account.phoneNumber,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );

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
