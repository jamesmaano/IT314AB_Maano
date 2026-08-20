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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Student> students;
  @override
  void initState() {
    super.initState();
    students = List<Student>.from(studentList);
  }
  void _deleteStudent(Student student) {
    setState(() {
      students.remove(student);
    });
  }
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
          child: students.isEmpty
              ? const EmptyStateWidget()
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 30),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ProfileCard(
                  key: ValueKey(student.studentId),
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
                  onDelete: () => _deleteStudent(student),
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
class ProfileCard extends StatefulWidget {
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
    this.onDelete,
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
  final VoidCallback? onDelete;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isFavorited = false;
  int editCount = 0;
  void _handleFavoritePressed() {
    setState(() {
      isFavorited = !isFavorited;
    });

    final name = widget.fullName ?? 'this student';
    print('Favorite button pressed for $name. isFavorited=$isFavorited');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorited
              ? '$name added to favorites!'
              : '$name removed from favorites.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  void _handleEditPressed() {
    setState(() {
      editCount++;
    });

    final name = widget.fullName ?? 'this student';
    print('Edit button pressed for $name. editCount=$editCount');
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.edit, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Edit Student',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'dili pa ma edit'
                    '(OTW EDITABLE.',
                style: TextStyle(fontSize: 13, color: Colors.white54),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(bottomSheetContext).pop(),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleDeletePressed() {
    final name = widget.fullName ?? 'this student';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: Text('Remove $name from the directory?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                print('Delete confirmed for $name.');
                widget.onDelete?.call();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
  void _handleCardTapped() {
    final name = widget.fullName ?? 'this student';
    print('Student Card tapped for $name.');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You tapped $name\'s card.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayName = widget.fullName ?? 'Not provided';
    String displayCourse = widget.courseSection ?? 'Unknown';
    String displayHobby = widget.hobby ?? 'Not provided';

    return Card(
      color: isFavorited
          ? Colors.amber.withOpacity(0.25)
          : Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isFavorited
            ? const BorderSide(color: Colors.amberAccent, width: 2)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _handleCardTapped,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 75,
                      backgroundImage: AssetImage(widget.profileImage),
                    ),
                    if (isFavorited)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              if (isFavorited)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.black),
                        SizedBox(width: 4),
                        Text(
                          'Favorite',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              Text(
                'Full Name: $displayName',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontStyle: widget.fullName == null
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Course & Section: $displayCourse',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontStyle: widget.courseSection == null
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
                  fontStyle:
                  widget.hobby == null ? FontStyle.italic : FontStyle.normal,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Student ID: ${widget.studentId}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),

              const SizedBox(height: 8),

              Text(
                'Email: ${widget.email}',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),

              const SizedBox(height: 8),

              Text(
                'Favorite Subject: ${widget.favoriteSubject}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),

              const SizedBox(height: 8),

              Text(
                'Height: ${widget.height}m',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),

              const SizedBox(height: 8),

              Text(
                widget.isStudent
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
                    'Age: ${widget.age}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Birthdate: ${widget.birthdate}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(
                color: Colors.white54,
                thickness: 1,
              ),

              const SizedBox(height: 12),
              Text(
                'Edited $editCount time${editCount == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleFavoritePressed,
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? Colors.redAccent : Colors.white,
                      ),
                      label: Text(isFavorited ? 'Favorited' : 'Favorite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleEditPressed,
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleDeletePressed,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  label: const Text('Delete Student'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.55),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
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