import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 2)
class Product extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double price;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String? originalPrice;

  @HiveField(5)
  final bool isOffer;

  Product({
    required this.name,
    required this.price,
    required this.image,
    required this.category,
    this.originalPrice,
    this.isOffer = false,
  });
}
