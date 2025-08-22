import 'package:go_router/go_router.dart';
import 'package:nexus/presentation/screens/auth/login/login_screen.dart';
import 'package:nexus/presentation/screens/splash/splash_screem.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginScreen()),
  ],
);
