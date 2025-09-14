import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String image;

  @HiveField(2)
  final double price;

  CartItem({required this.name, required this.image, required this.price});

  factory CartItem.fromProduct(dynamic product) {
    return CartItem(
      name: product.name,
      image: product.image,
      price: product.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'image': image, 'price': price};
  }
}
