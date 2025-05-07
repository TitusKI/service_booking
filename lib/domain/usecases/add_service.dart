import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class AddService extends GetxController {
  final ServiceRepository repository;

  AddService({required this.repository});

  Future<Either<Failure, ServiceEntity>> call(ServiceEntity service) async {
    return await repository.addService(service);
  }
}
