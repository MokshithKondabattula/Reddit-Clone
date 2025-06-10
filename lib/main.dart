import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:temp_flutter_fix/core/common/error_text.dart';
import 'package:temp_flutter_fix/core/common/loader.dart';
import 'package:temp_flutter_fix/features/auth/controller/auth_controller.dart';
import 'package:temp_flutter_fix/firebase_options.dart';
import 'package:temp_flutter_fix/router.dart';
import 'package:temp_flutter_fix/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authUserAsync = ref.watch(authStateChangeProvider);
    final userModel = ref.watch(userProvider);

    return authUserAsync.when(
      data: (firebaseUser) {
        if (firebaseUser == null) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit Clone',
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (_) => loggedOutRoute,
            ),
            routeInformationParser: const RoutemasterParser(),
          );
        }

        if (userModel == null) {
          ref
              .read(authControllerProvider.notifier)
              .getUserData(firebaseUser.uid)
              .listen((userData) {
                ref.read(userProvider.notifier).state = userData;
              });

          return const Loader();
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Reddit Clone',
          theme: ref.watch(themeNotifierProvider),
          routerDelegate: RoutemasterDelegate(
            routesBuilder: (_) => loggedInRoute,
          ),
          routeInformationParser: const RoutemasterParser(),
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorText(error: error.toString()),
    );
  }
}
