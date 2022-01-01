import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:yoda_res/ui/startup/startup_viewmodel.dart';

class StartUpAnimatedTextHook extends HookViewModelWidget<StartUpViewModel> {
  final Widget child;
  final int? delay;
  const StartUpAnimatedTextHook(
      {required this.child, required this.delay, Key? key})
      : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, StartUpViewModel model) {
    final _animController =
        useAnimationController(duration: Duration(milliseconds: 800));
    Animation<double> _fadeInFadeOut;
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 1).animate(_animController);

    Animation<Offset> _animOffset;

    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    // _animOffset =
    //     Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
    //         .animate(curve);

    Timer(Duration(milliseconds: delay!), () {
      _animController.forward();
    });

    return FadeTransition(
      child: child,
      // child: SlideTransition(
      //   position: _animOffset,
      //   child: child,
      // ),
      opacity: _fadeInFadeOut,
    );
  }
}
