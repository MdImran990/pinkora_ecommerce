class ReviewModel {
  final String id;
  final String userName;
  final int rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'Customer',
      rating: (json['rating'] as num?)?.toInt() ?? 5,
      comment: json['comment']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
