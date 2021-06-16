/*
*   Dart core dependency imports
* */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
*  Customized page route to hero model popup
* */
class HeroModelPopupRoute<T> extends PageRoute<T> {
  final WidgetBuilder _builder;

  HeroModelPopupRoute({
    required WidgetBuilder builder,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(fullscreenDialog: fullscreenDialog);

  @override
  Color? get barrierColor => Colors.black54;

  @override
  String? get barrierLabel => 'Hero Popup dialog open';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  bool get barrierDismissible => false;
}
