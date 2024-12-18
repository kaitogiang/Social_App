import 'package:equatable/equatable.dart';

class Photo extends Equatable{
  int id;
  int albumId;
  String title;
  String url;
  String thumbnailUrl;

  Photo({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
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

  @override
  List<Object> get props => [id, albumId, title, url, thumbnailUrl];
}
