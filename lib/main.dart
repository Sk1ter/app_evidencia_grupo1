import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/cart_item.dart';
import 'models/user.dart';
import 'screens/main_screen.dart';
import 'services/auth_service.dart'; // necesario para restaurar la sesión

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inicializar hive con el soporte para flutter
  await Hive.initFlutter();

  // registrar los adapters necesarios
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartItemAdapter());

  // abrir las cajas necesarias con TIPADO FUERTE
  await Hive.openBox<User>('users');
  await Hive.openBox<String>('session');
  await Hive.openBox<List<CartItem>>('carts'); // ✅ Tipado fuerte corregido

  // para restaurar la sesión antes de iniciar la UI
  AuthService(); // esto también actualiza el CartService().cartKeyNotifier

  // iniciar la app
  runApp(const OxxoApp());
}

class OxxoApp extends StatelessWidget {
  const OxxoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OXXO',
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'Arial'),
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}
