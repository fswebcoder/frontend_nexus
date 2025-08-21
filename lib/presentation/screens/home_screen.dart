import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:nexus/domain/entities/auth/request/login.entitie.dart';
import 'package:nexus/domain/usescases/auth/login_usecase.dart';
import 'package:nexus/shared/widgets/toast_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nexus - Toasts Simples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '🎉 Toasts con awesome_snackbar_content',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () => ToastHelper.success("¡Operación exitosa!"),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text('✅ Toast de Éxito'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => ToastHelper.error("Error de ejemplo"),
              icon: const Icon(Icons.error, color: Colors.white),
              label: const Text('❌ Toast de Error'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => ToastHelper.warning("Advertencia importante"),
              icon: const Icon(Icons.warning, color: Colors.white),
              label: const Text('⚠️ Toast de Advertencia'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => ToastHelper.info("Información útil"),
              icon: const Icon(Icons.info, color: Colors.white),
              label: const Text('ℹ️ Toast Informativo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              '📡 Test de Conectividad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => ToastHelper.connectionRestored(),
              icon: const Icon(Icons.wifi, color: Colors.white),
              label: const Text('🌐 Conexión Restaurada'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () => ToastHelper.noConnection(),
              icon: const Icon(Icons.wifi_off, color: Colors.white),
              label: const Text('📵 Sin Conexión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              '🎨 Métodos de Negocio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ToastHelper.validationError(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade400),
                    child: const Text('📝 Validación'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ToastHelper.networkError(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
                    child: const Text('📡 Red'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ToastHelper.dataSaved(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade400),
                    child: const Text('💾 Guardado'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => ToastHelper.updateAvailable(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade400),
                    child: const Text('🔄 Update'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),

            const Text(
              '🔐 Prueba de API Login',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _testLoginAPI,
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('🧪 Test Login API'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🧪 Prueba rápida del login API
  Future<void> _testLoginAPI() async {
    try {
      ToastHelper.info("Probando login API...");

      final loginUseCase = GetIt.instance<LoginUseCase>();

      final loginEntity = LoginEntity(username: "admin@quintana.com", password: "Borealis2025a");

      final result = await loginUseCase.call(loginEntity);

      if (result.success && result.data != null) {
        ToastHelper.success("${result.data!.email}");
      } else {
        ToastHelper.error("${result.message}");
      }
    } catch (e) {
      ToastHelper.error("💥 Error inesperado: $e");
    }
  }
}
