import 'package:get_storage/get_storage.dart';
import 'package:service_booking/data/model/service_model_dto.dart';
import 'dart:convert';
import '../../core/errors/exceptions.dart';

abstract class ServiceLocalDataSource {
  Future<List<ServiceModelDto>> getLastServices();
  Future<void> cacheServices(List<ServiceModelDto> services);
  Future<void> clearCachedServices();
}

class ServiceLocalDataSourceImpl implements ServiceLocalDataSource {
  final GetStorage box;
  final String _servicesKey = 'cached_services';

  ServiceLocalDataSourceImpl({required this.box});

  @override
  Future<List<ServiceModelDto>> getLastServices() async {
    final jsonString = box.read(_servicesKey);
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return Future.value(
          jsonList.map((json) => ServiceModelDto.fromJson(json)).toList(),
        );
      } catch (e) {
        throw CacheException();
      }
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheServices(List<ServiceModelDto> services) async {
    try {
      final jsonString = json.encode(
        services.map((service) => service.toJson()).toList(),
      );
      await box.write(_servicesKey, jsonString);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCachedServices() async {
    try {
      await box.remove(_servicesKey);
    } catch (e) {
      throw CacheException();
    }
  }
}
