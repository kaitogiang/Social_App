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
    // final url = 'https://via.placeholder.com/600/92c952';
    // final thumbnailUrl = 'https://via.placeholder.com/150/92c952';
    // final title = 'accusamus beatae ad facilis cum similique qui sunt';
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Showing the tag for this image
              const Wrap(
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
              const SizedBox(
                height: 10,
              ),
              //Showing the comment field
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Container(
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
              ),
              const SizedBox(
                height: 10,
              ),
            ],
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
