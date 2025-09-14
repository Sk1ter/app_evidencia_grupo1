class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<String> _notifications = [
    '¡Bienvenido a OXXO App! 🛒',
    'Oferta especial en Licores hasta el viernes 🍷',
    'Tu carrito se ha guardado correctamente.',
    'Nueva promoción en Snacks 🍪',
    'Tu pedido está en preparación. 🍔',
  ];

  List<String> get notifications => List.unmodifiable(_notifications);

  void add(String message) {
    if (message.trim().isEmpty) return;
    _notifications.insert(0, message);
  }

  void clear() {
    _notifications.clear();
  }
}
