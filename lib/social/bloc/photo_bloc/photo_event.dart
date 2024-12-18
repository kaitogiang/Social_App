part of 'photo_bloc.dart';

sealed class PhotoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class PhotoFetched extends PhotoEvent {}
