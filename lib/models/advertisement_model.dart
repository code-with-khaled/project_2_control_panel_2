class Advertisement {
  final int? id;
  final String media;
  final String type;
  final String startDate;
  final String endDate;

  Advertisement({
    this.id,
    required this.media,
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) => Advertisement(
    media: json['media'],
    type: json['type'],
    startDate: json['start_date'],
    endDate: json['end_date'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'media': media,
    'type': type,
    'start_date': startDate,
    'end_date': endDate,
  };
}
