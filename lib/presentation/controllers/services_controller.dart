import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/usecases/add_service.dart';
import '../../domain/usecases/delete_service.dart';
import '../../domain/usecases/get_all_services.dart';
import '../../domain/usecases/get_service_detail.dart';
import '../../domain/usecases/update_service.dart';
import '../screens/services/service_detail_screen.dart';

class ServicesController extends GetxController {
  final GetAllServices _getAllServices;
  final GetServiceDetail _getServiceDetail;
  final AddService _addService;
  final UpdateService _updateService;
  final DeleteService _deleteService;

  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  RxList<ServiceEntity> services = <ServiceEntity>[].obs;
  Rx<ServiceEntity?> currentServiceDetail = Rx<ServiceEntity?>(null);

  RxString searchQuery = ''.obs;
  RxString selectedCategory = 'All'.obs;
  RxDouble minPriceFilter = 0.0.obs;
  RxDouble maxPriceFilter = 1000.0.obs;
  RxBool onlyAvailableFilter = false.obs;

  final RxList<String> categories =
      <String>[
        'All',
        'Cleaning',
        'Repair',
        'Gardening',
        'Beauty',
        'Education',
        'Automotive',
        'Other',
      ].obs;

  ServicesController({
    required GetAllServices getAllServices,
    required GetServiceDetail getServiceDetail,
    required AddService addService,
    required UpdateService updateService,
    required DeleteService deleteService,
  }) : _getAllServices = getAllServices,
       _getServiceDetail = getServiceDetail,
       _addService = addService,
       _updateService = updateService,
       _deleteService = deleteService;

  void applyFilters({
    required double minPrice,
    required double maxPrice,
    required bool onlyAvailable,
  }) {
    minPriceFilter.value = minPrice;
    maxPriceFilter.value = maxPrice;
    onlyAvailableFilter.value = onlyAvailable;
    update();
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'All';
    minPriceFilter.value = 0;
    maxPriceFilter.value = 1000;
    onlyAvailableFilter.value = false;
    update();
  }

  List<ServiceEntity> get filteredServices {
    return services.where((service) {
      final matchesSearch =
          service.name.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          ) ||
          service.category.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          );

      final matchesCategory =
          selectedCategory.value == 'All' ||
          service.category == selectedCategory.value;

      final matchesPrice =
          service.price >= minPriceFilter.value &&
          service.price <= maxPriceFilter.value;

      final matchesAvailability =
          !onlyAvailableFilter.value || service.availability;

      return matchesSearch &&
          matchesCategory &&
          matchesPrice &&
          matchesAvailability;
    }).toList();
  }

  Future<void> fetchServices() async {
    isLoading.value = true;
    errorMessage.value = '';

    final failureOrServices = await _getAllServices();

    failureOrServices.fold(
      (failure) {
        errorMessage.value = _mapFailureToMessage(failure);
        isLoading.value = false;

        Get.snackbar(
          'error'.tr,
          errorMessage.value.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (serviceList) {
        services.assignAll(serviceList);
        isLoading.value = false;
      },
    );
  }

  Future<void> performAddService(ServiceEntity service) async {
    errorMessage.value = '';

    final failureOrService = await _addService(service);

    failureOrService.fold(
      (failure) {
        errorMessage.value = _mapFailureToMessage(failure);

        Get.snackbar(
          'error'.tr,
          errorMessage.value.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (newService) {
        Get.back();
        Get.snackbar(
          'success'.tr,
          'service_added'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
        );
        fetchServices();
      },
    );
  }

  Future<void> performUpdateService(ServiceEntity service) async {
    errorMessage.value = '';

    final failureOrService = await _updateService(service);

    failureOrService.fold(
      (failure) {
        errorMessage.value = _mapFailureToMessage(failure);
        Get.snackbar(
          'error'.tr,
          errorMessage.value.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (updatedService) {
        final index = services.indexWhere((s) => s.id == updatedService.id);
        if (index != -1) {
          services[index] = updatedService;
          services.refresh();
        }

        if (currentServiceDetail.value?.id == updatedService.id) {
          currentServiceDetail.value = updatedService;
        }

        Get.back();
        Get.snackbar(
          'success'.tr,
          'service_updated'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
        );
      },
    );
  }

  Future<void> performDeleteService(String id) async {
    errorMessage.value = '';

    final failureOrVoid = await _deleteService(id);

    failureOrVoid.fold(
      (failure) {
        errorMessage.value = _mapFailureToMessage(failure);

        Get.snackbar(
          'error'.tr,
          errorMessage.value.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (_) {
        services.removeWhere((service) => service.id == id);
        services.refresh();
        Get.snackbar(
          'success'.tr,
          'service_deleted'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
        );
      },
    );
  }

  Future<void> fetchServiceDetail(
    String id, {
    bool isBackgroundFetch = false,
  }) async {
    if (!isBackgroundFetch) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    final failureOrServiceDetail = await _getServiceDetail(id);

    failureOrServiceDetail.fold(
      (failure) {
        errorMessage.value = _mapFailureToMessage(failure);
        if (!isBackgroundFetch) {
          isLoading.value = false;
          currentServiceDetail.value = null;
        }

        if (!isBackgroundFetch || failure is NetworkFailure) {
          Get.snackbar(
            animationDuration: const Duration(milliseconds: 500),
            'error'.tr,
            errorMessage.value.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
        }
      },
      (serviceDetail) {
        if (!isBackgroundFetch) {
          isLoading.value = false;
        }

        currentServiceDetail.value = serviceDetail;
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return (failure as ServerFailure).message;
      case CacheFailure:
        return (failure as CacheFailure).message;
      case NetworkFailure:
        return (failure as NetworkFailure).message;
      default:
        return 'unexpected_error'.tr;
    }
  }
}
