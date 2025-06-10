import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:temp_flutter_fix/core/common/error_text.dart';
import 'package:temp_flutter_fix/core/common/loader.dart';
import 'package:temp_flutter_fix/core/common/sign_in_button.dart';
import 'package:temp_flutter_fix/features/auth/controller/auth_controller.dart';
import 'package:temp_flutter_fix/features/community/controller/community_controller.dart';
import 'package:temp_flutter_fix/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest
                ? const SignInButton()
                : ListTile(
                  title: const Text('Create a community'),
                  leading: const Icon(Icons.add),
                  onTap: () => navigateToCreateCommunity(context),
                ),
            if (!isGuest)
              ref
                  .watch(userCommunitiesProvider)
                  .when(
                    data:
                        (communities) => ExpansionTile(
                          title: const Text('Your Communities'),
                          iconColor: Colors.white,
                          children: [
                            SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: communities.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final community = communities[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        community.avatar,
                                      ),
                                    ),
                                    title: Text('r/${community.name}'),
                                    onTap: () {
                                      navigateToCommunity(context, community);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    error:
                        (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                    loading: () => const Loader(),
                  ),
          ],
        ),
      ),
    );
  }
}
