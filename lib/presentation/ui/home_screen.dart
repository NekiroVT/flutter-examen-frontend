import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../adapter/app_navigator.dart'; 
import '../../domain/usecase/cliente_usecases.dart';
import '../../domain/usecase/plato_usecases.dart';
import '../../domain/usecase/pedido_usecases.dart';
import '../../core/di/service_locator.dart';
import '../viewmodel/pedido_list_viewmodel.dart'; 
// No se necesitan estos imports aquí si solo se usan en el ViewModel
// import '../viewmodel/cliente_list_viewmodel.dart'; 
// import '../viewmodel/plato_list_viewmodel.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Configuración del ViewModel con Provider
    return ChangeNotifierProvider(
      create: (_) => PedidoListViewModel(
        getPedidos: getIt<GetPedidosUseCase>(),
        deletePedido: getIt<DeletePedidoUseCase>(),
        getClientes: getIt<GetClientesUseCase>(),
        getPlatos: getIt<GetPlatosUseCase>(),
      )..load(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  // Widget reutilizable para crear los botones con diseño de tarjeta
  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
    required Color color,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        leading: Icon(icon, size: 40, color: color),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal 🍽️'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Container(
        // Fondo más sutil para darle un toque de estilo
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Título de bienvenida con estilo
            const Padding(
              padding: EdgeInsets.only(bottom: 25, top: 10),
              child: Text(
                'Gestión de Restaurante',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF303030),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // 1. Tarjeta de Pedidos (La más importante)
            _buildMenuCard(
              context: context,
              title: 'Gestión de Pedidos',
              subtitle: 'Revisa, crea y actualiza los pedidos de la mesa.',
              icon: Icons.receipt_long,
              route: AppNavigator.pedidosRoute,
              color: Colors.deepOrange, // Color llamativo
            ),

            // 2. Tarjeta de Platos
            _buildMenuCard(
              context: context,
              title: 'Carta y Platos',
              subtitle: 'Administra el menú: precios e inventario.',
              icon: Icons.restaurant_menu,
              route: AppNavigator.platosRoute,
              color: Colors.green, // Color asociado a comida/menú
            ),

            // 3. Tarjeta de Clientes
            _buildMenuCard(
              context: context,
              title: 'Base de Clientes',
              subtitle: 'Consulta y gestiona la información de los clientes.',
              icon: Icons.people,
              route: AppNavigator.clientesRoute,
              color: Colors.blueAccent, // Color asociado a personas
            ),

            // Espacio al final (opcional)
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}