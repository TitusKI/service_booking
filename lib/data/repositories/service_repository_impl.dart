import 'package:dartz/dartz.dart';
import 'package:service_booking/data/datasources/service_local_ds.dart';
import 'package:service_booking/data/datasources/service_remote_ds.dart';
import 'package:service_booking/data/model/service_model_dto.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> getAllServices() async {
    try {
      final remoteServices = await remoteDataSource.getAllServices();
      localDataSource.cacheServices(remoteServices);
      print('Services are ${remoteServices.length}');
      print('Services are $remoteServices');

      return Right(remoteServices);
    } on ServerException {
      try {
        final localServices = await localDataSource.getLastServices();
        return Right(localServices);
      } on CacheException {
        return Left(ServerFailure(message: 'check_internet_connection'));
      }
    } on CacheException {
      return Left(CacheFailure(message: 'check_internet_connection'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'An unexpected error occurred during fetch.'),
      );
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> getServiceDetail(String id) async {
    try {
      final remoteService = await remoteDataSource.getServiceDetail(id);
      return Right(remoteService);
    } on ServerException {
      return Left(ServerFailure(message: 'check_internet_connection'));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        ServerFailure(
          message: 'An unexpected error occurred while getting detail',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> addService(
    ServiceEntity service,
  ) async {
    try {
      final serviceDto = ServiceModelDto.fromEntity(service);
      final newService = await remoteDataSource.addService(serviceDto);
      return Right(newService);
    } on ServerException {
      return Left(ServerFailure(message: 'check_internet_connection'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'An unexpected error occurred while adding'),
      );
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> updateService(
    ServiceEntity service,
  ) async {
    try {
      final serviceDto = ServiceModelDto.fromEntity(service);
      final updatedService = await remoteDataSource.updateService(serviceDto);
      return Right(updatedService);
    } on ServerException {
      return Left(ServerFailure(message: 'check_internet_connection'));
    } on CacheException {
      return Left(CacheFailure());
    } catch (e) {
      return Left(
        ServerFailure(message: 'An unexpected error occurred while updating'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> deleteService(String id) async {
    try {
      await remoteDataSource.deleteService(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure(message: 'check_internet_connection'));
    } catch (e) {
      return Left(
        ServerFailure(message: 'An unexpected error occurred while deleting'),
      );
    }
  }
}
