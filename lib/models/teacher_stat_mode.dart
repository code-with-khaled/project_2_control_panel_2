class TeacherStat {
  final int totalEnrollments;
  final int confirmedEnrollments;
  final int withdrawnEnrollments;
  final int thisMonthEnrollments;
  final int lastMonthEnrollments;
  final double totalRevenue;
  final Map<String, double> monthlyRevenues;

  TeacherStat({
    required this.totalEnrollments,
    required this.confirmedEnrollments,
    required this.withdrawnEnrollments,
    required this.thisMonthEnrollments,
    required this.lastMonthEnrollments,
    required this.totalRevenue,
    required this.monthlyRevenues,
  });

  factory TeacherStat.fromJson(Map<String, dynamic> json) {
    return TeacherStat(
      totalEnrollments: json['total_enrollments'] ?? 0,
      confirmedEnrollments: json['confirmed_enrollments'] ?? 0,
      withdrawnEnrollments: json['withdrawn_enrollments'] ?? 0,
      thisMonthEnrollments: json['this_month_enrollments'] ?? 0,
      lastMonthEnrollments: json['last_month_enrollments'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      monthlyRevenues: Map<String, double>.from(
        (json['monthly_revenues'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, (value ?? 0).toDouble()),
            ) ??
            {},
      ),
    );
  }
}
