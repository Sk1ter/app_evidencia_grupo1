import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/cart_item.dart';
import 'auth_service.dart';

class CartService {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  static const String _boxName = 'carts';
  static const String _anonKey = '_anonymous';

  final ValueNotifier<String> cartKeyNotifier = ValueNotifier<String>(_anonKey);

  // acceso tipado fuerte
  Box<List<CartItem>> get _cartBox => Hive.box<List<CartItem>>(_boxName);

  /// devuelve la clave actual según sesión o anónimo
  String _getCartKey() {
    final user = AuthService().currentUser;
    return user?.username ?? _anonKey;
  }

  String get cartKey => cartKeyNotifier.value;

  void updateCartKey() {
    cartKeyNotifier.value = _getCartKey();
  }

  /// obtener el carrito actual
  List<CartItem> getCurrentCart() {
    return _cartBox.get(cartKey, defaultValue: <CartItem>[])!;
  }

  /// obtener un carrito específico por clave
  List<CartItem> getCartByKey(String key) {
    return _cartBox.get(key, defaultValue: <CartItem>[])!;
  }

  /// agregar ítem al carrito
  void addToCart(CartItem item) {
    final current = getCurrentCart();
    _cartBox.put(cartKey, [...current, item]);
  }

  /// eliminar ítem del carrito
  void removeFromCart(CartItem item) {
    final current = getCurrentCart();
    final updated = current
        .where(
          (e) =>
              e.name != item.name ||
              e.image != item.image ||
              e.price != item.price,
        )
        .toList();
    _cartBox.put(cartKey, updated);
  }

  /// vaciar carrito
  void clearCart() {
    _cartBox.put(cartKey, []);
  }

  /// transferir carrito anonimo al usuario logueado
  void transferAnonymousCartToUser(String username) {
    final anonCart = getCartByKey(_anonKey);
    if (anonCart.isEmpty) return;

    final userCart = getCartByKey(username);
    final merged = [...userCart, ...anonCart];

    _cartBox.put(username, merged);
    _cartBox.put(_anonKey, []);
  }
}
