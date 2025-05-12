import 'package:flutter_test/flutter_test.dart';
import 'package:service_booking/data/model/service_model_dto.dart';
import 'package:service_booking/domain/entities/service_entity.dart';

void main() {
  const tServiceModelDto = ServiceModelDto(
    id: '1',
    name: 'Test Service',
    category: 'Cleaning',
    price: 50.0,
    imageUrl: 'https://example.com/image.jpg',
    availability: true,
    duration: 60,
    rating: 4.5,
  );

  const tServiceModelJson = {
    'id': '1',
    'name': 'Test Service',
    'category': 'Cleaning',
    'price': 50.0,
    'imageUrl': 'https://example.com/image.jpg',
    'availability': true,
    'duration': 60,
    'rating': 4.5,
  };

  group('ServiceModelDto', () {
    test('should be a subclass of ServiceEntity', () async {
      // Assert that ServiceModelDto inherits from ServiceEntity
      expect(tServiceModelDto, isA<ServiceEntity>());
    });

    group('fromJson', () {
      test('should return a valid ServiceModelDto from JSON', () async {
        // Arrange
        final Map<String, dynamic> jsonMap = tServiceModelJson;

        // Act
        final result = ServiceModelDto.fromJson(jsonMap);

        // Assert
        expect(result, tServiceModelDto);
      });

      test('should handle different data types correctly from JSON', () async {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          'id': '2',
          'name': 'Another Service',
          'category': 'Repair',
          'price': 100,
          'imageUrl': 'https://example.com/another.png',
          'availability': false,
          'duration': 120,
          'rating': 3,
        };
        const expectedServiceModel = ServiceModelDto(
          id: '2',
          name: 'Another Service',
          category: 'Repair',
          price: 100.0,
          imageUrl: 'https://example.com/another.png',
          availability: false,
          duration: 120,
          rating: 3.0,
        );

        // Act
        final result = ServiceModelDto.fromJson(jsonMap);

        // Assert
        expect(result, expectedServiceModel);
      });

      test('should handle missing optional fields (if any)', () async {});

      test(
        'should throw an exception if required fields are missing or null',
        () async {
          // Arrange - Missing 'name'
          final Map<String, dynamic> jsonMap = {
            'id': '4',
            // 'name': 'Missing name',
            'category': 'Testing',
            'price': 150.0,
            'imageUrl': 'https://example.com/test.jpg',
            'availability': true,
            'duration': 30,
            'rating': 5.0,
          };

          expect(
            () => ServiceModelDto.fromJson(jsonMap),
            throwsA(isA<TypeError>()),
          );

          final Map<String, dynamic> jsonMapNullPrice = {
            'id': '5',
            'name': 'Null Price',
            'category': 'Test',
            'price': null,
            'imageUrl': 'https://example.com/test.jpg',
            'availability': true,
            'duration': 30,
            'rating': 5.0,
          };

          // Act and Assert
          expect(
            () => ServiceModelDto.fromJson(jsonMapNullPrice),
            throwsA(isA<TypeError>()),
          );
        },
      );
    });

    group('toJson', () {
      test('should return a JSON map containing the correct data', () async {
        // Arrange - using the initial tServiceModelDto
        const serviceModel = tServiceModelDto;

        // Act
        final result = serviceModel.toJson();

        // Assert
        expect(result, tServiceModelJson);
      });

      test('should handle different values correctly in toJson', () async {
        // Arrange
        const serviceModel = ServiceModelDto(
          id: '6',
          name: 'Another Json Test',
          category: 'Inspection',
          price: 123.45,
          imageUrl: 'http://test.com/img.png',
          availability: false,
          duration: 45,
          rating: 2.0,
        );
        final expectedJson = {
          'id': '6',
          'name': 'Another Json Test',
          'category': 'Inspection',
          'price': 123.45,
          'imageUrl': 'http://test.com/img.png',
          'availability': false,
          'duration': 45,
          'rating': 2.0,
        };

        // Act
        final result = serviceModel.toJson();

        // Assert
        expect(result, expectedJson);
      });
    });

    group('fromEntity', () {
      test('should convert a ServiceEntity to a ServiceModelDto', () async {
        // Arrange
        const tServiceEntity = ServiceEntity(
          id: '7',
          name: 'Entity Service',
          category: 'Cleaning',
          price: 60.0,
          imageUrl: 'https://example.com/entity.jpg',
          availability: true,
          duration: 75,
          rating: 4.0,
        );

        // Act
        final result = ServiceModelDto.fromEntity(tServiceEntity);

        // Assert
        expect(result, isA<ServiceModelDto>());
        expect(result.id, tServiceEntity.id);
        expect(result.name, tServiceEntity.name);
        expect(result.category, tServiceEntity.category);
        expect(result.price, tServiceEntity.price);
        expect(result.imageUrl, tServiceEntity.imageUrl);
        expect(result.availability, tServiceEntity.availability);
        expect(result.duration, tServiceEntity.duration);
        expect(result.rating, tServiceEntity.rating);
      });
    });
  });
}
