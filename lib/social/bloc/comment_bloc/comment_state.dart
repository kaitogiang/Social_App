part of 'comment_bloc.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

//Intial state for loading comment
final class CommentInitial extends CommentState {}

//Fetching comment for specific post
final class CommentFetch extends CommentState {
  final List<Comment> comments;

  const CommentFetch({required this.comments});

  @override
  List<Object?> get props => [comments];

  CommentFetch copyWith({
    List<Comment>? comments,
  }) {
    return CommentFetch(
      comments: comments ?? this.comments,
    );
  }

  //Finding a specific comments in the state
  List<Comment> getCommentsForPost(int postId) {
    return comments.where((comment) => comment.postId == postId).toList();
  }
}

final class CommentFetchFailure extends CommentState {
  final String message;

  const CommentFetchFailure(this.message);

  @override
  List<Object?> get props => [message];
}
