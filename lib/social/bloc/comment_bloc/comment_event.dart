part of 'comment_bloc.dart';

sealed class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

//Event for fetching all comments of a specific post
final class CommentFetched extends CommentEvent {
  final int postId;

  const CommentFetched(this.postId);

  @override
  List<Object?> get props => [postId];
}

//Event for adding a comment
final class CommentAddPressed extends CommentEvent {
  final Comment comment;

  const CommentAddPressed(this.comment);

  @override
  List<Object?> get props => [comment];
}

