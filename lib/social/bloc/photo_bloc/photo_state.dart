part of 'photo_bloc.dart';

enum PhotoStatus { intitial, success, failure }

final class PhotoState extends Equatable {
  const PhotoState({
    this.status = PhotoStatus.intitial,
    this.photos = const <Photo>[],
    this.hasReachedMax = false,
  });

  final PhotoStatus status;
  final List<Photo> photos;
  final bool hasReachedMax;

  PhotoState copyWith({
    PhotoStatus? status,
    List<Photo>? photos,
    bool? hasReachedMax,
  }) {
    return PhotoState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [status, photos, hasReachedMax];
}
