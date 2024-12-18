import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_social/social/models/comment.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //User Information and Action button in the header of the comment
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Block for user infor
            Expanded(
              child: Row(
                children: [
                  const CircleAvatar(
                    child: FlutterLogo(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      comment.name,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // const Text(
                  //   '1 hour ago',
                  //   style: TextStyle(
                  //     color: Colors.grey,
                  //   ),
                  // ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                log('Option');
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        //The comment block of user
        Text(
          comment.body,
          style: const TextStyle(fontSize: 13),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                log('like');
              },
              icon: SvgPicture.asset(
                'assets/images/smilling_icon.svg',
                width: 35,
                height: 35,
              ),
            ),
            TextButton(
              onPressed: () {
                log('Comment');
              },
              child: const Text(
                'Reply',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        const Divider(),
      ],
    );
  }
}
