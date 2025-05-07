import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class UpdateService extends GetxController {
  final ServiceRepository repository;

  UpdateService({required this.repository});

  Future<Either<Failure, ServiceEntity>> call(ServiceEntity service) async {
    return await repository.updateService(service);
  }
}
