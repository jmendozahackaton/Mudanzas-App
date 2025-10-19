import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() {
    // Check if user is logged in and navigate accordingly
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<AuthBloc>().add(CheckAuthStatusEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          print('🎯 Splash: Usuario autenticado - Rol: ${state.user.rol}');

          // Navegar según el rol del usuario
          switch (state.user.rol) {
            case 'admin':
              print('🎯 Splash: Redirigiendo a Admin Dashboard');
              Navigator.pushReplacementNamed(context, '/admin');
              break;
            case 'proveedor':
              print('🎯 Splash: Redirigiendo a Provider Dashboard');
              Navigator.pushReplacementNamed(context, '/provider/dashboard');
              break;
            case 'cliente':
            default:
              print('🎯 Splash: Redirigiendo a Home Cliente');
              Navigator.pushReplacementNamed(context, '/home');
          }
        } else if (state is AuthUnauthenticated) {
          print('🎯 Splash: Usuario no autenticado - Redirigiendo a Login');
          Navigator.pushReplacementNamed(context, '/login');
        } else if (state is AuthError) {
          print('🎯 Splash: Error de autenticación - ${state.message}');
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade700,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping,
                  size: 60,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 30),
              // App Name
              const Text(
                'Mudanzas App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              // Tagline
              const Text(
                'Tu solución de mudanzas',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 50),
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
