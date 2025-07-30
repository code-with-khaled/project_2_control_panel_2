import 'package:flutter/material.dart';

final List<Map<String, dynamic>> sections = [
  {
    "icon": Icon(Icons.bar_chart, color: Colors.lightBlue),
    "title": "إحصائيات لوحة التحكم", // "Dashboard Statistics"
    "description":
        "رؤى وتحليلات فورية لمتابعة أداء المؤسسة وتمثيل البيانات المرئي.", // Translated
  },
  {
    "icon": Icon(Icons.description_outlined, color: Colors.lightGreen),
    "title": "التقارير الإدارية والمالية", // "Admin & Financial Reports"
    "description":
        "إنشاء تقارير إدارية ومالية شاملة لاتخاذ قرارات أفضل.", // Translated
  },
  {
    "icon": Icon(Icons.import_contacts, color: Colors.purpleAccent),
    "title": "إدارة الدورات", // "Courses Management"
    "description":
        "إنشاء وتعديل وإدارة الدورات التدريبية مع أدوات تخطيط منهجية شاملة.", // Translated
    "route": "/courses",
  },
  {
    "icon": Icon(Icons.local_offer_outlined, color: Colors.orangeAccent),
    "title": "تصنيف الدورات", // "Courses Categorization"
    "description":
        "تنظيم وتصنيف الدورات لتسهيل التصفح واكتشاف المحتوى.", // Translated
    "route": "/classifications",
  },
  {
    "icon": Icon(Icons.group, color: Colors.blue),
    "title": "إدارة الطلاب", // "Students Management"
    "description":
        "ملفات تعريف شاملة للطلاب مع متابعة التقدم وتحليلات الأداء الأكاديمي.", // Translated
    "route": "/students",
  },
  {
    "icon": Icon(Icons.group, color: Colors.blue),
    "title": "إدارة المعلمين", // "Teachers Management"
    "description":
        "إدارة ملفات المعلمين، تعيين الدورات، وتقييمات الأداء.", // Translated
    "route": "/teachers",
  },
  {
    "icon": Icon(Icons.campaign_outlined, color: Colors.red),
    "title": "العروض الترويجية", // "Promotional Offers"
    "description":
        "إدارة الحملات الترويجية، إشعارات الإعلانات وبرامج الخصومات.", // Translated
    "route": "/promotions",
  },
  {
    "icon": Icon(Icons.receipt_long_outlined, color: Colors.green),
    "title": "الإيصالات المالية", // "Financial Receipts"
    "description":
        "معالجة إيصالات الدفع وأوامر الصرف لمتابعة مالية شاملة.", // Translated
  },
  {
    "icon": Icon(Icons.menu_book, color: Colors.teal),
    "title": "إدارة المناهج", // "Curriculum Management"
    "description":
        "تصميم وإدارة أقسام المنهج مع مسارات تعليمية منظمة.", // Translated
    "route": "/curriculums",
  },
  {
    "icon": Icon(Icons.military_tech, color: Colors.yellow),
    "title": "تصدير الشهادات", // "Certificate Exporting"
    "description":
        "إنشاء وتصدير شهادات إتمام الدورات والإنجازات.", // Translated
    "route": "/certificates",
  },
];
