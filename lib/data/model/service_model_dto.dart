import '../../domain/entities/service_entity.dart';

class ServiceModelDto extends ServiceEntity {
  const ServiceModelDto({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    required super.imageUrl,
    required super.availability,
    required super.duration,
    required super.rating,
  });

  factory ServiceModelDto.fromJson(Map<String, dynamic> json) {
    return ServiceModelDto(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      availability: json['availability'] as bool,
      duration: json['duration'] as int,
      rating: (json['rating'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'availability': availability,
      'duration': duration,
      'rating': rating,
    };
  }

  // for converting Entity to DTO
  factory ServiceModelDto.fromEntity(ServiceEntity entity) {
    return ServiceModelDto(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      price: entity.price,
      imageUrl: entity.imageUrl,
      availability: entity.availability,
      duration: entity.duration,
      rating: entity.rating,
    );
  }
}
