import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_social/social/bloc/comment_bloc/comment_bloc.dart';
import 'package:image_social/social/bloc/post_bloc/post_bloc.dart';
import 'package:image_social/social/models/post.dart';
import 'package:image_social/social/view/posts/comments_screen.dart';
import 'package:image_social/social/widgets/bottom_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickalert/quickalert.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.post,
  });

  final Post post;

  void _deletePostHandler(BuildContext context, int postId) async {
    //Show confirm dialog to authenticate the action
    final isDeleted = await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'This post will be deteted and can\'t reverse the action ',
      confirmBtnText: 'Delete it',
      onCancelBtnTap: () =>
          Navigator.of(context, rootNavigator: true).pop(false),
      onConfirmBtnTap: () =>
          Navigator.of(context, rootNavigator: true).pop(true),
    ) as bool;
    if (isDeleted) {
      log('Delete the post immediately');
      context.read<PostBloc>().add(PostDeletePressed(postId));
    } else {
      log('Wait, user canceled the action :))');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Title of the post
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                post.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: const Text('Delete'),
                  onTap: () async {
                    _deletePostHandler(context, post.id);
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //The comment block of user
        Text(
          post.body,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            log('View comments and add comment');
            //Emit event to fetch all the relevant comments
            context.read<CommentBloc>().add(CommentFetched(post.id));
            //Show the bottom modal to display all the comments for the specific post
            showBottomDialog(
              context: context,
              title: post.title,
              heightFactor: 0.85,
              child: CommentsScreen(
                postId: post.id,
              ),
            );
          },
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/comment_icon.svg',
                width: 35,
                height: 35,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                'Comment (${post.commentsCount})',
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const Divider(),
      ],
    );
  }
}
