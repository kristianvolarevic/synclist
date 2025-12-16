import 'package:flutter/material.dart';

PageRouteBuilder slideTransitionRoute(Widget page) {
  return PageRouteBuilder(
    // Define the duration of the transition (matching the original 300ms)
    transitionDuration: const Duration(milliseconds: 300),

    // The builder function simply returns the destination page
    pageBuilder: (context, animation, secondaryAnimation) => page,

    // The core animation logic using a SlideTransition
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Start position (1.0 = 100% off-screen right)
      const begin = Offset(1.0, 0.0);
      // End position (Offset.zero = in place)
      const end = Offset.zero;
      // Animation curve for a smooth stop
      const curve = Curves.easeOut;

      // Combine Tween (start/end points) and Curve
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      // Apply the tweened animation to the child widget
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
