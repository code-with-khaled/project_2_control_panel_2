import 'package:control_panel_2/models/course_model.dart';

final List<Course> courses = [
  Course(
    id: 'AR001',
    name: 'مبادئ تطوير واجهات باستخدام Flutter',
    categorization: 'البرمجة',
    description:
        'دورة تمهيدية لتعلم أساسيات تطوير التطبيقات باستخدام Flutter، مناسبة للمبتدئين في البرمجة متعددة المنصات.',
    state: 'منشورة',
    teacher: 'أحمد محمد',
    enrollments: 120,
    price: 1300000,
  ),
  Course(
    id: 'AR002',
    name: 'البرمجة المنطقية وهياكل البيانات',
    categorization: 'اللغات',
    description:
        'مفاهيم أساسية لهياكل البيانات وتصميم خوارزميات فعالة، تعزز التفكير المنطقي وتطوير الأداء البرمجي.',
    state: 'غير منشورة',
    teacher: 'فاطمة علي',
    enrollments: 85,
    price: 1800000,
  ),
  Course(
    id: 'AR003',
    name: 'فن التواصل وتصميم تجربة المستخدم',
    categorization: 'العلوم الإنسانية',
    description:
        'استكشاف أدوات وتقنيات تصميم واجهات المستخدم بتركيز على الإبداع والتفاعل لتحسين تجربة المستخدم.',
    state: 'منشورة',
    teacher: 'خالد حسن',
    enrollments: 64,
    price: 1100000,
  ),
  Course(
    id: 'AR004',
    name: 'الفن التطبيقي في صيانة اللابتوب',
    categorization: 'الفنون والإبداع',
    description:
        'تغطية عملية لمكونات اللابتوب الداخلية، تشمل خطوات صيانة مثل تنظيف المراوح واستبدال المعجون الحراري.',
    state: 'غير منشورة',
    teacher: 'نورا عبدالله',
    enrollments: 47,
    price: 1300000,
  ),
  Course(
    id: 'AR005',
    name: 'تقنيات متقدمة في إدارة الحالة Flutter',
    categorization: 'البرمجة',
    description:
        'تعلم إدارة الحالة باستخدام تقنيات مثل Provider وRiverpod، موجهة للمطورين ذوي خبرة في Flutter.',
    state: 'منشورة',
    teacher: 'يوسف إبراهيم',
    enrollments: 95,
    price: 2000000,
  ),
];
