import 'package:flutter/material.dart';

import 'fade_transition_route.dart';

class Navigation {
  final String initialRoute = "/";

  Navigation._privateConstructor();

  static final Navigation instance = Navigation._privateConstructor();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigate(String path, {Object? args}) {
    return navigatorKey.currentState?.pushNamed(path, arguments: args);
  }

  Future<dynamic>? navigateWidget(Widget widget) {
    return navigatorKey.currentState?.push(
      FadeTransitionPageRouteBuilder(page: widget),
    );
  }

  Future<dynamic>? navigateAndReplace(String path, {Object? args}) {
    return navigatorKey.currentState?.pushReplacementNamed(path, arguments: args);
  }

  Future<dynamic>? navigateAndRemoveUntil(String path, {Object? args}) {
    return navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(path, (Route<dynamic> route) => false, arguments: args);
  }

  goBack() {
    return navigatorKey.currentState?.pop();
  }

  maybeGoBack() {
    return navigatorKey.currentState?.maybePop();
  }
}
