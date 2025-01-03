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
    on<PostDeletePressed>(_onPostDeleted);
    on<PostFullRefreshed>(_onFullRefreshed);
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    try {
      emit(state.copyWith(status: PostStatus.loading));
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
      // log('Emit update comment count: ${updatedPosts[0]}');
    } catch (error) {
      log('Exception in _onPostCommentCountUpdated: $error');
    }
  }

  Future<void> _onPostDeleted(
      PostDeletePressed event, Emitter<PostState> emit) async {
    try {
      emit(state.copyWith(status: PostStatus.deleting));
      //Calling the API for deleting the post based on its id
      final isDeleted = await _deletePost(postId: event.postId);
      if (isDeleted) {
        log('Delete the post sucessfully');
        // await Future.delayed(Duration(seconds: 5));
        //If success, emit the new state for the post list
        //Delete the specific post from the current state
        final post = [...state.posts];
        post.removeWhere((post) => post.id == event.postId);
        //Emit the new state for the PostBloc
        emit(
          state.copyWith(posts: post, status: PostStatus.success),
        );
        event.function();
      } else {
        log('Can\'t delete the post :(( ');
        emit(state.copyWith(status: PostStatus.failure));
      }
    } catch (error) {
      log('Exception in _onPostDeleted: $error');
    }
  }

  Future<void> _onFullRefreshed(
      PostFullRefreshed event, Emitter<PostState> emit) async {
    try {
      //Calling the API for refreshing the current post list.
      //For example, if the user has fetched the first 20 items, the 20 items
      //in the list will be re-fetch, likewise, if user has fetched 40 items,
      //it will re-fetch these 40 items.
      //Get the current list size
      final currentSize = state.posts.length;
      final posts = await _fetchPosts(startIndex: 0, postLimit: 20);
      //the newPosts will retain the number of items that has loaded before
      final newPosts = await Future.wait(posts.map((post) async {
        int commentCount = await _getTheNumberOfComments(postId: post.id);
        return post.copyWith(commentsCount: commentCount);
      }).toList());

      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(state.copyWith(status: PostStatus.success, posts: newPosts));
    } catch (error) {
      log('Exception in _onFullRefreshed: $error');
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  //Fetch posts from start index
  Future<List<Post>> _fetchPosts(
      {required int startIndex, int postLimit = 20}) async {
    final response = await httpClient.get(Uri.http(
      'jsonplaceholder.typicode.com',
      '/posts',
      <String, String>{'_start': '$startIndex', '_limit': '$postLimit'},
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

  Future<bool> _deletePost({required int postId}) async {
    final response = await httpClient
        .delete(Uri.http('jsonplaceholder.typicode.com', '/posts/$postId'));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
