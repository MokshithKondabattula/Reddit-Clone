import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget child;
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  const Responsive({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // You can add logic here to render different layouts based on screen size
    return child;
  }
}
