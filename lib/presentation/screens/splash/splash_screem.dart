import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/styles/app_colors.dart';

/// Pantalla de splash animada y minimalista
/// Implementa múltiples animaciones secuenciales para una experiencia fluida
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Controladores de animación para diferentes elementos
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _appsController;

  // Animaciones específicas
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _progressFadeAnimation;

  // Animaciones para los elementos de apps
  late Animation<double> _app1Animation;
  late Animation<double> _app2Animation;
  late Animation<double> _app3Animation;
  late Animation<double> _app4Animation;
  late Animation<double> _connectionsAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  /// Inicializa todos los controladores y animaciones
  void _initializeAnimations() {
    // Controlador para el logo central (fade-in y escala)
    _logoController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    // Controlador para los elementos de apps (convergencia)
    _appsController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    // Controlador para el texto (fade-in y deslizamiento)
    _textController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    // Controlador para el indicador de progreso
    _progressController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    // Animaciones del logo
    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Animaciones del texto
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutQuart));

    // Animación del indicador de progreso
    _progressFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeIn));

    // Animaciones de los elementos de apps (convergencia desde diferentes direcciones)
    _app1Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appsController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _app2Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appsController,
        curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _app3Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appsController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
      ),
    );

    _app4Animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appsController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutBack),
      ),
    );

    _connectionsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _appsController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  /// Inicia la secuencia de animaciones con delays apropiados
  void _startAnimationSequence() async {
    try {
      // Animar elementos de apps primero (convergencia)
      if (mounted) _appsController.forward();

      // Animar logo central después de 200ms
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) _logoController.forward();

      // Animar texto después de 600ms
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) _textController.forward();

      // Animar indicador de progreso después de 400ms más
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) _progressController.forward();

      // Navegar después de completar las animaciones
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) _navigateToLogin();
    } catch (e) {
      // En caso de error, navegar directamente
      if (mounted) _navigateToLogin();
    }
  }

  /// Navega a la pantalla de login
  void _navigateToLogin() {
    context.go('/login');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _appsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: _buildGradientBackground(),
        child: SafeArea(
          child: Column(
            children: [
              // Espacio superior flexible
              const Spacer(flex: 2),

              // Logo animado
              _buildAnimatedLogo(),

              const SizedBox(height: 40),

              // Título y subtítulo animados
              _buildAnimatedText(),

              // Espacio flexible entre texto e indicador
              const Spacer(flex: 2),

              // Indicador de progreso
              _buildAnimatedProgressIndicator(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el fondo con gradiente elegante
  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryColor.shade600,
          AppColors.primaryColor.shade800,
          AppColors.accentColor.shade200.withValues(alpha: 0.8),
        ],
        stops: const [0.0, 0.7, 1.0],
      ),
    );
  }

  /// Construye el logo con animaciones de fade-in y escala
  Widget _buildAnimatedLogo() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo central (hub)
          AnimatedBuilder(
            animation: _logoController,
            builder: (context, child) {
              return Transform.scale(
                scale: _logoScaleAnimation.value.clamp(0.0, 1.0),
                child: Opacity(
                  opacity: _logoFadeAnimation.value.clamp(0.0, 1.0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blackColor.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(Icons.hub, size: 30, color: AppColors.primaryColor.shade600),
                  ),
                ),
              );
            },
          ),

          // Elementos de apps que convergen
          _buildAppElement(_app1Animation, const Offset(-60, -60), Icons.dashboard_outlined, AppColors.accentColor),
          _buildAppElement(_app2Animation, const Offset(60, -60), Icons.analytics_outlined, AppColors.secondaryColor),
          _buildAppElement(_app3Animation, const Offset(-60, 60), Icons.people_outline, AppColors.primaryColor),
          _buildAppElement(_app4Animation, const Offset(60, 60), Icons.settings_outlined, AppColors.accentColor),

          // Líneas de conexión
          _buildConnectionLines(),
        ],
      ),
    );
  }

  /// Construye un elemento individual de app con animación
  Widget _buildAppElement(Animation<double> animation, Offset position, IconData icon, MaterialColor color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        final currentOffset = Offset(
          position.dx * (1 - progress * 0.3), // Se acerca al centro gradualmente
          position.dy * (1 - progress * 0.3),
        );

        // Obtener colores seguros usando el color base si hay problemas
        Color mainColor;
        Color shadowColor;

        try {
          mainColor = color.shade400;
          shadowColor = color.shade700;
        } catch (e) {
          // Fallback a colores seguros
          mainColor = color;
          shadowColor = color;
        }

        // Asegurar que los valores estén en rangos válidos
        final clampedProgress = progress.clamp(0.0, 1.0);
        final clampedScale = progress.clamp(0.0, 1.0);

        return Transform.translate(
          offset: currentOffset,
          child: Transform.scale(
            scale: clampedScale,
            child: Opacity(
              opacity: clampedProgress,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: mainColor.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: shadowColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2)),
                  ],
                ),
                child: Icon(icon, size: 20, color: AppColors.whiteColor),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Construye las líneas de conexión entre elementos
  Widget _buildConnectionLines() {
    return AnimatedBuilder(
      animation: _connectionsAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _connectionsAnimation.value.clamp(0.0, 1.0),
          child: CustomPaint(
            size: const Size(160, 160),
            painter: ConnectionLinesPainter(
              progress: _connectionsAnimation.value.clamp(0.0, 1.0),
              color: AppColors.whiteColor.withValues(alpha: 0.4),
            ),
          ),
        );
      },
    );
  }

  /// Construye el texto con animaciones de fade-in y deslizamiento
  Widget _buildAnimatedText() {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _textSlideAnimation.value),
          child: Opacity(
            opacity: _textFadeAnimation.value.clamp(0.0, 1.0),
            child: Column(
              children: [
                // Título principal
                const Text(
                  'Nexus',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteColor,
                    letterSpacing: 2.0,
                  ),
                ),

                const SizedBox(height: 12),

                // Subtítulo
                Text(
                  'Suite de aplicaciones integradas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: AppColors.whiteColor.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Construye el indicador de progreso animado
  Widget _buildAnimatedProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Opacity(
          opacity: _progressFadeAnimation.value.clamp(0.0, 1.0),
          child: Column(
            children: [
              // Indicador de progreso personalizado
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor.withValues(alpha: 0.8)),
                ),
              ),

              const SizedBox(height: 16),

              // Texto de carga
              Text(
                'Cargando...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.whiteColor.withValues(alpha: 0.7),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Custom painter para dibujar líneas de conexión entre los elementos de apps
class ConnectionLinesPainter extends CustomPainter {
  final double progress;
  final Color color;

  const ConnectionLinesPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Posiciones de los elementos de apps
    final positions = [
      Offset(center.dx - 60, center.dy - 60), // Superior izquierda
      Offset(center.dx + 60, center.dy - 60), // Superior derecha
      Offset(center.dx - 60, center.dy + 60), // Inferior izquierda
      Offset(center.dx + 60, center.dy + 60), // Inferior derecha
    ];

    // Dibujar líneas desde cada elemento hacia el centro
    for (final position in positions) {
      final adjustedPosition = Offset(
        center.dx + (position.dx - center.dx) * 0.7, // Ajuste para convergencia
        center.dy + (position.dy - center.dy) * 0.7,
      );

      final startX = adjustedPosition.dx;
      final startY = adjustedPosition.dy;
      final endX = center.dx;
      final endY = center.dy;

      // Animar la línea basada en el progreso
      final currentEndX = startX + (endX - startX) * progress;
      final currentEndY = startY + (endY - startY) * progress;

      canvas.drawLine(adjustedPosition, Offset(currentEndX, currentEndY), paint);
    }
  }

  @override
  bool shouldRepaint(ConnectionLinesPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
