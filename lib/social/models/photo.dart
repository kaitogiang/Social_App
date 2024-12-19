import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  int id;
  int albumId;
  String title;
  String url;
  String thumbnailUrl;
  int commentsCount;

  Photo({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    this.commentsCount = 0,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      albumId: json['albumId'],
      title: json['title'],
      url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  Photo copyWith({
    int? id,
    int? albumId,
    String? title,
    String? url,
    String? thumbnailUrl,
    int? commentsCount,
  }) {
    return Photo(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      title: title ?? this.title,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }

  @override
  List<Object> get props => [id, albumId, title, url, thumbnailUrl, commentsCount];
}
