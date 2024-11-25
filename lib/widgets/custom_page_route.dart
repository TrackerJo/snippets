import 'package:flutter/material.dart';

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
  //Override route to be false
  @override
  bool get maintainState => false;
}

class SlideLeftToRightPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  SlideLeftToRightPageRoute({required this.child})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => child,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return Stack(
                children: [
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    )),
                    child: child,
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).animate(CurvedAnimation(
                      parent: secondaryAnimation,
                      curve: Curves.easeOut,
                    )),
                    child: Container(), // Blank container for old page
                  ),
                ],
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
            reverseTransitionDuration: const Duration(milliseconds: 300));
}
