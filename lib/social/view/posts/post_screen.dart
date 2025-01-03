import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import 'package:image_social/social/bloc/photo_bloc/photo_bloc.dart';
import 'package:image_social/social/bloc/post_bloc/post_bloc.dart';
import 'package:image_social/social/view/posts/post_item.dart';
import 'package:image_social/social/widgets/bottom_loader.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  //Function for handling scroll action
  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
    if (_isBottom) {
      log('Calling fetch the next 20 items');
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // log('Max scroll * 0.9: ${maxScroll * 0.9}, Current scroll: $currentScroll');
    // log('currentScroll: $currentScroll, maxScroll: ${maxScroll * 0.9}, => ${currentScroll >= maxScroll * 0.9}');
    // return currentScroll >= (maxScroll * 0.9);
    return currentScroll == maxScroll;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          log('Current State: ${state.posts.length}');
          return Text('All posts (${state.posts.length})');
        }),
        actions: [
          IconButton(
            onPressed: () {
              log('Adding new post');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PostBloc>().add(PostFullRefreshed());
        },
        child: BlocBuilder<PostBloc, PostState>(builder: (context, state) {
          if (state.status == PostStatus.failure) {
            return const Center(
              child: Text('Failed to fetch posts'),
            );
          } else if (state.status == PostStatus.success) {
            if (state.posts.isEmpty) {
              return const Center(
                child: Text('No posts'),
              );
            }
          }
          log('Rebuild the UI: ${state.posts.length}');

          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? state.posts.length
                : state.posts.length + 1,
            itemBuilder: (context, index) {
              return index >= state.posts.length
                  // return state.status == PostStatus.loading
                  ? const BottomLoader()
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: PostItem(
                        post: state.posts[index],
                      ),
                    );
            },
          );
        }),
      ),
    );
  }
}
