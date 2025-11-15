import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../features/login/views/login_page.dart';
import '../features/home/views/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
