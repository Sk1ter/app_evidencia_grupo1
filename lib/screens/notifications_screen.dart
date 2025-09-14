import 'package:flutter/material.dart';

import '../services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> notifications =
        NotificationService().notifications; // usa servicio centralizado

    if (notifications.isEmpty) {
      return const Center(
        child: Text(
          'No tienes notificaciones aún',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.notifications, color: Colors.red),
          title: Text(
            notifications[index],
            style: const TextStyle(fontSize: 14),
          ),
        );
      },
    );
  }
}
