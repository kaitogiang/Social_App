import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_social/social/bloc/comment_bloc/comment_bloc.dart';
import 'package:image_social/social/bloc/photo_bloc/photo_bloc.dart';
import 'package:image_social/social/bloc/post_bloc/post_bloc.dart';
import 'package:image_social/social/models/comment.dart';
import 'package:image_social/social/widgets/comment_item.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.postId});

  final int postId;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
    _scrollController.dispose();
    _focusNode.unfocus();
    _focusNode.dispose();
  }

  //Add new comment to the post, when the user click send, it will scroll to the bottom view
  void _addCommnent(int currentSize) {
    //Get the max scroll on the screen
    final maxScroll = _scrollController.position.maxScrollExtent;
    //Scroll down to the end
    _scrollController.animateTo(
      maxScroll,
      curve: Curves.bounceIn,
      duration: const Duration(milliseconds: 300),
    );
    //Unfocus when the user clicked
    _focusNode.unfocus();
    //Create a new comment object
    final comment = Comment(
        postId: widget.postId,
        id: 99,
        name: 'Raiden Shogun',
        email: 'raide',
        body: _commentController.text);
    context.read<CommentBloc>().add(CommentAddPressed(comment));
    //Send the event to the Post screen to update the UI
    context
        .read<PostBloc>()
        .add(PostCommentCountUpdated(currentSize + 1, widget.postId));
    //Send the event to the Photo screen to update the UI
    context
        .read<PhotoBloc>()
        .add(PhotoCommentCountUpdated(currentSize + 1, widget.postId));
    //Clear the input text
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    //Listen for the keyboard appearance
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<CommentBloc, CommentState>(builder: (context, state) {
      if (state is CommentFetch) {
        context
            .read<PostBloc>()
            .add(PostCommentCountUpdated(state.comments.length, widget.postId));
        context.read<PhotoBloc>().add(
            PhotoCommentCountUpdated(state.comments.length, widget.postId));
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.comments.length,
                // itemCount: state.getCommentsForPost(widget.postId).length,
                itemBuilder: (context, index) {
                  return CommentItem(comment: state.comments[index]);
                  // return CommentItem(comment: state.getCommentsForPost(widget.postId)[index]);
                },
              ),
            ),
            AnimatedPadding(
              padding:
                  EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 0),
              duration: const Duration(milliseconds: 300),
              child: TextFormField(
                focusNode: _focusNode,
                controller: _commentController,
                decoration: InputDecoration(
                  hintText: 'Add your comment here',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      log('Add new comment to the post');
                      _addCommnent(state.comments.length);
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        return const Center(child: Text('No data'));
      }
    });
  }
}
