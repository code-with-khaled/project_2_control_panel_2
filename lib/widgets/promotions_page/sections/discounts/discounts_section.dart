import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/discount_service.dart';
import 'package:control_panel_2/models/course_model.dart';
import 'package:control_panel_2/models/discount_model.dart';
import 'package:control_panel_2/widgets/promotions_page/dialogs/add_discount_dialog.dart';
import 'package:control_panel_2/widgets/promotions_page/sections/discounts/discount_card.dart';
import 'package:flutter/material.dart';

/// Displays and manages discount coupons with:
/// - Responsive grid layout
/// - Discount details and statistics
/// - Edit and deactivation functionality
class DiscountsSection extends StatefulWidget {
  const DiscountsSection({super.key});

  @override
  State<DiscountsSection> createState() => _DiscountsSectionState();
}

class _DiscountsSectionState extends State<DiscountsSection> {
  bool _isLoading = true;

  List<Discount> _discounts = [
    Discount(
      id: 1,
      value: 1,
      type: "قيمة مقطوعة",
      discountableId: 1,
      course: Course(
        id: 1,
        name: "name",
        image: 'image',
        description: "description",
        categoryName: "categoryName",
        price: 1,
        teacher: CourseTeacher(
          id: 1,
          firstName: "firstName",
          lastName: "lastName",
        ),
        rating: 0,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        level: "level",
        enrollments: 1,
        numberOfHours: 1,
      ),
      expirationDate: "2025-09-06",
    ),
  ];

  Future<void> _loadDiscounts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final token = TokenHelper.getToken();
      final response = await _discountService.fetchDiscounts(token);

      if (mounted) {
        setState(() {
          _discounts += response;
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تحميل الحسومات'),
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

  void _refreshDiscounts() {
    _loadDiscounts();
  }

  late DiscountService _discountService;

  @override
  void initState() {
    super.initState();

    final apiClient = ApiHelper.getClient();

    _discountService = DiscountService(apiClient: apiClient);

    _loadDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isLoading) _buildLoadingState(),

        if (!_isLoading) ...[
          _buildHeader(),
          SizedBox(height: 20),

          _buildDiscounts(),
        ],
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

  /// Builds section header with title and create button
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "إدارة الحسومات",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  AddDiscountDialog(callback: _refreshDiscounts),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Icon(Icons.add),
                SizedBox(width: 10),
                Text("إنشاء حسم"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Builds responsive grid of discount cards
  Widget _buildDiscounts() {
    return _discounts.isEmpty
        ? _buildEmptyState()
        : LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive column count
              const double itemWidth = 300; // Minimum card width
              int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
              itemsPerRow = itemsPerRow.clamp(
                1,
                3,
              ); // Limit between 1-3 columns

              return Wrap(
                spacing: 20, // Horizontal space between cards
                runSpacing: 20, // Vertical space between rows
                children: [
                  for (var discount in _discounts)
                    SizedBox(
                      width:
                          (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                          itemsPerRow,
                      child: DiscountCard(
                        callback: _refreshDiscounts,
                        discount: discount,
                      ),
                    ),
                ],
              );
            },
          );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا يوجد حسومات',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
