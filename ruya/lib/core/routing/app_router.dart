import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/features/auth/presentation/pages/auth_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/explore',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Explore — coming soon')),
        ),
      ),
    ],
  );
}
