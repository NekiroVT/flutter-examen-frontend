import 'package:flutter/material.dart';

import '../../domain/model/plato.dart';
import '../../domain/model/cliente.dart';
import '../../domain/model/pedido.dart';

import '../ui/plato_form_screen.dart';
import '../ui/plato_list_screen.dart';
import '../ui/cliente_form_screen.dart';
import '../ui/cliente_list_screen.dart';
import '../ui/pedido_form_screen.dart';
import '../ui/pedido_list_screen.dart';
import '../ui/loading_screen.dart'; // Importa la pantalla de carga
import '../ui/home_screen.dart'; // Importa la pantalla principal (HomeScreen)

class AppNavigator {
  // Definición de rutas
  static const String loadingRoute = '/';   // Pantalla de carga
  static const String homeRoute = '/home';  // Pantalla principal (HomeScreen)
  static const String platosRoute = '/platos'; // Ruta para los platos
  static const String clientesRoute = '/clientes'; // Ruta para los clientes
  static const String pedidosRoute = '/pedidos'; // Ruta para los pedidos

  static const String platoFormRoute = '/platoForm'; // Ruta para crear o editar plato
  static const String clienteFormRoute = '/clienteForm'; // Ruta para crear o editar cliente
  static const String pedidoFormRoute = '/pedidoForm'; // Ruta para crear o editar pedido

  // Mapa de rutas
  static Map<String, WidgetBuilder> routes = {
    loadingRoute: (_) => const LoadingScreen(),  // Ruta a la pantalla de carga
    homeRoute: (_) => const HomeScreen(),        // Ruta a la pantalla principal
    platosRoute: (_) => const PlatoListScreen(), // Ruta a la lista de platos
    clientesRoute: (_) => const ClienteListScreen(), // Ruta a la lista de clientes
    pedidosRoute: (_) => const PedidoListScreen(), // Ruta a la lista de pedidos
    platoFormRoute: (context) {
      final plato = ModalRoute.of(context)!.settings.arguments as Plato?;
      return PlatoFormScreen(plato: plato);  // Ruta para crear o editar plato
    },
    clienteFormRoute: (context) {
      final cliente = ModalRoute.of(context)!.settings.arguments as Cliente?;
      return ClienteFormScreen(cliente: cliente);  // Ruta para crear o editar cliente
    },
    pedidoFormRoute: (context) {
      final pedido = ModalRoute.of(context)!.settings.arguments as Pedido?;
      return PedidoFormScreen(pedido: pedido);  // Ruta para crear o editar pedido
    },
  };

  // Métodos helpers para navegar entre pantallas

  static Future<void> goToHome(BuildContext ctx) =>
      Navigator.pushNamed(ctx, homeRoute);  // Navegar a la pantalla principal

  static Future<void> goToNuevoPlato(BuildContext ctx) =>
      Navigator.pushNamed(ctx, platoFormRoute);  // Navegar a la pantalla de creación de plato

  static Future<void> goToEditarPlato(BuildContext ctx, Plato p) =>
      Navigator.pushNamed(ctx, platoFormRoute, arguments: p);  // Navegar a la pantalla de edición de plato

  static Future<void> goToNuevoCliente(BuildContext ctx) =>
      Navigator.pushNamed(ctx, clienteFormRoute);  // Navegar a la pantalla de creación de cliente

  static Future<void> goToEditarCliente(BuildContext ctx, Cliente c) =>
      Navigator.pushNamed(ctx, clienteFormRoute, arguments: c);  // Navegar a la pantalla de edición de cliente

  static Future<void> goToNuevoPedido(BuildContext ctx) =>
      Navigator.pushNamed(ctx, pedidoFormRoute);  // Navegar a la pantalla de creación de pedido

  static Future<void> goToEditarPedido(BuildContext ctx, Pedido p) =>
      Navigator.pushNamed(ctx, pedidoFormRoute, arguments: p);  // Navegar a la pantalla de edición de pedido
}
