import 'package:flutter/material.dart';

class MovingTrackingPage extends StatefulWidget {
  const MovingTrackingPage({super.key});

  @override
  State<MovingTrackingPage> createState() => _MovingTrackingPageState();
}

class _MovingTrackingPageState extends State<MovingTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento en Tiempo Real'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 64,
              color: Colors.blue.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'Seguimiento GPS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Funcionalidad en desarrollo',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implementar seguimiento GPS
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Seguimiento GPS en desarrollo')),
                );
              },
              child: const Text('Iniciar Seguimiento'),
            ),
          ],
        ),
      ),
    );
  }
}
