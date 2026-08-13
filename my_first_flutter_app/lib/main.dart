import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter Application',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('My First Flutter Application'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                ProfileCard(
                  profileImage: 'assets/OIP (1).jpg',
                  fullName: 'JAMES NEIL M. MAANO',
                  courseSection: 'BSIT 3',
                  age: 21,
                  hobby: 'Basketball',
                  height: 5.5,
                  isStudent: true,
                  birthdate: 'July 30, 2004',
                ),

                SizedBox(height: 20),

                ProfileCard(
                  profileImage: 'assets/alright.jpg',
                  fullName: 'Juan Dela Cruz',
                  courseSection: null,
                  age: 22,
                  hobby: 'Gaming',
                  height: 1.70,
                  isStudent: true,
                  birthdate: 'September 2, 2003',
                ),

                SizedBox(height: 20),

                ProfileCard(
                  profileImage: 'assets/chopper.jpg',
                  fullName: 'Maria Santos',
                  courseSection: 'BSIT 2',
                  age: 20,
                  hobby: null,
                  height: 1.60,
                  isStudent: true,
                  birthdate: 'March 14, 2006',
                ),

                SizedBox(height: 20),

                ProfileCard(
                  profileImage: 'assets/broke.jpg',
                  fullName: null,
                  courseSection: 'BSIT 1',
                  age: 19,
                  hobby: 'Drawing',
                  height: 1.58,
                  isStudent: true,
                  birthdate: 'January 21, 2007',
                ),

                SizedBox(height: 20),

                ProfileCard(
                  profileImage: 'assets/zoro.jpg',
                  fullName: 'Mark Villanueva',
                  courseSection: 'BSIT 3',
                  age: 21,
                  hobby: 'Photography',
                  height: 1.75,
                  isStudent: true,
                  birthdate: 'June 10, 2004',
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.profileImage,
    required this.fullName,
    required this.courseSection,
    required this.age,
    required this.hobby,
    required this.height,
    required this.isStudent,
    required this.birthdate,
  });

  final String? fullName;
  final String? courseSection;
  final String? hobby;

  final String profileImage;
  final int age;
  final double height;
  final bool isStudent;
  final String birthdate;

  @override
  Widget build(BuildContext context) {
    String displayName = fullName ?? 'Not provided';
    String displayCourse = courseSection ?? 'Unknown';
    String displayHobby = hobby ?? 'Not provided';

    return Card(
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: 75,
                backgroundImage: AssetImage(profileImage),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Full Name: $displayName',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: fullName == null ? FontStyle.italic : FontStyle.normal,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Course & Section: $displayCourse',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: courseSection == null ? FontStyle.italic : FontStyle.normal,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Hobby: $displayHobby',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontStyle: hobby == null ? FontStyle.italic : FontStyle.normal,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Height: ${height}m',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            const SizedBox(height: 8),

            Text(
              isStudent ? 'Student Status: Currently enrolled' : 'Student Status: Not enrolled',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            const SizedBox(height: 16),

            const Divider(
              color: Colors.white54,
              thickness: 1,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Age: $age',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Birthdate: $birthdate',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'My Favorites',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 16),

            Text(
              'Favorite Game: Mobile Legends',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            SizedBox(height: 10),

            Text(
              'Favorite Movie: Interstellar',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            SizedBox(height: 10),

            Text(
              'Favorite Food: Adobo',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}