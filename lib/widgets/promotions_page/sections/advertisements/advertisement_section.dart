import 'package:control_panel_2/widgets/promotions_page/dialogs/add_advertisement_dialog.dart';
import 'package:flutter/material.dart';

/// A widget that displays and manages advertisements in a grid layout
///
/// Features:
/// - Header with "Manage Advertisements" title and create button
/// - Grid of advertisement cards
/// - Each card shows placeholder image, title, description, and action buttons
class AdvertisementSection extends StatelessWidget {
  const AdvertisementSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildHeader(context), SizedBox(height: 20), _buildAds()],
    );
  }

  /// Builds the section header with title and create button
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

  /// Builds the grid of advertisement cards
  Widget _buildAds() {
    return Wrap(
      spacing: 20, // Horizontal space between cards
      runSpacing: 20, // Vertical space between rows
      children: [
        for (int i = 0; i < 4; i++)
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 630),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Advertisement image placeholder
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

                // Advertisement details
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

                      // Action buttons
                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Builds the action buttons footer (edit/delete)
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [_buildEditButton(), SizedBox(width: 5), _buildDeleteButton()],
    );
  }

  /// Builds the edit advertisement button
  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {
        // Open AddAdvertisementDialog but with existing data
      },
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

  /// Builds the delete advertisement button
  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: () {
        // Add confirmation dialog before deletion
      },
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
