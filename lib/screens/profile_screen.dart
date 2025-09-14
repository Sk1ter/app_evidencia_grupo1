import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();

  final _usernameController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _birthDate;

  final _loginEmailOrPhoneController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  bool _isLogin = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _loginEmailOrPhoneController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final username = _usernameController.text.trim();
    final emailOrPhone = _emailOrPhoneController.text.trim().toLowerCase();
    final password = _passwordController.text;
    final birthDate = _birthDate;

    if (username.length < 3) {
      _showMessage('El nombre de usuario debe tener al menos 3 caracteres');
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^\d{9}$');

    if (!emailRegex.hasMatch(emailOrPhone) &&
        !phoneRegex.hasMatch(emailOrPhone)) {
      _showMessage('Ingresa un correo válido o un celular de 9 dígitos');
      return;
    }

    if (password.length < 6) {
      _showMessage('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (birthDate == null) {
      _showMessage('Selecciona una fecha de nacimiento');
      return;
    }

    final now = DateTime.now();
    final age =
        now.year -
        birthDate.year -
        ((now.month < birthDate.month ||
                (now.month == birthDate.month && now.day < birthDate.day))
            ? 1
            : 0);

    if (age < 13) {
      _showMessage('Debes tener al menos 13 años para registrarte');
      return;
    }

    final newUser = User(
      username: username,
      emailOrPhone: emailOrPhone,
      password: password,
      birthDate: birthDate,
    );

    final success = authService.register(newUser);
    if (success) {
      _showMessage('Registro exitoso');
      setState(() => _isLogin = true);
    } else {
      _showMessage('Ya existe un usuario con ese nombre, correo o celular');
    }
  }

  void _login() {
    final emailOrPhone = _loginEmailOrPhoneController.text.trim().toLowerCase();
    final password = _loginPasswordController.text;

    if (emailOrPhone.isEmpty || password.isEmpty) {
      _showMessage('Completa ambos campos');
      return;
    }

    final success = authService.login(emailOrPhone, password);
    if (success) {
      _showMessage('Inicio de sesión exitoso');
    } else {
      _showMessage('Credenciales inválidas o usuario no registrado');
    }
  }

  void _logout() {
    authService.logout();
    _showMessage('Sesión cerrada');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (result != null) {
      setState(() => _birthDate = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
      valueListenable: authService.currentUserNotifier,
      builder: (context, user, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: user != null ? _buildUserInfo(user) : _buildAuthForm(),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenido, ${user.username}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text('Correo/Teléfono: ${user.emailOrPhone}'),
        Text('Nacimiento: ${DateFormat('dd/MM/yyyy').format(user.birthDate)}'),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          child: const Text('Cerrar sesión'),
        ),
      ],
    );
  }

  Widget _buildAuthForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => setState(() => _isLogin = true),
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: _isLogin ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = false),
                child: Text(
                  'Registrarse',
                  style: TextStyle(
                    color: !_isLogin ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _isLogin ? _buildLoginForm() : _buildRegisterForm(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        TextField(
          controller: _loginEmailOrPhoneController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Correo o celular',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _loginPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Contraseña',
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _login,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Iniciar sesión'),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nombre de usuario',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailOrPhoneController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Correo electrónico o celular',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Contraseña',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              _birthDate != null
                  ? 'Nacimiento: ${DateFormat('dd/MM/yyyy').format(_birthDate!)}'
                  : 'Fecha de nacimiento no seleccionada',
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _selectBirthDate(context),
              child: const Text('Seleccionar fecha'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _register,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Registrarse'),
        ),
      ],
    );
  }
}
