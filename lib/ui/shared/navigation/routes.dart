import 'package:flutter/material.dart';
import 'package:ret_cat/ui/views/auth/signup_view.dart';
import 'package:ret_cat/ui/views/drawer/market_visit/market_visit_photo_view.dart';
import 'package:ret_cat/ui/views/drawer/sales_report/management_report_view.dart';
import 'package:ret_cat/ui/views/user/profile_update_view.dart';
import 'package:ret_cat/ui/views/user/profile_view.dart';

import '../../views/auth/login_view.dart';
import '../../views/drawer/component/leave_application_view.dart';
import '../../views/drawer/sales_report/evening_report_view.dart';
import '../../views/drawer/sales_report/morning_report_view.dart';
import '../../views/home/home_view.dart';
import '../../views/splash_screen_view.dart';
import 'fade_transition_route.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return FadeTransitionPageRouteBuilder(page: const SplashScreenView());

    case '/login':
      return FadeTransitionPageRouteBuilder(page: const LoginView());

    case '/signup':
      return FadeTransitionPageRouteBuilder(page: const SignupView());

    case '/home':
      return FadeTransitionPageRouteBuilder(page: const HomeView());

    case '/profile':
      return FadeTransitionPageRouteBuilder(page: const ProfileView());

    case '/profile-update':
      return FadeTransitionPageRouteBuilder(page: const ProfileUpdateView());

    case '/leave-application':
      return FadeTransitionPageRouteBuilder(page: const LeaveApplicationView());

    case '/morning-report':
      return FadeTransitionPageRouteBuilder(page: const MorningReportView());

    case '/evening-report':
      return FadeTransitionPageRouteBuilder(page: const EveningReportView());

    case '/management-report':
      return FadeTransitionPageRouteBuilder(
          page: ManagementReportView(
        type: settings.arguments as String,
      ));

    case '/market-visit':
      return FadeTransitionPageRouteBuilder(page: const MarketVisitPhotoView());

    default:
      return MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
          ),
          body: const Center(
            child: Text('404 Page not found'),
          ),
        );
      });
  }
}
