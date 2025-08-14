import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus/core/styles/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _appsController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _progressFadeAnimation;

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

  void _initializeAnimations() {
    _logoController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _appsController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _textController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _progressController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

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

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _textSlideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOutQuart));

    _progressFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _progressController, curve: Curves.easeIn));

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

  void _startAnimationSequence() async {
    try {
      if (mounted) _appsController.forward();

      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) _logoController.forward();

      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) _textController.forward();
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) _progressController.forward();

      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) _navigateToLogin();
    } catch (e) {
      if (mounted) _navigateToLogin();
    }
  }

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
              const Spacer(flex: 2),
              _buildAnimatedLogo(),
              const SizedBox(height: 40),
              _buildAnimatedText(),
              const Spacer(flex: 2),
              _buildAnimatedProgressIndicator(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

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

  Widget _buildAnimatedLogo() {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
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
                    child: Icon(Icons.business_center_outlined, size: 30, color: AppColors.primaryColor.shade600),
                  ),
                ),
              );
            },
          ),

          _buildAppElement(_app1Animation, const Offset(-60, -60), Icons.balance_outlined, AppColors.accentColor),
          _buildAppElement(_app2Animation, const Offset(60, -60), Icons.analytics_outlined, AppColors.secondaryColor),
          _buildAppElement(_app3Animation, const Offset(-60, 60), Icons.people_outline, AppColors.primaryColor),
          _buildAppElement(_app4Animation, const Offset(60, 60), Icons.settings_outlined, AppColors.accentColor),

          _buildConnectionLines(),
        ],
      ),
    );
  }

  Widget _buildAppElement(Animation<double> animation, Offset position, IconData icon, MaterialColor color) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value;
        final currentOffset = Offset(position.dx * (1 - progress * 0.3), position.dy * (1 - progress * 0.3));

        Color mainColor;
        Color shadowColor;

        try {
          mainColor = color.shade400;
          shadowColor = color.shade700;
        } catch (e) {
          mainColor = color;
          shadowColor = color;
        }

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

                Text(
                  'Suite de aplicaciones Sunvalley Investment',
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

  Widget _buildAnimatedProgressIndicator() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Opacity(
          opacity: _progressFadeAnimation.value.clamp(0.0, 1.0),
          child: Column(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.whiteColor.withValues(alpha: 0.8)),
                ),
              ),

              const SizedBox(height: 16),

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

    final positions = [
      Offset(center.dx - 60, center.dy - 60),
      Offset(center.dx + 60, center.dy - 60),
      Offset(center.dx - 60, center.dy + 60),
      Offset(center.dx + 60, center.dy + 60),
    ];

    for (final position in positions) {
      final adjustedPosition = Offset(
        center.dx + (position.dx - center.dx) * 0.7,
        center.dy + (position.dy - center.dy) * 0.7,
      );

      final startX = adjustedPosition.dx;
      final startY = adjustedPosition.dy;
      final endX = center.dx;
      final endY = center.dy;

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
