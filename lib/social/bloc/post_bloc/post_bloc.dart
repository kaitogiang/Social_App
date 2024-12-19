import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_social/social/models/post.dart';

import 'package:http/http.dart' as http;

part 'post_event.dart';
part 'post_state.dart';

const _postLimit = 10;

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    //Register event
    //Event for handling gettting posts data
    on<PostFetched>(_onPostFetched);
    on<PostCommentCountUpdated>(_onPostCommentCountUpdated);
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await _fetchPosts(startIndex: state.posts.length);
      final newPosts = await Future.wait(posts.map((post) async {
        int commentsCount = await _getTheNumberOfComments(postId: post.id);
        return post.copyWith(commentsCount: commentsCount);
      }).toList());

      log('Posts length is ${posts.length}');
      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(state.copyWith(
        status: PostStatus.success,
        posts: [...state.posts, ...newPosts],
      ));
    } catch (error) {
      log('Exception: $error');
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  Future<void> _onPostCommentCountUpdated(
      PostCommentCountUpdated event, Emitter<PostState> emit) async {
    try {
      log("Calling onPostCommnetCountUpdated");
      //Getting the current post list
      final posts = state.posts;
      //Finding the specific post and update its comment count
      final updatedPosts = posts.map((currentPost) {
        //Update the commentCount for a specific post
        if (currentPost.id == event.postId) {
          log("Change commentCount post ${event.postId} to ${event.commentCount}");
          return currentPost.copyWith(commentsCount: event.commentCount);
        }
        return currentPost;
      }).toList();
      emit(state.copyWith(posts: updatedPosts));
      log('Emit update comment count: ${updatedPosts[0]}');
    } catch (error) {
      log('Exception in _onPostCommentCountUpdated: $error');
    }
  }

  //Fetch posts from start index
  Future<List<Post>> _fetchPosts({required int startIndex}) async {
    final response = await httpClient.get(Uri.http(
      'jsonplaceholder.typicode.com',
      '/posts',
      <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
    ));

    if (response.statusCode == 200) {
      log('Success fetch data');
      final body = json.decode(response.body) as List<dynamic>;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post.fromJson(map);
      }).toList();
    }
    log('failed to fetch data');

    throw Exception('Error fetching posts');
  }

  Future<int> _getTheNumberOfComments({required int postId}) async {
    final response = await httpClient.get(
        Uri.http('jsonplaceholder.typicode.com', 'posts/$postId/comments'));

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List<dynamic>;
      return body.length;
    }
    return 0;
  }
}
