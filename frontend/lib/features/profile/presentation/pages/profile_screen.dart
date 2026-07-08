import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (user != null) ...[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : const NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=800&q=80'),
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'CookMate User',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  user.email ?? '',
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ] else ...[
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Guest User',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(authProvider).signInWithGoogle();
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                'Pro Chef Member',
                style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              
              // Menu Items
              _buildMenuItem(context, Icons.star, 'Go Premium', onTap: () => context.push('/premium'), isPremium: true),
              _buildMenuItem(context, Icons.people, 'Community & Reviews', onTap: () => context.push('/community')),
              _buildMenuItem(context, Icons.emoji_events, 'Achievements & Badges', onTap: () {}),
              _buildMenuItem(context, Icons.notifications, 'Notifications', onTap: () => context.push('/notifications')),
              const Divider(),
              _buildMenuItem(context, Icons.help_outline, 'Help & Support', onTap: () {}),
              if (user != null)
                _buildMenuItem(context, Icons.logout, 'Logout', onTap: () async {
                  await ref.read(authProvider).signOut();
                }, isDestructive: true),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildMenuItem(BuildContext context, IconData icon, String title, {required VoidCallback onTap, bool isDestructive = false, bool isPremium = false}) {
    Color? defaultColor = Theme.of(context).textTheme.bodyLarge?.color;
    Color? itemColor = isDestructive ? Colors.red : (isPremium ? Colors.amber : defaultColor);
    
    return ListTile(
      leading: Icon(icon, color: itemColor),
      title: Text(title, style: TextStyle(color: itemColor, fontWeight: isPremium ? FontWeight.bold : FontWeight.normal)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
