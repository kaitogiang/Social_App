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
  }

  final http.Client httpClient;

  Future<void> _onPhotoFetched(
      PhotoFetched event, Emitter<PhotoState> emit) async {
    if (state.hasReachedMax) return;
    try {
      final photos = await _fetchPhotos(startIndex: state.photos.length);
      log('Calling fetch photo method');
      if (photos.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(state.copyWith(
        status: PhotoStatus.success,
        photos: [...state.photos, ...photos],
      ));
    } catch (error) {
      log('Exceptioin: $error');
      emit(state.copyWith(status: PhotoStatus.failure));
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
}
