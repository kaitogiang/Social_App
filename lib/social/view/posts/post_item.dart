import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_social/social/bloc/comment_bloc/comment_bloc.dart';
import 'package:image_social/social/models/post.dart';
import 'package:image_social/social/view/posts/comments_screen.dart';
import 'package:image_social/social/widgets/bottom_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    super.key,
    required this.post,
  });

  final Post post;

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
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
            ),
            // IconButton(
            //   onPressed: () {
            //     log('Action for Post');
            //     showMenu(
            //       context: context,
            //       items: [
            //         const PopupMenuItem(child: Text('Delete')),
            //       ],
            //       position: const RelativeRect.fromLTRB(10, 10, 10, 10),
            //     );
            //   },
            //   icon: const Icon(Icons.more_vert),
            // ),
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
