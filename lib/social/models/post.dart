import 'package:equatable/equatable.dart';

class Post extends Equatable {
  int userId;
  int id;
  String title;
  String body;
  int commentsCount;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
    this.commentsCount = 0,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Post copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
    int? commentsCount,
  }) {
    return Post(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }

  @override
  List<Object?> get props => [userId, id, title, body, commentsCount];
}
