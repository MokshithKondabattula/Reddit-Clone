import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:temp_flutter_fix/core/common/error_text.dart';
import 'package:temp_flutter_fix/core/common/loader.dart';
import 'package:temp_flutter_fix/core/common/post_card.dart';
import 'package:temp_flutter_fix/features/auth/controller/auth_controller.dart';
import 'package:temp_flutter_fix/features/community/controller/community_controller.dart';
import 'package:temp_flutter_fix/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref
          .watch(userCommunitiesProvider)
          .when(
            data:
                (communities) => ref
                    .watch(userPostsProvider(communities))
                    .when(
                      data: (data) {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final post = data[index];
                            return PostCard(post: post);
                          },
                        );
                      },
                      error: (error, stackTrace) {
                        return ErrorText(error: error.toString());
                      },
                      loading: () => const Loader(),
                    ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
    }
    return ref
        .watch(userCommunitiesProvider)
        .when(
          data:
              (communities) => ref
                  .watch(guestPostsProvider)
                  .when(
                    data: (data) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final post = data[index];
                          return PostCard(post: post);
                        },
                      );
                    },
                    error: (error, stackTrace) {
                      return ErrorText(error: error.toString());
                    },
                    loading: () => const Loader(),
                  ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
