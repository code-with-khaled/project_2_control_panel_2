import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/advertisements_service.dart';
import 'package:control_panel_2/models/advertisement_model.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/edit_advertisement_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvertisementCard extends StatefulWidget {
  final VoidCallback callback;
  final Advertisement advertisement;

  const AdvertisementCard({
    super.key,
    required this.advertisement,
    required this.callback,
  });

  @override
  State<AdvertisementCard> createState() => _AdvertisementCardState();
}

class _AdvertisementCardState extends State<AdvertisementCard> {
  bool _isDeleting = false;

  Future<void> _deleteAd() async {
    if (_isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من رغبتك في حذف الإعلان ؟'),
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
      _advertisementsService.deleteAdvertisement(
        token,
        widget.advertisement.id!,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حذف الإعلان بنجاح')));

        widget.callback();

        setState(() {
          _isDeleting = false;
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  // Variables for API integration
  late AdvertisementsService _advertisementsService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _advertisementsService = AdvertisementsService(apiClient: apiClient);
  }

  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Advertisement image placeholder
            Container(
              padding: EdgeInsets.symmetric(vertical: 75),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
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

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "من:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),

                          Text(
                            (DateFormat(
                              'yyyy-MM-dd',
                            ).format(widget.advertisement.startDate)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "إلى:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 5),

                          Text(
                            (DateFormat(
                              'yyyy-MM-dd',
                            ).format(widget.advertisement.endDate)),
                          ),
                        ],
                      ),
                    ],
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
        showDialog(
          context: context,
          builder: (context) => EditAdvertisementDialog(
            callback: widget.callback,
            advertisement: widget.advertisement,
          ),
        );
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
            Icon(Icons.edit_outlined, color: Colors.green),
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
        _deleteAd();
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
        child: _isDeleting
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.red,
                ),
              )
            : Row(
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
