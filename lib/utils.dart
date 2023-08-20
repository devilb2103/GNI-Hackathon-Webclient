import 'package:flutter/material.dart';

PageRouteBuilder customSlideTransitionDown(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
          Tween(begin: const Offset(0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.ease))),
      child: child,
    ),
  );
}

void showSnackbar(String message, BuildContext context, Color color) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
}
