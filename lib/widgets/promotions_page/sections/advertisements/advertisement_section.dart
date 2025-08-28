import 'package:control_panel_2/models/advertisement_model.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/add_advertisement_dialog.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/advertisements/advertisement_card.dart';
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
          AdvertisementCard(
            advertisement: Advertisement(
              id: 1,
              media: "",
              type: "image",
              startDate: "2025-08-28",
              endDate: "2025-09-27",
            ),
          ),
      ],
    );
  }
}
