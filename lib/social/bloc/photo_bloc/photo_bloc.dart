import 'dart:convert';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:image_social/social/models/photo.dart';
import 'package:bloc/bloc.dart';

part 'photo_event.dart';
part 'photo_state.dart';

const _photoLimit = 10;

final class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  PhotoBloc({required this.httpClient}) : super(const PhotoState()) {
    //Register event handlers
    //Posting photo list
    on<PhotoFetched>(_onPhotoFetched);
    on<PhotoCommentCountUpdated>(_onPhotoCommentCountUpdated);
    on<PhotoDeletePressed>(_onPhotoDeleted);
  }

  final http.Client httpClient;

  Future<void> _onPhotoFetched(
      PhotoFetched event, Emitter<PhotoState> emit) async {
    if (state.hasReachedMax) return;
    try {
      final photos = await _fetchPhotos(startIndex: state.photos.length);
      final newPhotos = await Future.wait(photos.map((photo) async {
        int commentCount = await _getTheNumberOfComments(postId: photo.id);
        return photo.copyWith(commentsCount: commentCount);
      }).toList());
      log('Calling fetch photo method');
      if (photos.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(state.copyWith(
        status: PhotoStatus.success,
        photos: [...state.photos, ...newPhotos],
      ));
    } catch (error) {
      log('Exceptioin: $error');
      emit(state.copyWith(status: PhotoStatus.failure));
    }
  }

  Future<void> _onPhotoCommentCountUpdated(
      PhotoCommentCountUpdated event, Emitter<PhotoState> emit) async {
    try {
      //Gettting the current photos list
      final photos = state.photos;
      //Finding the specific photo and update its comment count
      final updatedPhotos = photos.map((currentPhoto) {
        //Update the commentCount for specific photo
        if (currentPhoto.id == event.postId) {
          return currentPhoto.copyWith(commentsCount: event.commentCount);
        }
        return currentPhoto;
      }).toList();
      //Updating the state of the current photo state
      emit(state.copyWith(photos: updatedPhotos));
    } catch (error) {
      log('Exception in _onPhotoCommentCountUpdated: $error');
    }
  }

  Future<void> _onPhotoDeleted(
      PhotoDeletePressed event, Emitter<PhotoState> emit) async {
    try {
      //getting the current photo list
      final photos = [...state.photos];
      photos.removeWhere((post) => post.id == event.postId);
      //Emit the new state for updating the UI
      emit(state.copyWith(photos: photos));
    } catch (error) {
      log('Exception in _onPhotoDeleted: $error');
    }
  }

  //Fetching data from server
  Future<List<Photo>> _fetchPhotos({required int startIndex}) async {
    final response = await httpClient.get(Uri.http(
        'jsonplaceholder.typicode.com',
        '/photos',
        <String, String>{'_start': '$startIndex', '_limit': '$_photoLimit'}));

    if (response.statusCode == 200) {
      log('Success fetch photos');
      final body = json.decode(response.body) as List<dynamic>;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Photo.fromJson(map);
      }).toList();
    }
    log('Failed to fetch data');
    throw Exception('Error fetching photos');
  }

  //Get the number of comments for a specific postId
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
