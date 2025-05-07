import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetAllServices extends GetxController {
  final ServiceRepository repository;

  GetAllServices({required this.repository});

  Future<Either<Failure, List<ServiceEntity>>> call() async {
    return await repository.getAllServices();
  }
}
