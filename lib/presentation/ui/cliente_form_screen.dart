import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common/result.dart';
import '../../core/di/service_locator.dart';
import '../../domain/model/cliente.dart';
import '../../domain/usecase/cliente_usecases.dart';
import '../viewmodel/cliente_form_viewmodel.dart';

class ClienteFormScreen extends StatelessWidget {
  final Cliente? cliente;

  const ClienteFormScreen({super.key, this.cliente});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClienteFormViewModel(
        createCliente: getIt<CreateClienteUseCase>(),
        updateCliente: getIt<UpdateClienteUseCase>(),
      ),
      child: _ClienteFormBody(cliente: cliente),
    );
  }
}

class _ClienteFormBody extends StatefulWidget {
  final Cliente? cliente;

  const _ClienteFormBody({required this.cliente});

  @override
  State<_ClienteFormBody> createState() => _ClienteFormBodyState();
}

class _ClienteFormBodyState extends State<_ClienteFormBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _telefonoController;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    _nombreController = TextEditingController(text: c?.nombre ?? '');
    _telefonoController = TextEditingController(text: c?.telefono ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClienteFormViewModel>();
    final isEdit = widget.cliente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Cliente' : 'Nuevo Cliente'),
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
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese nombre' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese teléfono' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: vm.saving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final cliente = Cliente(
                                id: widget.cliente?.id,
                                nombre: _nombreController.text.trim(),
                                telefono: _telefonoController.text.trim(),
                              );

                              final Result<Cliente> res =
                                  await vm.save(cliente);

                              if (!context.mounted) return;

                              if (res.isSuccess) {
                                // ✅ toast de éxito (texto definido en Flutter)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Cliente guardado correctamente'),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(16),
                                  ),
                                );
                                Navigator.pop(context, true);
                              } else {
                                // ❌ mensaje del backend (res.error)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      res.error ??
                                          'Error al guardar cliente',
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
