import 'package:control_panel_2/constants/custom_colors.dart';
import 'package:control_panel_2/constants/sections_consts.dart';
import 'package:control_panel_2/core/api/api_client.dart';
import 'package:control_panel_2/core/helper/token_helper.dart';
import 'package:control_panel_2/core/services/auth_service.dart';
import 'package:control_panel_2/pages/login_screen.dart';
import 'package:control_panel_2/widgets/other/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoggingout = false;

  Future<void> _logout() async {
    if (_isLoggingout) return;

    setState(() {
      _isLoggingout = true;
    });

    try {
      final apiClient = ApiClient(
        baseUrl: "http://127.0.0.1:8000/api",
        httpClient: http.Client(),
      );

      final authService = AuthService(apiClient: apiClient);

      authService.logout(TokenHelper.getToken()!);
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) =>
            AlertDialog(title: Text('خطأ'), content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoggingout = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.homepageBg,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 1120),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: AssetImage("assets/logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _logout(),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 25,
                          ),
                        ),
                        child: _isLoggingout
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.logout_outlined),
                                  SizedBox(width: 10),
                                  Text("تسجيل الخروج"),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.school_outlined, size: 40),
                  SizedBox(width: 10),
                  Text(
                    "لوحة تحكم مسار التعليم", // "MasarEdu Control Panel"
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: Text(
                  "نظام إدارة شامل للمؤسسات التعليمية. راقب الطلاب، وأدر المدرسين، وتتبع التقدم كلها في مكان واحد", // Translated description
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl, // Right-align Arabic text
                ),
              ),
              SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1120),
                child: Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  children: [
                    for (int i = 0; i < sections.length; i++)
                      SectionWidget(
                        title: sections[i]["title"] as String,
                        icon: sections[i]["icon"] as Icon,
                        description: sections[i]["description"] as String,
                        routeName: sections[i]["route"] as String?,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
