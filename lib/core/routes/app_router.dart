import 'package:attendance_monitoring/features/auth/presentation/screens/login_screen.dart';

import './app_routes.dart';
import "package:go_router/go_router.dart";
import 'package:flutter/material.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: Routes.login,
      builder: (BuildContext context, GoRouterState state) =>
          const LoginScreen(),
    ),
  ],
);
