import 'package:flutter/material.dart';
import 'package:nexus/core/utils/connectivity_service.dart';
import 'package:nexus/presentation/di/service_locator.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late ConnectivityService _connectivityService;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  void _initConnectivity() async {
    _connectivityService = getIt<ConnectivityService>();

    final initialConnection = await _connectivityService.isConnected;
    if (mounted) {
      setState(() {
        _showBanner = !initialConnection;
      });
    }

    _connectivityService.onConnectivityChanged.listen((isConnected) {
      if (mounted) {
        setState(() {
          _showBanner = !isConnected;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(child: Stack(children: [widget.child, if (_showBanner) _buildNoInternetBanner()]));
  }

  Widget _buildNoInternetBanner() {
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Material(
        elevation: 4,
        color: Colors.red[600],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Sin conexión a internet',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 12,
                width: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withValues(alpha: 0.8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
