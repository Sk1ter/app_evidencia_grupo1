import 'package:flutter/material.dart';

import 'home_content.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: HomeContent(), // contenido principal del inicio
    );
  }
}
