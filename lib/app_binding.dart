import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service_booking/config/services/storage_service.dart';
import 'package:service_booking/data/datasources/service_local_ds.dart';
import '../data/repositories/service_repository_impl.dart';
import '../domain/repositories/service_repository.dart';
import '../domain/usecases/add_service.dart';
import '../domain/usecases/delete_service.dart';
import '../domain/usecases/get_all_services.dart';
import '../domain/usecases/get_service_detail.dart';
import '../domain/usecases/update_service.dart';
import '../presentation/controllers/language_controller.dart';
import '../presentation/controllers/services_controller.dart';
import '../presentation/controllers/theme_controller.dart';
import 'data/datasources/service_remote_ds.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // lOCAL Data Sources

    // Core Controllers
    Get.put<ThemeController>(ThemeController());
    Get.put<LanguageController>(LanguageController());

    // External Dependencies
    Get.lazyPut<Dio>(() => Dio());
    Get.lazyPut<GetStorage>(() => GetStorage());
    Get.lazyPut<StorageService>(() => StorageService());

    Get.lazyPut<ServiceRemoteDataSource>(
      () => ServiceRemoteDataSourceImpl(dio: Get.find()),
    );
    Get.lazyPut<ServiceLocalDataSource>(
      () => ServiceLocalDataSourceImpl(box: Get.find()),
    );

    // Repositories
    Get.lazyPut<ServiceRepository>(
      () => ServiceRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
    );

    // Use Cases
    Get.lazyPut<GetAllServices>(() => GetAllServices(repository: Get.find()));
    Get.lazyPut<GetServiceDetail>(
      () => GetServiceDetail(repository: Get.find()),
    );
    Get.lazyPut<AddService>(() => AddService(repository: Get.find()));
    Get.lazyPut<UpdateService>(() => UpdateService(repository: Get.find()));
    Get.lazyPut<DeleteService>(() => DeleteService(repository: Get.find()));

    // Presentation Controllers
    Get.put<ServicesController>(
      ServicesController(
        getAllServices: Get.find(),
        getServiceDetail: Get.find(),
        addService: Get.find(),
        updateService: Get.find(),
        deleteService: Get.find(),
      ),
    );
  }
}
