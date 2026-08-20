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
  // FLAG 5: This State object owns its own mutable copy of the
  // roster, separate from the original top-level `studentList`.
  // Because it lives inside a State, we can call setState() after
  // removing a student and Flutter will rebuild the ListView with
  // the shorter list — no gaps, no leftover card.
  late List<Student> students;

  @override
  void initState() {
    super.initState();
    students = List<Student>.from(studentList);
  }

  // FLAG 5: Removes a specific student from the Dart List using
  // List.remove(), then setState() so the UI updates immediately.
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

          // FLAG 5: reading from `students` (this State's mutable
          // list) instead of the original `studentList`, so deletions
          // are reflected immediately.
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
                  // FLAG 7: A stable key tied to studentId — NOT the
                  // list index. Without this, ListView.builder can
                  // reuse a card's State object (isFavorited,
                  // editCount) by *position* when the list shrinks
                  // after a delete, silently attaching one student's
                  // state to a different student's card. Keying by
                  // studentId guarantees each card's independent
                  // state always stays attached to the correct
                  // student no matter how the list changes.
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
                  // FLAG 5: each card gets a callback that deletes
                  // *this* student from the parent's list.
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

// FLAG 1: ProfileCard is now a StatefulWidget so the Favorite button
// can visibly toggle its own state (icon + color) when pressed, in
// addition to showing a SnackBar and printing to the console.
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

  // FLAG 5: Callback supplied by the parent (MyHomePage's State),
  // invoked when the user confirms deletion. The card itself never
  // touches the list directly — it just asks its parent to remove it.
  final VoidCallback? onDelete;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  // FLAG 4: Each ProfileCard in the ListView.builder gets its own
  // _ProfileCardState instance, so isFavorited lives independently
  // per student. Favoriting one card's State object has zero effect
  // on any other card's State object — no shared/global variable is
  // involved, so each student keeps their own favorite status.
  bool isFavorited = false;

  // FLAG 3: Counter that visibly updates on screen every time the
  // Edit button is pressed, via setState.
  int editCount = 0;

  // FLAG 1: onPressed handler for the Favorite button.
  // Reacts visibly by (1) toggling local state so the icon/label
  // updates, (2) printing a message to the console, and
  // (3) showing a temporary SnackBar notification.
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

  // FLAG 1 & FLAG 3: onPressed handler for the Edit button.
  // FLAG 3: setState here increments editCount, which is displayed
  // on screen, so Flutter rebuilds this card and the new count
  // appears immediately.
  // FLAG 6: This is only an Edit *trigger* — it opens a temporary
  // bottom sheet that previews the fields a future Edit Screen will
  // let you change. No actual saving/editing logic is implemented
  // yet; that's the next CTF.
  void _handleEditPressed() {
    setState(() {
      editCount++;
    });

    final name = widget.fullName ?? 'this student';
    print('Edit button pressed for $name. editCount=$editCount');

    // FLAG 6: showModalBottomSheet displays a temporary editing
    // interface that slides up from the bottom of the screen.
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
            // Keeps content clear of the on-screen keyboard/nav bar.
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

  // FLAG 5: onPressed handler for the Delete button. Shows a quick
  // confirmation dialog, then calls widget.onDelete — the callback
  // passed down from MyHomePage's State — which removes this student
  // from the List and triggers setState() in the parent so the UI
  // updates immediately.
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

  // FLAG 2: onTap handler for the Student Card itself.
  // This is intentionally separate from _handleFavoritePressed and
  // _handleEditPressed above — tapping the card body reacts on its
  // own, distinct from tapping either button.
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
      // FLAG 4: The card's own background color changes when this
      // specific student is favorited (a warm amber tint), while all
      // other cards stay their normal translucent white — because each
      // ProfileCard/InkWell has its own independent isFavorited state.
      color: isFavorited
          ? Colors.amber.withOpacity(0.25)
          : Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isFavorited
            ? const BorderSide(color: Colors.amberAccent, width: 2)
            : BorderSide.none,
      ),
      // FLAG 2: InkWell makes the whole card tappable via onTap.
      // clipBehavior keeps the ripple within the Card's rounded corners.
      // Because ElevatedButton has its own gesture handling, tapping
      // either button is consumed by the button first and does NOT
      // also fire this card-level onTap — the two interactions stay
      // separate, as required.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _handleCardTapped,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // FLAG 4: Star badge overlaid on the avatar, only shown
              // for this student when isFavorited is true.
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

              // FLAG 4: "Favorite" label pill, shown only for this
              // student's card when it has been favorited. Full name
              // stays on its own line either way.
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

              // FLAG 3: This text visibly updates the instant setState()
              // runs inside _handleEditPressed — Flutter rebuilds this
              // widget and the new editCount value appears on screen
              // immediately, no manual refresh needed.
              Text(
                'Edited $editCount time${editCount == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 8),

              // FLAG 1: Two buttons, each wired to onPressed.
              // - Favorite: toggles isFavorited via setState, which
              //   updates its own icon/label (FLAG 3 example #1: changing
              //   an icon), prints to console, and shows a SnackBar.
              // - Edit: increments editCount via setState, which updates
              //   the counter text above (FLAG 3 example #2: updating a
              //   counter), prints to console, and shows a SnackBar.
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

              // FLAG 5: Delete button, on its own row so it's visually
              // separated from Favorite/Edit and harder to hit by
              // accident. Confirms via dialog, then removes this
              // student from the list through widget.onDelete.
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