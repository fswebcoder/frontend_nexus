import 'package:flutter/material.dart';
import 'package:nexus/core/utils/conection/connectivity_service.dart';
import 'package:nexus/presentation/di/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ConnectivityService _connectivityService;
  bool _isConnected = false;
  String _connectionStatus = 'Verificando...';

  @override
  void initState() {
    super.initState();
    _connectivityService = getIt<ConnectivityService>();
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    _checkConnectionStatus();

    _connectivityService.onConnectivityChanged.listen((isConnected) {
      if (mounted) {
        setState(() {
          _isConnected = isConnected;
          _connectionStatus = isConnected ? 'Conectado a internet' : 'Sin conexión a internet';
        });
      }
    });
  }

  Future<void> _checkConnectionStatus() async {
    final isConnected = await _connectivityService.isConnected;
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
        _connectionStatus = isConnected ? 'Conectado a internet' : 'Sin conexión a internet';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nexus - Gestión'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConnectivityCard(),
            const SizedBox(height: 24),
            _buildAppInfo(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectivityCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  color: _isConnected ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado de Conexión',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _connectionStatus,
                        style: TextStyle(
                          color: _isConnected ? Colors.green[700] : Colors.red[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isConnected ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _isConnected ? Colors.green[200]! : Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    _isConnected ? Icons.check_circle : Icons.error,
                    color: _isConnected ? Colors.green[600] : Colors.red[600],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isConnected
                          ? 'La aplicación puede realizar operaciones en línea'
                          : 'Funcionando en modo offline - algunas funciones no están disponibles',
                      style: TextStyle(fontSize: 13, color: _isConnected ? Colors.green[700] : Colors.red[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido a Nexus',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu aplicación de gestión con detección automática de conectividad.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'La aplicación monitorea constantemente tu conexión a internet',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _checkConnectionStatus,
          icon: const Icon(Icons.refresh),
          label: const Text('Verificar Conexión'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _isConnected ? _simulateApiCall : null,
          icon: const Icon(Icons.cloud_sync),
          label: const Text('Simular Llamada API'),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
        ),
      ],
    );
  }

  void _simulateApiCall() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Las llamadas a la API verificarán automáticamente la conectividad'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
