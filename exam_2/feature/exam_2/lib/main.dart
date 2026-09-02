import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social',
      theme: ThemeData(brightness: Brightness.dark),
      home: const SocialScreen(),
    );
  }
}

enum FriendStatus { online, playing, away }

class Profiles {
  final String status;
  final String name;
  final FriendStatus icon;

  Profiles({required this.status, required this.name, required this.icon});
}

List<Profiles> onValorant = [
  Profiles(status: 'Online - VALORANT', name: 'MissYouLikeKrazy', icon: FriendStatus.online),
  Profiles(status: 'Playing - VALORANT', name: 'bread', icon: FriendStatus.playing),
  Profiles(status: 'Playing - VALORANT', name: 'The14th', icon: FriendStatus.playing),
];

List<Profiles> onMobile = [
  Profiles(status: 'Away - Riot Mobile', name: 'Carlvendish', icon: FriendStatus.away),
  Profiles(status: 'Away - Riot Mobile', name: 'D1yah', icon: FriendStatus.away),
];

class SocialScreen extends StatelessWidget {
  const SocialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Social',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: const [
                Text(
                  'Friends',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 20),
                Text('Messages', style: TextStyle(color: Colors.grey, fontSize: 16)),
                SizedBox(width: 20),
                Text('Requests', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 2, width: 60, color: Colors.red),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 10),
                  Text('Search', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: const [
                Icon(Icons.play_circle, color: Colors.red, size: 20),
                SizedBox(width: 6),
                Text('VALORANT',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text('3', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),

            for (var profile in onValorant) buildFriendRow(profile),

            const SizedBox(height: 24),

            // ----- Online group -----
            Row(
              children: const [
                Text('Online',
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Text('4', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),

            for (var profile in onMobile) buildFriendRow(profile),
          ],
        ),
      ),
    );
  }
}

Widget buildFriendRow(Profiles profile) {
  Color dotColor;

  switch (profile.icon) {
    case FriendStatus.online:
      dotColor = Colors.green;
      break;
    case FriendStatus.playing:
      dotColor = Colors.cyan;
      break;
    case FriendStatus.away:
      dotColor = Colors.yellowAccent;
      break;
  }

  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, color: Colors.red),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profile.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(profile.status, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ],
    ),
  );
}