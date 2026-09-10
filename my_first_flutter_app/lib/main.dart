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

  /*

  STATUS LEGEND
  Active   -> 0
  Inactive -> 1

  */

  final int status;

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
    required this.status,
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
    status: 0, // Active
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
    status: 1, // Inactive
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
    status: 0, // Active
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
    status: 0, // Active
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
    status: 1, // Inactive
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
    status: 0, // Active
  ),
])
  ..sort((a, b) {
    if (a.name == null && b.name == null) return 0;
    if (a.name == null) return 1;
    if (b.name == null) return -1;
    return a.name!.toUpperCase().compareTo(b.name!.toUpperCase());
  });

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter Application',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

// BAG-O: Flag 5 - Enum para klaro asa nga state ta karon.
// Ang decision kung unsa nga UI ang ipakita kay base ra sa
// duha ka butang: isLoading ug students.isEmpty.
enum DirectoryState { loading, hasStudents, empty }

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Student> students;

  // Flag 4: true una = naga-load pa, false = tapos na mag-load.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    students = List<Student>.from(studentList);

    // Mag-simulate ta ug 2 seconds nga pag-load (sama sa pag-fetch
    // gikan sa internet o database). Human sa 2 seconds, i-usab nato
    // ang isLoading ngadto sa false.
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  // BAG-O: Flag 5 - kani nga getter mao ang single source of truth.
  // Naa ra guy tay usa ka state nga ma-return, so dili gyud mag-
  // overlap ang loading/list/empty nga UI.
  DirectoryState get _currentState {
    if (isLoading) return DirectoryState.loading;
    if (students.isEmpty) return DirectoryState.empty;
    return DirectoryState.hasStudents;
  }

  void _deleteStudent(Student student) {
    setState(() {
      students.remove(student);
    });
  }

  // Flag 3: i-restore ang tibuok list human ma-delete tanan.
  void _addStudent() {
    setState(() {
      students = List<Student>.from(studentList);
    });
  }

  // BAG-O: Flag 5 (extra) - optional reload button para ma-demo
  // pag-usab ang Loading state nga wala mag-restart sa app.
  void _reloadDirectory() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  // BAG-O: Flag 5 - switch statement nga mo-return sa TAMA ra nga
  // widget base sa _currentState. Kay switch ra ni (dili if-chain
  // nga puwede ma-miss), sigurado nga usa ra ka branch ang ma-build.
  Widget _buildBody() {
    switch (_currentState) {
      case DirectoryState.loading:
        return const LoadingWidget();

      case DirectoryState.empty:
        return EmptyStateWidget(onAddStudent: _addStudent);

      case DirectoryState.hasStudents:
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
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
                status: student.status,
                onDelete: () => _deleteStudent(student),
              ),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('My First Flutter Application'),
        actions: [
          // Optional: lets you demo the Loading state again without
          // restarting the whole app. Remove if you don't want it.
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload',
            onPressed: isLoading ? null : _reloadDirectory,
          ),
        ],
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
          // BAG-O: Flag 5 - usa ra ka call, dayon ang _buildBody()
          // na ang mo-decide unsa nga UI ang ipakita base sa state.
          child: _buildBody(),
        ),
      ),
    );
  }
}

// Flag 4: Loading state widget. Simple lang: spinner + text sa tunga.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Loading students...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Flag 3: Empty state widget.
class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddStudent;

  const EmptyStateWidget({Key? key, required this.onAddStudent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 20),
            // Flag 3: Button to add a student.
            // Mo-restore ra sa original list para naa gihapon student.
            ElevatedButton(
              onPressed: onAddStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    Key? key,
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
    required this.status,
    this.onDelete,
  }) : super(key: key);

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

  /*

  STATUS LEGEND
  Active   -> 0
  Inactive -> 1

  */

  final int status;

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
              const Text(
                'Edit Student',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
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
                'dili pa ma edit (OTW EDITABLE).',
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

    // Flag 1: Active or Inactive
    // Legend: 0 = Active, 1 = Inactive
    String activeText = 'Inactive'; // default
    Color activeColor = Colors.grey; // default

    if (widget.status == 0) {
      activeText = 'Active';
      activeColor = Colors.green;
    }

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
              // Flag 3: small delete icon, permanente makita bisan
              // Active o Inactive ang student. Kani ang paagi para
              // ma-delete gihapon ang Inactive students diretso sa app.
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _handleDeletePressed,
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),

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
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
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
                    child: const Text(
                      'Favorite',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

              // Flag 1: Active or Inactive indicator.
              Text(
                activeText,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),

              // Flag 2: Warning nga mogawas lang kung Inactive.
              if (widget.status != 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Warning: This student is inactive.',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
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
                    child: ElevatedButton(
                      onPressed: _handleFavoritePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isFavorited ? 'Favorited' : 'Favorite'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleEditPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Edit'),
                    ),
                  ),
                ],
              ),

              // Flag 2: Delete button nga mogawas lang kung Active.
              // Kung Inactive (status != 0), wala gyuy ma-add sa widget
              // list, so mawala ang delete button.
              if (widget.status == 0) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleDeletePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.55),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete Student'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({Key? key}) : super(key: key);

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