import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/cart_item.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = CartService();
    final authService = AuthService();

    // usamos tipado fuerte para la caja
    final Box<List<CartItem>> cartBox = Hive.box<List<CartItem>>('carts');

    return ValueListenableBuilder<String>(
      valueListenable: cartService.cartKeyNotifier,
      builder: (context, cartKey, _) {
        return ValueListenableBuilder<Box<List<CartItem>>>(
          valueListenable: cartBox.listenable(keys: [cartKey]),
          builder: (context, box, _) {
            final cartItems = box.get(cartKey, defaultValue: <CartItem>[])!;

            if (cartItems.isEmpty) {
              return const Center(
                child: Text(
                  'Tu carrito está vacío',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final total = cartItems.fold(0.0, (sum, item) => sum + item.price);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        child: ListTile(
                          leading: Image.asset(
                            item.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.image_not_supported),
                          ),
                          title: Text(item.name),
                          subtitle: Text(
                            'S/. ${item.price.toStringAsFixed(2)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cartService.removeFromCart(item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: S/. ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (!authService.isLoggedIn) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Debes iniciar sesión para pagar',
                                ),
                              ),
                            );
                            return;
                          }

                          cartService.clearCart();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Pedido realizado con éxito'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Pagar'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
