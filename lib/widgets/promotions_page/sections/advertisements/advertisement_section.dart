import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/advertisements_service.dart';
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
class AdvertisementSection extends StatefulWidget {
  const AdvertisementSection({super.key});

  @override
  State<AdvertisementSection> createState() => _AdvertisementSectionState();
}

class _AdvertisementSectionState extends State<AdvertisementSection> {
  bool _isLoading = false;
  List<Advertisement> _ads = [];

  Future<void> _loadAds() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _advertisementsService.fetchAdvertisements(token);
      setState(() {
        _ads = response;
      });
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تحميل الإعلانات'),
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
          _isLoading = false;
        });
      }
    }
  }

  void _refreshAds() {
    _loadAds();
  }

  late AdvertisementsService _advertisementsService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();
    _advertisementsService = AdvertisementsService(apiClient: apiClient);

    _loadAds();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isLoading) _buildLoadingState(),
        if (!_isLoading) ...[
          _buildHeader(context),
          SizedBox(height: 20),
          _buildAds(),
        ],
      ],
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
            builder: (context) => AddAdvertisementDialog(callback: _refreshAds),
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

  // Build loading state
  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.blue,
          padding: EdgeInsets.all(20),
        ),
      ),
    );
  }

  /// Builds the grid of advertisement cards
  Widget _buildAds() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive column count
        const double itemWidth = 300; // Minimum card width
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 3); // Limit between 1-3 columns

        return Wrap(
          spacing: 20, // Horizontal space between cards
          runSpacing: 20, // Vertical space between rows
          children: [
            for (var advertisement in _ads)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: AdvertisementCard(
                  callback: _refreshAds,
                  advertisement: advertisement,
                ),
              ),
          ],
        );
      },
    );
  }
}
