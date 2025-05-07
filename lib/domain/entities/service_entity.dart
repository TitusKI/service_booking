import 'package:equatable/equatable.dart';

class ServiceEntity extends Equatable {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool availability;
  final int duration;
  final double rating;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.availability,
    required this.duration,
    required this.rating,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    price,
    imageUrl,
    availability,
    duration,
    rating,
  ];
}
