import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/login_request.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final loginControllerProvider =
StateNotifierProvider<LoginController, AsyncValue<bool>>(
      (ref) => LoginController(ref),
);

class LoginController extends StateNotifier<AsyncValue<bool>> {
  LoginController(this.ref) : super(const AsyncData(false));

  final Ref ref;

  Future<void> login(String user, String pass, {bool remember = true}) async {
    if (user.trim().isEmpty || pass.isEmpty) {
      state = AsyncError('Usuario y contraseña son obligatorios', StackTrace.current);
      return;
    }

    state = const AsyncLoading();

    final service = ref.read(authServiceProvider);
    final request = LoginRequest(username: user.trim(), password: pass);

    try {
      final token = await service.login(request);
      // token ya guardado en AuthService.saveToken()
      state = const AsyncData(true);
    } catch (e, st) {
      state = AsyncError(e.toString(), st);
    }
  }

  Future<void> logout() async {
    state = const AsyncData(false);
    final service = ref.read(authServiceProvider);
    await service.logout();
  }
}
