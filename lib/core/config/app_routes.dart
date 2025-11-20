import 'package:flutter/material.dart';

import '../../domain/model/plato.dart';
import '../../domain/model/cliente.dart';
import '../../domain/model/pedido.dart';

import '../../presentation/ui/plato_list_screen.dart';
import '../../presentation/ui/plato_form_screen.dart';

import '../../presentation/ui/cliente_list_screen.dart';
import '../../presentation/ui/cliente_form_screen.dart';

import '../../presentation/ui/pedido_list_screen.dart';
import '../../presentation/ui/pedido_form_screen.dart';

class AppRoutes {
  static const String platos = '/platos';
  static const String clientes = '/clientes';
  static const String pedidos = '/pedidos';

  static const String platoForm = '/platoForm';
  static const String clienteForm = '/clienteForm';
  static const String pedidoForm = '/pedidoForm';

  static Map<String, WidgetBuilder> routes = {
    platos: (_) => const PlatoListScreen(),
    clientes: (_) => const ClienteListScreen(),
    pedidos: (_) => const PedidoListScreen(),

    platoForm: (context) {
      final arg = ModalRoute.of(context)!.settings.arguments as Plato?;
      return PlatoFormScreen(plato: arg);
    },
    clienteForm: (context) {
      final arg = ModalRoute.of(context)!.settings.arguments as Cliente?;
      return ClienteFormScreen(cliente: arg);
    },
    pedidoForm: (context) {
      final arg = ModalRoute.of(context)!.settings.arguments as Pedido?;
      return PedidoFormScreen(pedido: arg);
    },
  };
}
