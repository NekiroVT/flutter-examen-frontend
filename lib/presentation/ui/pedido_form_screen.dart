import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common/result.dart';
import '../../core/di/service_locator.dart';
import '../../domain/model/pedido.dart';
import '../../domain/model/cliente.dart';
import '../../domain/model/plato.dart';
import '../../domain/usecase/pedido_usecases.dart';
import '../../domain/usecase/cliente_usecases.dart';
import '../../domain/usecase/plato_usecases.dart';
import '../viewmodel/pedido_form_viewmodel.dart';

class PedidoFormScreen extends StatelessWidget {
  final Pedido? pedido;

  const PedidoFormScreen({super.key, this.pedido});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PedidoFormViewModel(
        createPedido: getIt<CreatePedidoUseCase>(),
        updatePedido: getIt<UpdatePedidoUseCase>(),
      ),
      child: _PedidoFormBody(pedido: pedido),
    );
  }
}

class _PedidoFormBody extends StatefulWidget {
  final Pedido? pedido;

  const _PedidoFormBody({required this.pedido});

  @override
  State<_PedidoFormBody> createState() => _PedidoFormBodyState();
}

class _PedidoFormBodyState extends State<_PedidoFormBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _mesaController;

  List<Cliente> _clientes = [];
  Cliente? _clienteSeleccionado;
  bool _cargandoClientes = false;

  List<Plato> _platos = [];
  Plato? _platoSeleccionado;
  bool _cargandoPlatos = false;

  @override
  void initState() {
    super.initState();
    final p = widget.pedido;
    _mesaController =
        TextEditingController(text: p?.numeroMesa.toString() ?? '');

    _cargarClientes();
    _cargarPlatos();
  }

  Future<void> _cargarClientes() async {
    setState(() => _cargandoClientes = true);

    final getClientes = getIt<GetClientesUseCase>();
    final res = await getClientes();

    if (res.isSuccess && res.data != null) {
      _clientes = res.data!;

      final clienteIdPedido = widget.pedido?.clienteId;
      if (clienteIdPedido != null) {
        try {
          _clienteSeleccionado =
              _clientes.firstWhere((c) => c.id == clienteIdPedido);
        } catch (_) {}
      }
    }

    setState(() => _cargandoClientes = false);
  }

  Future<void> _cargarPlatos() async {
    setState(() => _cargandoPlatos = true);

    final getPlatos = getIt<GetPlatosUseCase>();
    final res = await getPlatos();

    if (res.isSuccess && res.data != null) {
      _platos = res.data!;

      final platoIdPedido = widget.pedido?.platoId;
      if (platoIdPedido != null) {
        try {
          _platoSeleccionado =
              _platos.firstWhere((p) => p.id == platoIdPedido);
        } catch (_) {}
      }
    }

    setState(() => _cargandoPlatos = false);
  }

  @override
  void dispose() {
    _mesaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PedidoFormViewModel>();
    final isEdit = widget.pedido != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Pedido' : 'Nuevo Pedido'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _mesaController,
                    decoration: const InputDecoration(
                      labelText: 'Número de mesa',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese número de mesa' : null,
                  ),
                  const SizedBox(height: 12),

                  // Autocomplete de cliente por nombre
                  if (_cargandoClientes)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    )
                  else
                    Autocomplete<Cliente>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<Cliente>.empty();
                        }
                        final query = textEditingValue.text.toLowerCase();
                        return _clientes.where(
                          (c) => c.nombre.toLowerCase().contains(query),
                        );
                      },
                      displayStringForOption: (Cliente option) => option.nombre,
                      fieldViewBuilder: (context, textEditingController,
                          focusNode, onFieldSubmitted) {
                        if (_clienteSeleccionado != null &&
                            textEditingController.text.isEmpty) {
                          textEditingController.text =
                              _clienteSeleccionado!.nombre;
                        }

                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del cliente',
                            border: OutlineInputBorder(),
                          ),
                          validator: (_) {
                            if (_clienteSeleccionado == null) {
                              return 'Seleccione un cliente';
                            }
                            return null;
                          },
                        );
                      },
                      onSelected: (Cliente selection) {
                        setState(() {
                          _clienteSeleccionado = selection;
                        });
                      },
                    ),

                  const SizedBox(height: 12),

                  // Autocomplete de plato por nombre
                  if (_cargandoPlatos)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    )
                  else
                    Autocomplete<Plato>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<Plato>.empty();
                        }
                        final query = textEditingValue.text.toLowerCase();
                        return _platos.where(
                          (p) => p.nombre.toLowerCase().contains(query),
                        );
                      },
                      displayStringForOption: (Plato option) => option.nombre,
                      fieldViewBuilder: (context, textEditingController,
                          focusNode, onFieldSubmitted) {
                        if (_platoSeleccionado != null &&
                            textEditingController.text.isEmpty) {
                          textEditingController.text =
                              _platoSeleccionado!.nombre;
                        }

                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del plato',
                            border: OutlineInputBorder(),
                          ),
                          validator: (_) {
                            if (_platoSeleccionado == null) {
                              return 'Seleccione un plato';
                            }
                            return null;
                          },
                        );
                      },
                      onSelected: (Plato selection) {
                        setState(() {
                          _platoSeleccionado = selection;
                        });
                      },
                    ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: vm.saving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final pedido = Pedido(
                                id: widget.pedido?.id,
                                numeroMesa: int.parse(_mesaController.text),
                                clienteId: _clienteSeleccionado?.id ??
                                    widget.pedido?.clienteId ??
                                    '',
                                platoId: _platoSeleccionado?.id ??
                                    widget.pedido?.platoId ??
                                    '',
                              );

                              final Result<Pedido> res =
                                  await vm.save(pedido);

                              if (!context.mounted) return;

                              if (res.isSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pedido guardado correctamente',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(16),
                                  ),
                                );
                                Navigator.pop(context, true);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      res.error ??
                                          'Error al guardar pedido',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: const EdgeInsets.all(16),
                                  ),
                                );
                              }
                            },
                      icon: vm.saving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(isEdit ? 'Actualizar' : 'Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
