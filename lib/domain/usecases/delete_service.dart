import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../repositories/service_repository.dart';

class DeleteService extends GetxController {
  final ServiceRepository repository;

  DeleteService({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return await repository.deleteService(id);
  }
}
