import 'package:flutter/material.dart';

final List<Map<String, dynamic>> sections = [
  {
    "icon": Icon(Icons.bar_chart, color: Colors.lightBlue),
    "title": "Dashboard Statistics",
    "description":
        "Real-time insights and analytics for institutional performance tracking and data virtualization.",
  },
  {
    "icon": Icon(Icons.description_outlined, color: Colors.lightGreen),
    "title": "Admin & Financial Reports",
    "description":
        "Generate comprehensive administrative and financial reports for better decision making.",
  },
  {
    "icon": Icon(Icons.menu_book, color: Colors.purpleAccent),
    "title": "Courses Management",
    "description":
        "Create, edit, and manage training courses with comprehensive curriculum planning tools.",
  },
  {
    "icon": Icon(Icons.local_offer_outlined, color: Colors.orangeAccent),
    "title": "Courses Categorization",
    "description":
        "Organize and categorize courses for better navigation and course discovery.",
  },
  {
    "icon": Icon(Icons.group, color: Colors.blue),
    "title": "Students Management",
    "description":
        "Comprehensive student profiles with progress tracking and academic performance analytics.",
    "route": "/students",
  },
  {
    "icon": Icon(Icons.group, color: Colors.blue),
    "title": "Teachers Management",
    "description":
        "Manage teachers profiles, courses assignments, and performance evaluations.",
  },
  {
    "icon": Icon(Icons.campaign_outlined, color: Colors.red),
    "title": "Promotional Offers",
    "description":
        "Manage promotional campaigns, notifications for ads and discount programs.",
  },
  {
    "icon": Icon(Icons.receipt_long_outlined, color: Colors.green),
    "title": "Financial Receipts",
    "description":
        "Handle payment receipts and disbursement orders for comprehensive financial tracking.",
  },
  {
    "icon": Icon(Icons.menu_book_outlined, color: Colors.teal),
    "title": "Curriculum Management",
    "description":
        "Design and manage curriculum sections with structured learning pathways.",
  },
  {
    "icon": Icon(Icons.military_tech, color: Colors.yellow),
    "title": "Curriculum Management",
    "description":
        "Generate and export certificates for course completion and achievements.",
  },
];
