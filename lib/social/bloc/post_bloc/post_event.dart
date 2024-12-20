part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object> get props => [];
}

final class PostFetched extends PostEvent {}

final class PostFullRefreshed extends PostEvent {}

final class PostCommentCountUpdated extends PostEvent {
  final int commentCount;
  final int postId;

  const PostCommentCountUpdated(this.commentCount, this.postId);

  @override
  List<Object> get props => [commentCount, postId];
}

final class PostDeletePressed extends PostEvent {
  final int postId;
  final Function function;

  const PostDeletePressed({required this.postId, required this.function});

  @override
  List<Object> get props => [postId, function];
}
