import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<RegisterEvent>(_onRegisterEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
    on<UpdateAuthUserEvent>(_onUpdateAuthUserEvent);
  }

  Future<void> _onLoginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await loginUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterEvent(
      RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await registerUseCase(RegisterParams(
      nombre: event.nombre,
      apellido: event.apellido,
      email: event.email,
      password: event.password,
      telefono: event.telefono,
    ));

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutEvent(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await logoutUseCase();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatusEvent(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    // ✅ Implementar lógica real aquí
    // Por ejemplo: verificar token en SharedPreferences, etc.
    emit(AuthLoading());

    // Simulación - deberías implementar tu lógica real
    await Future.delayed(const Duration(milliseconds: 500));

    // Ejemplo: si tienes un token válido, emitir AuthAuthenticated
    // Si no, emitir AuthUnauthenticated
    emit(AuthUnauthenticated());
  }

  // ✅ Método corregido - mismo patrón que los demás
  Future<void> _onUpdateAuthUserEvent(
      UpdateAuthUserEvent event, Emitter<AuthState> emit) async {
    // Si ya estamos autenticados, actualizamos el usuario
    if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(user: event.user));
    }
  }
}
