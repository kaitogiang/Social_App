import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart' as http;
import 'package:image_social/social/models/comment.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc({required this.httpClient}) : super(CommentInitial()) {
    //Register fetching event for a specific post
    on<CommentFetched>(_onCommentFetched);
    on<CommentAddPressed>(_onCommentAdded);
  }

  final http.Client httpClient;

  Future<void> _onCommentFetched(
      CommentFetched event, Emitter<CommentState> emit) async {
    try {
      final cachedCommentSize = (state as CommentFetch).comments.length;
      log('Previous Size comments: $cachedCommentSize');
      // final cachedComments = (state as CommentFetch).comments;
      final comments = await _fetchComments(postId: event.postId);
      // final newComments = (state as CommentFetch)
      //     .copyWith(comments: [...cachedComments, ...comments]);
      emit(CommentFetch(comments: comments));
      // emit(CommentFetch(comments: newComments.comments));
    } catch (error) {
      log('Exception: $error');
      emit(const CommentFetchFailure('Failed to fetch comments'));
    }
  }

  Future<void> _onCommentAdded(
      CommentAddPressed event, Emitter<CommentState> emit) async {
    try {
      final currentComments = (state as CommentFetch).comments;
      log('Current comment size: ${currentComments.length}');
      final comment = event.comment.copyWith(id: currentComments.length);
      //Post the comment into the server
      await _postComment(comment: comment);
      //Update the current state in the CommentBloc and update the corresponding UI
      emit(CommentFetch(comments: [...currentComments, comment]));
    } catch (error) {
      log('Exception: $error');
      emit(const CommentFetchFailure('Failed to add comment'));
    }
  }

  //Method for getting comments for a specific post using postId
  Future<List<Comment>> _fetchComments({required int postId}) async {
    final response = await httpClient.get(Uri.http(
      'jsonplaceholder.typicode.com',
      '/posts/$postId/comments',
    ));

    if (response.statusCode == 200) {
      log('Success fetch all comments for post Id: $postId');
      final body = json.decode(response.body) as List<dynamic>;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Comment.fromJson(map);
      }).toList();
    }
    log('Failed to fetch comments for post id $postId');
    throw Exception('Error fetching comments');
  }

  Future<void> _postComment({required Comment comment}) async {
    final url = Uri.http(
        'jsonplaceholder.typicode.com', '/posts/${comment.postId}/comments');
    try {
      final response = await httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(comment.toJson()),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        log('Comment posted successfully');
      } else {
        log('There is an error while posting the comment');
        throw Exception('Error posting comment');
      }
    } catch (error) {
      log('Exception while posting: $error');
    }
  }
}
