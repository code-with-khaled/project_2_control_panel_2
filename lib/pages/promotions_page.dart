import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/widgets/other/nav_button.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/advertisements/advertisement_section.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/discounts/discounts_section.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/notifications/notifications_section.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PromotionsPage extends StatefulWidget {
  const PromotionsPage({super.key});

  @override
  State<PromotionsPage> createState() => _PromotionsPageState();
}

class _PromotionsPageState extends State<PromotionsPage> {
  String _activeFilter = 'الإعلانات'; // Currently selected section

  /// Updates the active section filter
  void _setFilter(String filter) {
    setState(() {
      _activeFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.homepageBg,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageHeader(), // Navigation tabs for different sections
                  SizedBox(height: 25),

                  _buildNavigationTabs(),
                  SizedBox(height: 20),

                  _buildCurrentSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.campaign_outlined, size: 40),
        SizedBox(width: 7),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الحسومات والعروض الترويجية",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "إدارة الحملات الترويجية، إشعارات الإعلانات وبرامج الخصومات",
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }

  // Builds navigation tabs for sections
  Widget _buildNavigationTabs() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blueGrey[50],
      ),
      child: Row(
        children: [
          // Advertisements tab
          Expanded(
            child: NavButton(
              navkey: "الإعلانات",
              isActive: _activeFilter == "الإعلانات",
              onTap: () => _setFilter("الإعلانات"),
            ),
          ),

          // Discounts tab
          Expanded(
            child: NavButton(
              navkey: "الحسومات",
              isActive: _activeFilter == "الحسومات",
              onTap: () => _setFilter("الحسومات"),
            ),
          ),

          // Notifications tab
          Expanded(
            child: NavButton(
              navkey: "الإشعارات",
              isActive: _activeFilter == "الإشعارات",
              onTap: () => _setFilter("الإشعارات"),
            ),
          ),
        ],
      ),
    );
  }

  /// Returns the appropriate content section based on active filter
  Widget _buildCurrentSection() {
    switch (_activeFilter) {
      case "الحسومات":
        return DiscountsSection();
      case "الإشعارات":
        return NotificationsSection();
      default:
        return AdvertisementSection();
    }
  }
}
