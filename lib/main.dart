import 'package:flutter/material.dart';
import 'core/di/service_locator.dart';
import 'presentation/adapter/app_navigator.dart';
import 'core/config/app_theme.dart';
import 'presentation/ui/loading_screen.dart';  // Importa la pantalla de carga
import 'presentation/ui/home_screen.dart';   // Importa la pantalla principal (Home)

void main() {
  setupLocator();
  runApp(const ExamenPedidosApp());
}

class ExamenPedidosApp extends StatelessWidget {
  const ExamenPedidosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Examen Pedidos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,       // Tu tema
      routes: AppNavigator.routes,      // Rutas configuradas
      initialRoute: AppNavigator.loadingRoute,  // Ruta inicial para la pantalla de carga
      // Cambia la ruta inicial a HomeScreen:
      // initialRoute: '/home',        // O la ruta que definas en AppNavigator
    );
  }
}
