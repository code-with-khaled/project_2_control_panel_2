import 'package:control_panel_2/widgets/promotions_page/dialogs/add_advertisement_dialog.dart';
import 'package:flutter/material.dart';

class AdvertisementSection extends StatelessWidget {
  const AdvertisementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildHeader(context), SizedBox(height: 20), _buildAds()],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "إدارة الإعلانات",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => AddAdvertisementDialog(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 10),
                Text("إنشاء إعلان"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAds() {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        for (int i = 0; i < 4; i++)
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 630),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 75),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Icon(Icons.image_outlined, color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "المعسكر التدريبي الصيفي للبرمجة",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "تعلم html, css, javascript في 12 اسبوع فقط",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 20),

                      // Actions:
                      _buildFotter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Builds Actions (edit / delete)
  Widget _buildFotter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_buildEditButton(), SizedBox(width: 5), _buildDeleteButton()],
    );
  }

  // Builds edit ad button
  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined),
            SizedBox(width: 3),
            Flexible(child: Text("تعديل")),
          ],
        ),
      ),
    );
  }

  // Builds delete ad button
  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Colors.black12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 3),
            Flexible(
              child: Text("حذف", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
