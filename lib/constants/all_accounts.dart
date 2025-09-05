import 'package:control_panel_2/models/account_model.dart';

final List<Account> allAccounts = [
  // المحاسبون
  Account(
    type: 'محاسب',
    firstName: 'لينا',
    lastName: 'حداد',
    username: 'lina.haddad92',
    phone: '963-944-112-233+',
    educationLevel: 'بكالوريوس في المحاسبة',
    roleId: 2,
    id: 1,
  ),
  Account(
    type: 'محاسب',
    firstName: 'طارق',
    lastName: 'سالم',
    username: 'tariq.salem88',
    phone: '963-933-445-566+',
    educationLevel: 'دبلوم في المالية',
    roleId: 2,
    id: 2,
  ),

  // التنفيذيون
  Account(
    type: 'إداري',
    firstName: 'نور',
    lastName: 'قاسم',
    username: 'nour.qassem01',
    phone: '963-991-223-344+',
    educationLevel: 'ماجستير إدارة أعمال',
    roleId: 1,
    id: 3,
  ),
  Account(
    type: 'إداري',
    firstName: 'فادي',
    lastName: 'زين',
    username: 'fadi.zein77',
    phone: '963-944-556-677+',
    educationLevel: 'بكالوريوس في إدارة الأعمال',
    roleId: 1,
    id: 4,
  ),
  Account(
    type: 'إداري',
    firstName: 'رنا',
    lastName: 'دارويش',
    username: 'rana.darwish23',
    phone: '963-955-667-788+',
    educationLevel: 'ماجستير في الإدارة',
    roleId: 1,
    id: 5,
  ),
];
