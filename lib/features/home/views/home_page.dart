import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../login/controllers/login_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel - Paquetería'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(loginControllerProvider.notifier).logout();
              // Volverá por la lógica del router a /login si así lo configuras
              Navigator.of(context).pushReplacementNamed('/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          )
        ],
      ),
      body: const Center(child: Text('Bienvenido — pantalla en blanco')),
    );
  }
}
