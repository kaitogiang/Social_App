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
  }

  final http.Client httpClient;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    try {
      final posts = await _fetchPosts(startIndex: state.posts.length);
      log('Posts length is ${posts.length}');
      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(state.copyWith(
        status: PostStatus.success,
        posts: [...state.posts, ...posts],
      ));
    } catch (error) {
      log('Exception: $error');
      emit(state.copyWith(status: PostStatus.failure));
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
}
