import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Student {
  final String image;
  final String? name;
  final String? courseSection;
  final int age;
  final String? hobby;
  final double height;
  final bool isStudent;
  final String birthdate;

  final String studentId;
  final String email;
  final String favoriteSubject;

  Student({
    required this.image,
    required this.name,
    required this.courseSection,
    required this.age,
    required this.hobby,
    required this.height,
    required this.isStudent,
    required this.birthdate,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
  });
}


bool simulateEmptyList = false;

List<Student> studentList = (simulateEmptyList
    ? <Student>[]
    : [
  Student(
    image: 'assets/OIP (1).jpg',
    name: 'JAMES NEIL M. MAANO',
    courseSection: 'BSIT 3',
    age: 21,
    hobby: 'Basketball',
    height: 5.5,
    isStudent: true,
    birthdate: 'July 30, 2004',
    studentId: '2023-00145',
    email: 'james.maano@student.edu.ph',
    favoriteSubject: 'Sleeping all the time',
  ),
  Student(
    image: 'assets/alright.jpg',
    name: 'Juan Dela Cruz',
    courseSection: null,
    age: 22,
    hobby: 'Gaming',
    height: 1.70,
    isStudent: true,
    birthdate: 'September 2, 2003',
    studentId: '2022-00089',
    email: 'juan.delacruz@student.edu.ph',
    favoriteSubject: 'Data Structures',
  ),
  Student(
    image: 'assets/chopper.jpg',
    name: 'Maria Santos',
    courseSection: 'BSIT 2',
    age: 20,
    hobby: null,
    height: 1.60,
    isStudent: true,
    birthdate: 'March 14, 2006',
    studentId: '2024-00212',
    email: 'maria.santos@student.edu.ph',
    favoriteSubject: 'Web Development',
  ),
  Student(
    image: 'assets/broke.jpg',
    name: null,
    courseSection: 'BSIT 1',
    age: 19,
    hobby: 'Drawing',
    height: 1.58,
    isStudent: true,
    birthdate: 'January 21, 2007',
    studentId: '2025-00301',
    email: 'angela.reyes@student.edu.ph',
    favoriteSubject: 'UI/UX Design',
  ),
  Student(
    image: 'assets/zoro.jpg',
    name: 'Mark Villanueva',
    courseSection: 'BSIT 3',
    age: 21,
    hobby: 'Photography',
    height: 1.75,
    isStudent: true,
    birthdate: 'June 10, 2004',
    studentId: '2023-00177',
    email: 'mark.villanueva@student.edu.ph',
    favoriteSubject: 'Database Systems',
  ),
  Student(
    image: 'assets/zoro.jpg',
    name: 'Patricia Gomez',
    courseSection: 'BSIT 2',
    age: 20,
    hobby: 'Volleyball',
    height: 1.62,
    isStudent: true,
    birthdate: 'November 5, 2005',
    studentId: '2024-00256',
    email: 'patricia.gomez@student.edu.ph',
    favoriteSubject: 'Software Engineering',
  ),
])
  ..sort((a, b) {
    if (a.name == null && b.name == null) return 0;
    if (a.name == null) return 1;
    if (b.name == null) return -1;
    return a.name!.toUpperCase().compareTo(b.name!.toUpperCase());
  });

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

          child: studentList.isEmpty
              ? const EmptyStateWidget()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 30),
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              final student = studentList[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ProfileCard(
                  profileImage: student.image,
                  fullName: student.name,
                  courseSection: student.courseSection,
                  age: student.age,
                  hobby: student.hobby,
                  height: student.height,
                  isStudent: student.isStudent,
                  birthdate: student.birthdate,
                  studentId: student.studentId,
                  email: student.email,
                  favoriteSubject: student.favoriteSubject,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 90,
              color: Colors.white70,
            ),
            const SizedBox(height: 20),
            const Text(
              'No students found.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'The student list is currently empty.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
  });

  final String? fullName;
  final String? courseSection;
  final String? hobby;

  final String profileImage;
  final int age;
  final double height;
  final bool isStudent;
  final String birthdate;

  final String studentId;
  final String email;
  final String favoriteSubject;

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
                fontStyle:
                fullName == null ? FontStyle.italic : FontStyle.normal,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Course & Section: $displayCourse',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontStyle: courseSection == null
                    ? FontStyle.italic
                    : FontStyle.normal,
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
              'Student ID: $studentId',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            const SizedBox(height: 8),

            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),

            const SizedBox(height: 8),

            Text(
              'Favorite Subject: $favoriteSubject',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            const SizedBox(height: 8),

            Text(
              'Height: ${height}m',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),

            const SizedBox(height: 8),

            Text(
              isStudent
                  ? 'Student Status: Currently enrolled'
                  : 'Student Status: Not enrolled',
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