import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common/result.dart';
import '../../core/di/service_locator.dart';
import '../../domain/model/plato.dart';
import '../../domain/usecase/plato_usecases.dart';
import '../viewmodel/plato_form_viewmodel.dart';

class PlatoFormScreen extends StatelessWidget {
  final Plato? plato;

  const PlatoFormScreen({super.key, this.plato});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlatoFormViewModel(
        createPlato: getIt<CreatePlatoUseCase>(),
        updatePlato: getIt<UpdatePlatoUseCase>(),
      ),
      child: _PlatoFormBody(plato: plato),
    );
  }
}

class _PlatoFormBody extends StatefulWidget {
  final Plato? plato;

  const _PlatoFormBody({required this.plato});

  @override
  State<_PlatoFormBody> createState() => _PlatoFormBodyState();
}

class _PlatoFormBodyState extends State<_PlatoFormBody> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    final p = widget.plato;
    _nombreController = TextEditingController(text: p?.nombre ?? '');
    _descripcionController = TextEditingController(text: p?.descripcion ?? '');
    _precioController =
        TextEditingController(text: p?.precio.toString() ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlatoFormViewModel>();
    final isEdit = widget.plato != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar Plato' : 'Nuevo Plato'),
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
                    controller: _descripcionController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _precioController,
                    decoration: const InputDecoration(
                      labelText: 'Precio',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Ingrese precio' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: vm.saving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final precio =
                                  double.tryParse(_precioController.text) ?? 0;

                              final plato = Plato(
                                id: widget.plato?.id,
                                nombre: _nombreController.text.trim(),
                                descripcion:
                                    _descripcionController.text.trim(),
                                precio: precio,
                              );

                              final Result<Plato> res = await vm.save(plato);

                              if (!context.mounted) return;

                              if (res.isSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Plato guardado correctamente'),
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
                                          'Error al guardar plato',
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
