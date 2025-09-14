import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';
import 'cart_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal() {
    _loadBoxes();
    _loadSession();
  }

  late final Box<User> _usersBox;
  late final Box<String> _sessionBox;

  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// notificador de usuario actual
  final ValueNotifier<User?> currentUserNotifier = ValueNotifier<User?>(null);

  // registrar usuario
  bool register(User user) {
    final key = user.emailOrPhone.toLowerCase();

    final exists =
        _usersBox.containsKey(key) ||
        _usersBox.values.any((u) => u.username == user.username);

    if (exists) return false;

    _usersBox.put(key, user);
    return true;
  }

  // iniciar sesión
  bool login(String emailOrPhone, String password) {
    final key = emailOrPhone.toLowerCase().trim();
    final user = _usersBox.get(key);

    if (user == null) {
      print('❌ Usuario no encontrado para $key');
      return false;
    }

    if (user.password != password) {
      print('❌ Contraseña incorrecta');
      return false;
    }

    _currentUser = user;
    currentUserNotifier.value = user;

    _sessionBox.put('userEmailOrPhone', key);

    CartService().transferAnonymousCartToUser(user.username);
    CartService().updateCartKey();

    print('✅ Login exitoso como ${user.username}');
    return true;
  }

  void logout() {
    print('👤 Sesión cerrada: ${_currentUser?.username}');
    _currentUser = null;
    currentUserNotifier.value = null;

    _sessionBox.delete('userEmailOrPhone');
    CartService().updateCartKey();
  }

  void _loadBoxes() {
    _usersBox = Hive.box<User>('users');
    _sessionBox = Hive.box<String>('session');
  }

  void _loadSession() {
    final key = _sessionBox.get('userEmailOrPhone');
    if (key == null) return;

    final user = _usersBox.get(key);
    if (user != null) {
      _currentUser = user;
      currentUserNotifier.value = user;

      CartService().transferAnonymousCartToUser(user.username);
      CartService().updateCartKey();

      print('🔄 Sesión restaurada como ${user.username}');
    }
  }
}
