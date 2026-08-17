import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ruya/core/di/injection.dart';
import 'package:ruya/core/presentation/cubit/bottom_nav_cubit.dart';
import 'package:ruya/core/widgets/main_layout.dart';
import 'package:ruya/core/widgets/placeholder_page.dart';
import 'package:ruya/features/chat/presentation/pages/chat_history_page.dart';
import 'package:ruya/features/chat/presentation/pages/ai_chat_page.dart';
import 'package:ruya/features/profile/presentation/screens/profile_screen.dart';
import 'package:ruya/features/site_details/presentation/screens/site_details_screen.dart';
import 'package:ruya/features/booking/presentation/screens/ticket_selection_screen.dart';
import 'package:ruya/features/booking/presentation/screens/booking_confirmation_screen.dart';
import 'package:ruya/features/auth/presentation/cubit/forget_password_cubit.dart';
import 'package:ruya/features/auth/presentation/pages/auth_page.dart';
import 'package:ruya/features/auth/presentation/pages/forget_password_email_page.dart';
import 'package:ruya/features/auth/presentation/pages/forget_password_otp_page.dart';
import 'package:ruya/features/auth/presentation/pages/forget_password_reset_page.dart';
import 'package:ruya/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:ruya/features/home/presentation/pages/home_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _forgotPasswordNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'forgotPassword');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        // Session restore: reads the local JWT and decodes exp — no network call.
        // If a valid session exists, skip the auth page and go straight to /home.
        redirect: (context, state) async {
          final user = await getIt<RestoreSessionUseCase>()();
          if (user != null) return '/home';
          return null;
        },
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/site-details',
        builder: (context, state) => const SiteDetailsScreen(),
      ),
      GoRoute(
        path: '/ticket-selection',
        builder: (context, state) => const TicketSelectionScreen(),
      ),
      GoRoute(
        path: '/booking-confirmation',
        builder: (context, state) => const BookingConfirmationScreen(),
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => const AiChatPage(),
      ),

      // -----------------------------------------------------------------------
      // Forgot-password flow — wrapped in a single ShellRoute so all three
      // pages share ONE [ForgetPasswordCubit] instance. This preserves the
      // email entered on page 1 when the user reaches the OTP and reset pages.
      // -----------------------------------------------------------------------
      ShellRoute(
        navigatorKey: _forgotPasswordNavigatorKey,
        builder: (context, state, child) {
          return BlocProvider(
            create: (_) => getIt<ForgetPasswordCubit>(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/forgot-password',
            parentNavigatorKey: _forgotPasswordNavigatorKey,
            builder: (context, state) => const ForgetPasswordEmailPage(),
          ),
          GoRoute(
            path: '/verify-otp',
            parentNavigatorKey: _forgotPasswordNavigatorKey,
            builder: (context, state) {
              final email = state.extra as String? ?? '';
              return ForgetPasswordOtpPage(email: email);
            },
          ),
          GoRoute(
            path: '/reset-password',
            parentNavigatorKey: _forgotPasswordNavigatorKey,
            builder: (context, state) => const ForgetPasswordResetPage(),
          ),
        ],
      ),

      // -----------------------------------------------------------------------
      // Main app shell — bottom nav
      // -----------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BlocProvider(
            create: (_) => getIt<BottomNavCubit>(),
            child: MainLayout(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatHistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/memories',
                builder: (context, state) =>
                    const PlaceholderPage(title: 'Memories Page'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
