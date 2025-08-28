import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/advertisements_service.dart';
import 'package:control_panel_2/models/advertisement_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdvertisementCard extends StatefulWidget {
  final Advertisement advertisement;

  const AdvertisementCard({super.key, required this.advertisement});

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
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من رغبتك في حذف الإعلان ؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إلغاء'),
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

        // widget.callback();

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

    final apiClient = ApiClient(
      baseUrl: "http://127.0.0.1:8000/api",
      httpClient: http.Client(),
    );

    _advertisementsService = AdvertisementsService(apiClient: apiClient);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
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
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
