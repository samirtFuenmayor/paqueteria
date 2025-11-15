import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/login_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _remember = true;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen<AsyncValue<bool>>(loginControllerProvider, (prev, next) {
      next.when(
        data: (ok) {
          if (ok) {
            // Navega a home y reemplaza la pila para evitar back al login
            context.go('/home');
          }
        },
        loading: () {},
        error: (e, st) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Error de inicio de sesión",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text(e.toString().replaceAll("Exception: ", "")),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cerrar"),
                  )
                ],
              );
            },
          );
        },
      );
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _userCtrl,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Usuario o correo',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Ingrese su usuario';
              if (v.contains('@') && !v.contains('.')) return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Ingrese su contraseña';
              if (v.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: _remember,
                onChanged: (v) => setState(() => _remember = v ?? true),
              ),
              const Text('Recordarme'),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Implementa recuperación o UI futura
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Función no implementada')));
                },
                child: const Text('¿Olvidaste la contraseña?'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: loginState.isLoading ? null : _submit,
              child: loginState.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Ingresar'),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // Llamar al controller
    ref.read(loginControllerProvider.notifier).login(_userCtrl.text, _passCtrl.text, remember: _remember);
  }
}
