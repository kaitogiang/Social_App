import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_social/social/bloc/comment_bloc/comment_bloc.dart';
import 'package:image_social/social/models/photo.dart';
import 'package:image_social/social/view/photos/thumbnail_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_social/social/view/posts/comments_screen.dart';
import 'package:image_social/social/widgets/bottom_modal.dart';

class PhotoItem extends StatelessWidget {
  const PhotoItem({
    super.key,
    required this.photo,
  });

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 70),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(photo.url),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ThumbnailCard(thumbnailUrl: photo.thumbnailUrl, title: photo.title),
          FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Showing the tag for this image
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      TagChip(
                        tag: '#amazing',
                      ),
                      TagChip(
                        tag: '#air_balloon',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //Showing the number of comments in a specific post
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.comment,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '45 comments',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //Showing the comment field
                Container(
                  decoration: BoxDecoration(
                      color: Colors.black54.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(30)),
                  child: TextFormField(
                    onTap: () {
                      //Showing the comment screen of a specific id
                      context.read<CommentBloc>().add(CommentFetched(photo.id));
                      //Show the bottom modal to display all the comments for the specific post
                      showBottomDialog(
                        context: context,
                        title: photo.title,
                        heightFactor: 0.85,
                        child: CommentsScreen(
                          postId: photo.id,
                        ),
                      );
                    },
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Add comment',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.4)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          log('Send comment');
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.tag,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.3),
      ),
      padding: const EdgeInsets.all(5),
      child: Text(
        tag,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
