import 'package:dartz/dartz.dart';
// DARTZ for functional programming
import '../../core/errors/failures.dart';
import '../entities/service_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> getAllServices();
  Future<Either<Failure, ServiceEntity>> getServiceDetail(String id);
  Future<Either<Failure, ServiceEntity>> addService(ServiceEntity service);
  Future<Either<Failure, ServiceEntity>> updateService(ServiceEntity service);
  Future<Either<Failure, void>> deleteService(String id);
}
