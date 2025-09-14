import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  final String? categoryName;

  const CatalogScreen({super.key, this.categoryName});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int _selectedIndex = 0;

  final Map<String, List<Product>> categoryProducts = {
    'Snacks': [
      Product(
        name: 'Snacks Salados',
        price: 3.50,
        image: 'assets/images/products/snacks.png',
        category: 'Snacks',
      ),
      Product(
        name: 'Galletas Rellenas',
        price: 2.50,
        image: 'assets/images/products/galletas.png',
        category: 'Snacks',
      ),
      Product(
        name: 'Chocolate Clásico',
        price: 4.00,
        image: 'assets/images/products/chocolate.png',
        category: 'Snacks',
      ),
    ],
    'Bebidas': [
      Product(
        name: 'Bebida Energética',
        price: 5.00,
        image: 'assets/images/products/bebida.png',
        category: 'Bebidas',
      ),
      Product(
        name: 'Agua Epura',
        price: 1.90,
        image: 'assets/images/products/agua_epura.png',
        category: 'Bebidas',
      ),
      Product(
        name: 'Inca Kola Sixpack',
        price: 12.00,
        image: 'assets/images/products/inca_kola.png',
        category: 'Bebidas',
      ),
    ],
    'Licores': [
      Product(
        name: 'Pilsen Twelve Pack 355ml',
        price: 49.90,
        image: 'assets/images/products/pilsen_pack.png',
        category: 'Licores',
      ),
    ],
    'Helados': [
      Product(
        name: 'Sin Para Lúcuma, Fresa y Maracuyá',
        price: 5.00,
        image: 'assets/images/products/sin_para_lucuma.png',
        category: 'Helados',
      ),
    ],
    'default': [
      Product(
        name: 'Producto Genérico',
        price: 9.99,
        image: 'assets/images/products/agua_epura.png',
        category: 'General',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final String selectedCategory = widget.categoryName ?? 'default';
    final List<Product> products =
        categoryProducts[selectedCategory] ?? categoryProducts['default']!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          widget.categoryName ?? 'Catálogo',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(product: products[index]);
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
