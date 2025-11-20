import 'dart:async';
import 'package:flutter/material.dart';
import 'package:examen_flutter_frontend/services/music_service.dart';
import '../adapter/app_navigator.dart'; // Asegúrate de que esta ruta sea correcta

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final MusicService _musicService = MusicService(); 
  bool _isLoadingComplete = false; 

  @override
  void initState() {
    super.initState();

    _musicService.init();

    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);

    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        setState(() {
          _isLoadingComplete = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTapAndNavigate() {
    _musicService.playMusic(); 
    Navigator.pushReplacementNamed(context, AppNavigator.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/comida_wimiline.png', 
                width: 150, 
                height: 150,
              ),
            ),
            
            const SizedBox(height: 50),

            if (_isLoadingComplete)
              ElevatedButton(
                onPressed: _handleTapAndNavigate,
                child: const Text('Toca para Continuar'),
              )
            else
              const Text('Cargando datos...', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}