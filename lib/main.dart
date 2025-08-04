import 'package:control_panel_2/pages/accounts_page.dart';
import 'package:control_panel_2/pages/classifications_page.dart';
import 'package:control_panel_2/pages/courses_page.dart';
import 'package:control_panel_2/pages/certificates_page.dart';
import 'package:control_panel_2/pages/curriculums_page.dart';
import 'package:control_panel_2/pages/home_page.dart';
import 'package:control_panel_2/pages/promotions_page.dart';
import 'package:control_panel_2/pages/students_page.dart';
import 'package:control_panel_2/pages/teachers_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'Flutter Demo',
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
        home: const MyHomePage(),
        routes: {
          '/courses': (context) => CoursesPage(),
          '/classifications': (context) => ClassificationsPage(),
          '/students': (context) => StudentsPage(),
          '/teachers': (context) => TeachersPage(),
          '/promotions': (context) => PromotionsPage(),
          '/certificates': (context) => CertificatesPage(),
          "/curriculums": (context) => CurriculumsPage(),
          '/accounts': (context) => AccountsPage(),
        },
      ),
    );
  }
}
