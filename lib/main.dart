import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/pages/accounts_page.dart';
import 'package:control_panel_2/pages/classifications_page.dart';
import 'package:control_panel_2/pages/courses_page.dart';
import 'package:control_panel_2/pages/certificates_page.dart';
import 'package:control_panel_2/pages/curriculums_page.dart';
import 'package:control_panel_2/pages/financial_receipts_page.dart';
import 'package:control_panel_2/pages/financial_reports_page.dart';
import 'package:control_panel_2/pages/home_page.dart';
import 'package:control_panel_2/pages/login_screen.dart';
import 'package:control_panel_2/pages/promotions_page.dart';
import 'package:control_panel_2/pages/students_page.dart';
import 'package:control_panel_2/pages/teachers_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  final token = TokenHelper.getToken();
  final Widget initialScreen = token != null ? MyHomePage() : LoginScreen();

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({super.key, required this.initialScreen});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'Masar Dashboard',
        debugShowCheckedModeBanner: false,
        supportedLocales: [Locale('ar')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale('ar'),
        theme: ThemeData(
          textTheme: TextTheme(
            bodySmall: TextStyle(color: Colors.black),
            bodyMedium: TextStyle(color: Colors.black),
            bodyLarge: TextStyle(color: Colors.black),
          ),
          textSelectionTheme: TextSelectionThemeData(
            selectionColor: Colors.blue.withValues(alpha: 0.2),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.black87),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(6),
                  side: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        home: initialScreen,
        routes: {
          '/courses': (context) => CoursesPage(),
          '/classifications': (context) => ClassificationsPage(),
          '/financial_reports': (context) => FinancialReportsPage(),
          '/students': (context) => StudentsPage(),
          '/teachers': (context) => TeachersPage(),
          '/promotions': (context) => PromotionsPage(),
          "/financial_receipts": (context) => FinancialReceiptsPage(),
          '/certificates': (context) => CertificatesPage(),
          "/curriculums": (context) => CurriculumsPage(),
          '/accounts': (context) => AccountsPage(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
