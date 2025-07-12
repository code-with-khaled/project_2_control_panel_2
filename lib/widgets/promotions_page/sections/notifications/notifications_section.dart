import 'package:control_panel_2/widgets/promotions_page/dialogs/add_notification_dialog.dart';
import 'package:flutter/material.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context), // Section header with create button
        SizedBox(height: 20),
        _buildNotifications(), // Discount cards grid
      ],
    );
  }

  /// Builds section header with title and create button
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "إدارة الإشعارات",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddNotificationDialog(),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 10),
                Text("إنشاء إشعار"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build Notifications List
  Widget _buildNotifications() {
    return Wrap(
      runSpacing: 10,
      children: [for (int i = 0; i < 3; i++) _buildNotification()],
    );
  }

  Widget _buildNotification() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "هنالك كورس جديد متاح",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "الاقتصاد والمحاسبة لغير الاختصاصيين",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Text("345 مستلم", style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 25),
          Text(
            "تاريخ الإرسال: 24-6-2024",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
