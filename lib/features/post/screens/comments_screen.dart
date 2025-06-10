import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:temp_flutter_fix/core/common/error_text.dart';
import 'package:temp_flutter_fix/core/common/loader.dart';
import 'package:temp_flutter_fix/core/common/post_card.dart';
import 'package:temp_flutter_fix/features/post/controller/post_controller.dart';
import 'package:temp_flutter_fix/features/post/widgets/comment_card.dart';
import 'package:temp_flutter_fix/models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  ConsumerState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref
        .watch(postControllerProvider.notifier)
        .addComment(
          context: context,
          post: post,
          text: commentController.text.trim(),
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ref
            .watch(getPostByIdProvider(widget.postId))
            .when(
              data: (post) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 12,
                    right: 12,
                    top: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PostCard(post: post),
                      const SizedBox(height: 10),
                      TextField(
                        cursorColor: Colors.blueAccent,
                        onSubmitted: (val) => addComment(post),
                        controller: commentController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          filled: true,
                          hintText: 'Your thoughts?',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ref
                          .watch(getPostCommentsProvider(widget.postId))
                          .when(
                            data: (comments) {
                              if (comments.isEmpty) {
                                return const Text("No comments yet");
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];
                                  return CommentCard(comment: comment);
                                },
                              );
                            },
                            error:
                                (error, _) =>
                                    ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          ),
                    ],
                  ),
                );
              },
              error: (error, _) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ),
      ),
    );
  }
}
