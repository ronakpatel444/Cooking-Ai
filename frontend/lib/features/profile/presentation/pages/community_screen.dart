import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community & Reviews'),
        actions: [
          IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {})
        ],
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://via.placeholder.com/50'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Chef Master', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('2 hours ago', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const Text('5.0', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Made the Paneer Butter Masala today! It was absolutely delicious. The AI suggested adding a bit of honey and it worked wonders.'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 4),
                      Text('24', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(width: 16),
                      Icon(Icons.comment_outlined, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 4),
                      Text('5', style: TextStyle(color: Colors.grey[600])),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
