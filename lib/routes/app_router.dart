import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/app/presentation/main_screen.dart';
import 'package:pinterest_clone/features/home/presentation/home_screen.dart';
import 'package:pinterest_clone/features/search/presentation/search_screen.dart';
import 'package:pinterest_clone/features/profile/presentation/profile_screen.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),   // 👈 VERY IMPORTANT
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
