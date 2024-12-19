import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_social/social/bloc/photo_bloc/photo_bloc.dart';
import 'package:image_social/social/view/photos/photo_item.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PhotoBloc, PhotoState>(builder: (context, state) {
        if (state.status == PhotoStatus.failure) {
          return const Center(
            child: Text('Failed to fetch photos'),
          );
        } else if (state.status == PhotoStatus.success) {
          if (state.photos.isEmpty) {
            return const Center(
              child: Text('No photos'),
            );
          }
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<PhotoBloc>().add(PhotoFetched());
          },
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (value) {
              log('Current index page: $value');
              //Fetching additional photo when the user has reached the restricted amount of photos
              if (value == state.photos.length - 2) {
                log('Photo fetch method');
                context.read<PhotoBloc>().add(PhotoFetched());
              }
            },
            children: List<Widget>.generate(
              state.photos.length,
              (index) => PhotoItem(
                photo: state.photos[index],
              ),
            ),
          ),
        );
      }),
    );
  }
}
