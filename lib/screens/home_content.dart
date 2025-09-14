import 'package:flutter/material.dart';

import '../models/category.dart';
import '../widgets/category_icon.dart';
import '../widgets/offer_card.dart';
import 'catalog_screen.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Category> categories = [
      Category(name: 'Snacks', icon: '🥨'),
      Category(name: 'Bebidas', icon: '🥤'),
      Category(name: 'Licores', icon: '🍷'),
      Category(name: 'Helados', icon: '🍦'),
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      OfferCard(
                        price: 'S/. 1.90',
                        description: 'Agua Anual Epura Botella',
                        image: 'assets/images/products/agua_epura.png',
                      ),
                      OfferCard(
                        price: 'S/. 12.00',
                        description: 'Sixpack Inca Kola Pet 1/2 Caja',
                        image: 'assets/images/products/inca_kola.png',
                      ),
                      OfferCard(
                        price: 'S/. 555.00',
                        description: 'Monster Energy',
                        image: 'assets/images/products/monster_energy.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Categoría',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: categories.map((category) {
                    return CategoryIcon(
                      name: category.name,
                      icon: category.icon,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CatalogScreen(categoryName: category.name),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Catálogo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      OfferCard(
                        price: 'S/. 1.90',
                        description: 'Agua Anual Epura Botella',
                        image: 'assets/images/products/agua_epura.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
