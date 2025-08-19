import 'package:flutter/material.dart';
import 'package:nexus/core/utils/conection/connectivity_service.dart';
import 'package:nexus/presentation/di/service_locator.dart';
import 'package:nexus/shared/constants/message.contants.dart';
import 'package:nexus/shared/widgets/toast_helper.dart';

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({super.key, required this.child});

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late ConnectivityService _connectivityService;
  bool _showBanner = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  void _initConnectivity() async {
    try {
      _connectivityService = getIt<ConnectivityService>();
      await Future.delayed(const Duration(milliseconds: 500));

      final initialConnection = await _connectivityService.isConnected;

      if (mounted) {
        setState(() {
          _showBanner = !initialConnection;
          _isInitialized = true;
        });
      }

      _connectivityService.onConnectivityChanged.listen((isConnected) {
        if (mounted) {
          final shouldShowBanner = !isConnected;
          if (_showBanner != shouldShowBanner) {
            setState(() {
              _showBanner = shouldShowBanner;

              if (isConnected) {
                ToastHelper.connectionRestored(icon: Icons.wifi_tethering);
              }
            });
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _showBanner = false;
          _isInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [widget.child, if (_isInitialized && _showBanner) _buildNoInternetBanner()]),
    );
  }

  Widget _buildNoInternetBanner() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 50,
        color: Colors.red[600],
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    MessageConstants.noInternetConnection,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(Icons.error_outline, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
