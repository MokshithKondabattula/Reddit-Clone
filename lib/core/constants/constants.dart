import 'package:flutter/material.dart';
import 'package:temp_flutter_fix/features/feed/feed_screen.dart';
import 'package:temp_flutter_fix/features/post/screens/add_post_screen.dart';

class Constants {
  // Image paths
  static const String logoPath = 'assets/images/logo.png';
  static const String loginEmotePath = 'assets/images/loginEmote.png';
  static const String googlePath = 'assets/images/google.png';

  // Default images
  static const String bannerDefault =
      'https://thumbs.dreamstime.com/b/abstract-stained-pattern-rectangle-background-blue-sky-over-fiery-red-orange-color-modern-painting-art-watercolor-effe-texture-123047399.jpg';
  static const String avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  // Tab widgets (removed const since widget instances aren't compile-time constants)
  static final List<Widget> tabWidgets = [FeedScreen(), AddPostScreen()];

  // Icons
  static const IconData up = IconData(
    0xe800,
    fontFamily: 'MyFlutterApp',
    fontPackage: null,
  );
  static const IconData down = IconData(
    0xe801,
    fontFamily: 'MyFlutterApp',
    fontPackage: null,
  );

  // Awards
  static const String awardsPath = 'assets/images/awards';

  static const Map<String, String> awards = {
    'awesomeAns': '$awardsPath/awesomeanswer.png',
    'gold': '$awardsPath/gold.png',
    'platinum': '$awardsPath/platinum.png',
    'helpful': '$awardsPath/helpful.png',
    'plusone': '$awardsPath/plusone.png',
    'rocket': '$awardsPath/rocket.png',
    'thankyou': '$awardsPath/thankyou.png',
    'til': '$awardsPath/til.png',
  };
}
