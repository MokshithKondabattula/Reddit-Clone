import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:temp_flutter_fix/core/common/error_text.dart';
import 'package:temp_flutter_fix/core/common/loader.dart';
import 'package:temp_flutter_fix/core/constants/constants.dart';
import 'package:temp_flutter_fix/features/auth/controller/auth_controller.dart';
import 'package:temp_flutter_fix/features/community/controller/community_controller.dart';
import 'package:temp_flutter_fix/features/post/controller/post_controller.dart';
import 'package:temp_flutter_fix/models/post_model.dart';
import 'package:temp_flutter_fix/models/user_model.dart';
import 'package:temp_flutter_fix/theme/pallete.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deletePost(BuildContext context, WidgetRef ref) async {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void upvote(WidgetRef ref) =>
      ref.read(postControllerProvider.notifier).upvote(post);
  void downvote(WidgetRef ref) =>
      ref.read(postControllerProvider.notifier).downvote(post);

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(postControllerProvider.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigateToUserProfile(BuildContext context) =>
      Routemaster.of(context).push('/u/${post.uid}');

  void navigateToCommunity(BuildContext context) =>
      Routemaster.of(context).push('/r/${post.communityName}');

  void navigateToComments(BuildContext context) =>
      Routemaster.of(context).push('/post/${post.id}/comments');

  void showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Post'),
            content: const Text('Are you sure you want to delete this post?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  deletePost(context, ref);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final isTypeImage = post.type == 'image';
    final isTypeLink = post.type == 'link';
    final isTypeText = post.type == 'text';

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: currentTheme.drawerTheme.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, ref, user, currentTheme),

                if (post.awards.isNotEmpty) _buildAwardsSection(),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                _buildContentSection(
                  context,
                  isTypeImage,
                  isTypeLink,
                  isTypeText,
                ),

                _buildActionButtons(context, ref, user),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    ThemeData theme,
  ) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => navigateToCommunity(context),
          child: CircleAvatar(
            backgroundImage: NetworkImage(post.communityProfilePic),
            radius: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => navigateToCommunity(context),
                child: Text(
                  'r/${post.communityName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => navigateToUserProfile(context),
                child: Text(
                  'u/${post.username.replaceAll(" ", "")}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        if (post.uid == user.uid)
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Pallete.redColor,
            onPressed: () => showDeleteDialog(context, ref),
          ),
      ],
    );
  }

  Widget _buildAwardsSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: post.awards.length,
          itemBuilder: (context, index) {
            final award = post.awards[index];
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Image.asset(Constants.awards[award]!, height: 24),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContentSection(
    BuildContext context,
    bool isTypeImage,
    bool isTypeLink,
    bool isTypeText,
  ) {
    return Column(
      children: [
        if (isTypeImage)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: Image.network(
                post.link!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 50),
                    ),
                  );
                },
              ),
            ),
          ),
        if (isTypeLink)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: AnyLinkPreview(
                displayDirection: UIDirection.uiDirectionHorizontal,
                link: post.link!,
                errorWidget: Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.link_off, size: 50)),
                ),
              ),
            ),
          ),
        if (isTypeText)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              post.description!,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Constants.up,
                    size: 20,
                    color:
                        post.upvotes.contains(user.uid)
                            ? Pallete.redColor
                            : Colors.grey,
                  ),
                  onPressed: () => upvote(ref),
                ),
                Text(
                  '${post.upvotes.length - post.downvotes.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Constants.down,
                    size: 20,
                    color:
                        post.downvotes.contains(user.uid)
                            ? Pallete.blueColor
                            : Colors.grey,
                  ),
                  onPressed: () => downvote(ref),
                ),
              ],
            ),
          ),

          Row(
            children: [
              IconButton(
                onPressed: () => navigateToComments(context),
                icon: const Icon(Icons.mode_comment_outlined, size: 23),
              ),
              Text(
                '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.card_giftcard, size: 23),
            onPressed: () => _showAwardsDialog(context, ref),
          ),

          ref
              .watch(getCommunityByNameProvider(post.communityName))
              .when(
                data: (community) {
                  if (community.mods.contains(user.uid)) {
                    return IconButton(
                      icon: const Icon(Icons.admin_panel_settings, size: 23),
                      onPressed: () => showDeleteDialog(context, ref),
                    );
                  }
                  return const SizedBox();
                },
                error:
                    (error, stackTrace) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }

  void _showAwardsDialog(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: user.awards.length,
                itemBuilder: (context, index) {
                  final award = user.awards[index];
                  return GestureDetector(
                    onTap: () {
                      awardPost(ref, award, context);
                      Navigator.pop(context);
                    },
                    child: Image.asset(Constants.awards[award]!),
                  );
                },
              ),
            ),
          ),
    );
  }
}
