import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetServiceDetail extends GetxController {
  final ServiceRepository repository;

  GetServiceDetail({required this.repository});

  Future<Either<Failure, ServiceEntity>> call(String id) async {
    return await repository.getServiceDetail(id);
  }
}
