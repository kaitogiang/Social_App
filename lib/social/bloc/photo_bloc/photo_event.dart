part of 'photo_bloc.dart';

sealed class PhotoEvent extends Equatable {
  const PhotoEvent();
  @override
  List<Object> get props => [];
}

final class PhotoFetched extends PhotoEvent {}

final class PhotoFullRefreshed extends PhotoEvent {}

final class PhotoCommentCountUpdated extends PhotoEvent {
  final int commentCount;
  final int postId;

  const PhotoCommentCountUpdated(this.commentCount, this.postId);

  @override
  List<Object> get props => [commentCount, postId];
}

final class PhotoDeletePressed extends PhotoEvent {
  final int postId;

  const PhotoDeletePressed(this.postId);

  @override
  List<Object> get props => [postId];
}
