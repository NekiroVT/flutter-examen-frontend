import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../data/remote/plato_remote_datasource.dart';
import '../../data/remote/cliente_remote_datasource.dart';
import '../../data/remote/pedido_remote_datasource.dart';
import '../../data/repository/plato_repository_impl.dart';
import '../../data/repository/cliente_repository_impl.dart';
import '../../data/repository/pedido_repository_impl.dart';
import '../../domain/repository/plato_repository.dart';
import '../../domain/repository/cliente_repository.dart';
import '../../domain/repository/pedido_repository.dart';
import '../../domain/usecase/plato_usecases.dart';
import '../../domain/usecase/cliente_usecases.dart';
import '../../domain/usecase/pedido_usecases.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // http client
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // datasources
  getIt.registerLazySingleton<PlatoRemoteDataSource>(
      () => PlatoRemoteDataSourceImpl(getIt<http.Client>()));
  getIt.registerLazySingleton<ClienteRemoteDataSource>(
      () => ClienteRemoteDataSourceImpl(getIt<http.Client>()));
  getIt.registerLazySingleton<PedidoRemoteDataSource>(
      () => PedidoRemoteDataSourceImpl(getIt<http.Client>()));

  // repositories
  getIt.registerLazySingleton<PlatoRepository>(
      () => PlatoRepositoryImpl(getIt<PlatoRemoteDataSource>()));
  getIt.registerLazySingleton<ClienteRepository>(
      () => ClienteRepositoryImpl(getIt<ClienteRemoteDataSource>()));
  getIt.registerLazySingleton<PedidoRepository>(
      () => PedidoRepositoryImpl(getIt<PedidoRemoteDataSource>()));

  // usecases PLATO
  getIt.registerLazySingleton<GetPlatosUseCase>(
      () => GetPlatosUseCase(getIt<PlatoRepository>()));
  getIt.registerLazySingleton<GetPlatoByIdUseCase>(
      () => GetPlatoByIdUseCase(getIt<PlatoRepository>()));
  getIt.registerLazySingleton<CreatePlatoUseCase>(
      () => CreatePlatoUseCase(getIt<PlatoRepository>()));
  getIt.registerLazySingleton<UpdatePlatoUseCase>(
      () => UpdatePlatoUseCase(getIt<PlatoRepository>()));
  getIt.registerLazySingleton<DeletePlatoUseCase>(
      () => DeletePlatoUseCase(getIt<PlatoRepository>()));

  // usecases CLIENTE
  getIt.registerLazySingleton<GetClientesUseCase>(
      () => GetClientesUseCase(getIt<ClienteRepository>()));
  getIt.registerLazySingleton<GetClienteByIdUseCase>(
      () => GetClienteByIdUseCase(getIt<ClienteRepository>()));
  getIt.registerLazySingleton<CreateClienteUseCase>(
      () => CreateClienteUseCase(getIt<ClienteRepository>()));
  getIt.registerLazySingleton<UpdateClienteUseCase>(
      () => UpdateClienteUseCase(getIt<ClienteRepository>()));
  getIt.registerLazySingleton<DeleteClienteUseCase>(
      () => DeleteClienteUseCase(getIt<ClienteRepository>()));

  // usecases PEDIDO
  getIt.registerLazySingleton<GetPedidosUseCase>(
      () => GetPedidosUseCase(getIt<PedidoRepository>()));
  getIt.registerLazySingleton<GetPedidoByIdUseCase>(
      () => GetPedidoByIdUseCase(getIt<PedidoRepository>()));
  getIt.registerLazySingleton<CreatePedidoUseCase>(
      () => CreatePedidoUseCase(getIt<PedidoRepository>()));
  getIt.registerLazySingleton<UpdatePedidoUseCase>(
      () => UpdatePedidoUseCase(getIt<PedidoRepository>()));
  getIt.registerLazySingleton<DeletePedidoUseCase>(
      () => DeletePedidoUseCase(getIt<PedidoRepository>()));
}
