import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          _buildNotificationItem(context, 'New Recipe Available!', 'Check out the new healthy salad recipe.', '2 hours ago', Icons.restaurant),
          _buildNotificationItem(context, 'Meal Plan Reminder', 'Don\'t forget to cook Paneer Tikka tonight!', '5 hours ago', Icons.alarm),
          _buildNotificationItem(context, 'Subscription Renewed', 'Your CookMate Premium has been renewed.', '1 day ago', Icons.workspace_premium),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, String title, String body, String time, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(body),
      trailing: Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      onTap: () {},
    );
  }
}
