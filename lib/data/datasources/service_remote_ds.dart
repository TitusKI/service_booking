import 'package:dio/dio.dart';
import 'package:service_booking/core/constants/app_constants.dart';
import 'package:service_booking/data/model/service_model_dto.dart';
import '../../core/errors/exceptions.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModelDto>> getAllServices();
  Future<ServiceModelDto> getServiceDetail(String id);
  Future<ServiceModelDto> addService(ServiceModelDto service);
  Future<ServiceModelDto> updateService(ServiceModelDto service);
  Future<void> deleteService(String id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio dio;
  final String baseUrl =
      'https://${AppConstants.API_KEY}.mockapi.io/api/v1/service';

  ServiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ServiceModelDto>> getAllServices() async {
    try {
      print('Fetching all services from $baseUrl');
      final response = await dio.get(baseUrl);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        print('Response data: $jsonList');
        final List<ServiceModelDto> services =
            jsonList.map((json) => ServiceModelDto.fromJson(json)).toList();
        print('Parsed services: $services');
        return jsonList.map((json) => ServiceModelDto.fromJson(json)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      print('Error fetching services: ${e.message}');

      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ServiceModelDto> getServiceDetail(String id) async {
    try {
      final response = await dio.get('$baseUrl/$id');
      if (response.statusCode == 200) {
        return ServiceModelDto.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ServerException();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ServerException();
      }
      if (e.response?.statusCode == 404) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ServiceModelDto> addService(ServiceModelDto service) async {
    try {
      final response = await dio.post(
        baseUrl,
        data: service.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 201) {
        return ServiceModelDto.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ServiceModelDto> updateService(ServiceModelDto service) async {
    try {
      final response = await dio.patch(
        '$baseUrl/${service.id}',
        data: service.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      if (response.statusCode == 200) {
        return ServiceModelDto.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ServerException();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ServerException();
      }
      if (e.response?.statusCode == 404) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteService(String id) async {
    try {
      final response = await dio.delete('$baseUrl/$id');
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          throw ServerException();
        }
        throw ServerException();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw ServerException();
      }
      if (e.response?.statusCode == 404) {
        throw ServerException();
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}
