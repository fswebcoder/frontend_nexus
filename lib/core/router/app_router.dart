import 'package:go_router/go_router.dart';
import 'package:nexus/presentation/screens/home_screen.dart';
import 'package:nexus/presentation/screens/splash/splash_screem.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // 👈 Sigue siendo '/' pero ahora va al splash
  routes: [
    // Splash como ruta inicial
    GoRoute(path: '/', name: 'splash', builder: (context, state) => const SplashScreen()),

    // Home como segunda ruta
    GoRoute(path: '/home', name: 'home', builder: (context, state) => const HomeScreen()),
  ],
);
