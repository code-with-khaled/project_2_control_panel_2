import 'package:control_panel_2/constants/all_accounts.dart';
import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/core/helper/api_helper.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/account_service.dart';
import 'package:control_panel_2/models/account_model.dart';
import 'package:control_panel_2/widgets/accounts_page/account_profile.dart';
import 'package:control_panel_2/widgets/accounts_page/dialogs/new_account_dialog.dart';
import 'package:control_panel_2/widgets/search_widgets/search_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Accounts management page that displays and filters administrative and accounting accounts
class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  // Controller for search text field
  final TextEditingController _searchController = TextEditingController();

  // Current search query value
  String _searchQuery = '';

  List<Account> _accounts = [];
  bool _isLoading = true;

  // Currently selected filter value from dropdown
  String? dropdownValue = "جميع الحسابات";

  /// Computed property that filters accounts based on:
  /// 1. Current search query (matches against name or username)
  /// 2. Selected account type filter (admin, accountant, or all)
  List<Account> get _filteredAccounts {
    // Initial filtering by search query
    List<Account> results = _accounts.where((account) {
      final name = account.fullName.toString().toLowerCase();
      final username = account.username.toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || username.contains(query);
    }).toList();

    // Apply additional filtering based on selected account type
    switch (dropdownValue!) {
      case 'الإداريين': // Filter for admin accounts only
        results = results.where((account) => account.type == "staff").toList();
        break;
      case 'المحاسبين': // Filter for accountant accounts only
        results = results
            .where((account) => account.type == "finance")
            .toList();
        break;
      default: // 'جميع الحسابات' - show all accounts without additional filtering
        break;
    }

    return results;
  }

  Future<void> _loadAccounts() async {
    try {
      final token = TokenHelper.getToken();
      final response = await _accountService.fetchAccounts(token);

      if (mounted) {
        setState(() {
          _accounts += response;
        });
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('خطأ في تحميل الحسابات'),
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

  void _refreshAccounts() {
    _loadAccounts();
  }

  late AccountService _accountService;

  @override
  void initState() {
    super.initState();
    // Set up listener for search text field changes
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    final apiClient = ApiHelper.getClient();
    _accountService = AccountService(apiClient: apiClient);

    _loadAccounts();
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
              // Constrain maximum content width for larger screens
              constraints: BoxConstraints(maxWidth: 1280),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page header with title and create button
                  _buildPageHeader(),
                  SizedBox(height: 25),

                  if (_isLoading) _buildLoadingState(),

                  if (!_isLoading) ...[
                    // Overview cards showing account statistics
                    _buildOverviewCards(),
                    SizedBox(height: 25),

                    // Search and filter controls section
                    _buildSearchSection(),
                    SizedBox(height: 20),

                    // Grid displaying filtered accounts
                    _buildAccountsGrid(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the page header containing:
  /// - Page title
  /// - Description
  /// - Create account button
  Widget _buildPageHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                "إدارة الحسابات",
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      NewAccountDialog(callback: _refreshAccounts),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 10),
                      Text("إنشاء حساب"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          "إدارة وإنشاء حسابات الإداريين والمحاسبين",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
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

  /// Builds responsive overview cards showing account statistics:
  /// - Total accounts count
  /// - Admin accounts count
  /// - Accountant accounts count
  Widget _buildOverviewCards() {
    final accountants = _accounts
        .where((account) => account.type == "finance")
        .length;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Horizontal layout for wider screens
        if (constraints.maxWidth >= 600) {
          return Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  "مجمل الحسابات",
                  _accounts.length.toString(),
                  Icon(Icons.group_outlined, color: Colors.black, size: 32),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "الإداريين",
                  (_accounts.length - accountants).toString(),
                  Icon(Icons.person_outline, color: Colors.blue, size: 32),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildOverviewCard(
                  "المحاسبين",
                  accountants.toString(),
                  Icon(Icons.person_outline, color: Colors.green, size: 32),
                ),
              ),
            ],
          );
        } else {
          // Vertical layout for narrower screens
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOverviewCard(
                "مجمل الحسابات",
                allAccounts.length.toString(),
                Icon(Icons.group_outlined, color: Colors.black, size: 32),
              ),
              SizedBox(height: 15),
              _buildOverviewCard(
                "الإداريين",
                (allAccounts.length - accountants).toString(),
                Icon(Icons.person_outline, color: Colors.blue, size: 32),
              ),
              SizedBox(height: 15),
              _buildOverviewCard(
                "المحاسبين",
                accountants.toString(),
                Icon(Icons.person_outline, color: Colors.green, size: 32),
              ),
            ],
          );
        }
      },
    );
  }

  /// Builds a single overview card widget displaying:
  /// - Title (e.g., "Total Accounts")
  /// - Count number
  /// - Relevant icon
  Widget _buildOverviewCard(String title, String number, Icon icon) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black87)),
              Text(
                number,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ],
          ),
          icon,
        ],
      ),
    );
  }

  /// Builds the search and filter controls section containing:
  /// - Search text field
  /// - Account type dropdown filter
  Widget _buildSearchSection() {
    return Row(
      children: [
        // Search field
        Expanded(
          child: SearchField(
            controller: _searchController,
            hintText: "ابحث في الحسابات...",
          ),
        ),
        SizedBox(width: 20),
        // Account type filter dropdown
        Container(
          width: 180,
          color: Colors.white,
          child: DropdownButtonFormField<String>(
            value: dropdownValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black26),
                borderRadius: BorderRadius.circular(6),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue;
              });
            },
            items: <String>['جميع الحسابات', 'المحاسبين', 'الإداريين']
                .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                .toList(),
          ),
        ),
      ],
    );
  }

  /// Builds a responsive grid of account profile cards
  /// Automatically adjusts number of columns based on available width
  Widget _buildAccountsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on available width
        const double itemWidth = 270; // Minimum card width
        int itemsPerRow = (constraints.maxWidth / itemWidth).floor();
        itemsPerRow = itemsPerRow.clamp(1, 3); // Limit between 1-3 columns

        final accounts = _filteredAccounts;

        // Show empty state if no accounts match filters
        if (accounts.isEmpty) {
          return _buildEmptyState();
        }

        // Build responsive grid of account cards
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final account in accounts)
              SizedBox(
                width:
                    (constraints.maxWidth - (20 * (itemsPerRow - 1))) /
                    itemsPerRow,
                child: AccountProfile(account: account),
              ),
          ],
        );
      },
    );
  }

  /// Builds empty state message shown when no accounts match current filters
  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: Text(
          'لا توجد نتائج',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
