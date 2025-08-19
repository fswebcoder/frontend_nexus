import 'package:go_router/go_router.dart';
import 'package:nexus/presentation/screens/home_screen.dart';
import 'package:nexus/presentation/screens/splash/splash_screem.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 'splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/login', name: 'login', builder: (context, state) => const HomeScreen()),
  ],
);
