import 'package:control_panel_2/models/account_model.dart';

final List<Account> allAccounts = [
  // المحاسبون
  Account(
    type: 'محاسب',
    firstName: 'لينا',
    lastName: 'حداد',
    username: 'lina.haddad92',
    phoneNumber: '963-944-112-233+',
    education: 'بكالوريوس في المحاسبة',
    roleId: 2,
  ),
  Account(
    type: 'محاسب',
    firstName: 'طارق',
    lastName: 'سالم',
    username: 'tariq.salem88',
    phoneNumber: '963-933-445-566+',
    education: 'دبلوم في المالية',
    roleId: 2,
  ),

  // التنفيذيون
  Account(
    type: 'إداري',
    firstName: 'نور',
    lastName: 'قاسم',
    username: 'nour.qassem01',
    phoneNumber: '963-991-223-344+',
    education: 'ماجستير إدارة أعمال',
    roleId: 1,
  ),
  Account(
    type: 'إداري',
    firstName: 'فادي',
    lastName: 'زين',
    username: 'fadi.zein77',
    phoneNumber: '963-944-556-677+',
    education: 'بكالوريوس في إدارة الأعمال',
    roleId: 1,
  ),
  Account(
    type: 'إداري',
    firstName: 'رنا',
    lastName: 'دارويش',
    username: 'rana.darwish23',
    phoneNumber: '963-955-667-788+',
    education: 'ماجستير في الإدارة',
    roleId: 1,
  ),
];
