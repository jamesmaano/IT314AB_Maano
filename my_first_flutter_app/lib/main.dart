import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Student {
  String image;
  String? name;
  String? courseSection;
  int age;
  String? hobby;
  double height;
  bool isStudent;
  String birthdate;
  String studentId;
  String email;
  String favoriteSubject;
  int status;

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

List<Student> studentList = [
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
    status: 0,
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
    status: 1,
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
    status: 0,
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
    status: 0,
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
    status: 1,
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
    status: 0,
  ),
];

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter Application',
      debugShowCheckedModeBanner: false,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) {
          return StudentListScreen();
        },
        '/add-student': (context) {
          return AddStudentScreen();
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) {
              return StudentListScreen();
            },
          );
        }

        if (settings.name == '/student-details') {
          var args = settings.arguments;

          if (args is Student) {
            return MaterialPageRoute(
              builder: (context) {
                return StudentDetailsScreen(student: args);
              },
            );
          }

          return MaterialPageRoute(
            builder: (context) {
              return StudentListScreen();
            },
          );
        }

        return null;
      },
    );
  }
}

class StudentListScreen extends StatefulWidget {
  StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() {
    return _StudentListScreenState();
  }
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];
  bool isLoading = true;
  bool screenIsAlive = true;

  @override
  void initState() {
    super.initState();

    students = List<Student>.from(studentList);

    students.sort((a, b) {
      if (a.name == null && b.name == null) {
        return 0;
      }
      if (a.name == null) {
        return 1;
      }
      if (b.name == null) {
        return -1;
      }
      return a.name!.toUpperCase().compareTo(b.name!.toUpperCase());
    });

    Future.delayed(Duration(seconds: 2), () {
      if (screenIsAlive == true) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    screenIsAlive = false;
    super.dispose();
  }

  void removeStudent(Student student) {
    setState(() {
      students.remove(student);
    });
  }

  void addStudentsBack() {
    setState(() {
      students = List<Student>.from(studentList);
    });
  }

  void reload() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      if (screenIsAlive == true) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> openDetails(Student student) async {
    await Navigator.pushNamed(
      context,
      '/student-details',
      arguments: student,
    );

    setState(() {});
  }

  void goToAddStudent() {
    Navigator.pushNamed(context, '/add-student');
  }

  Widget buildBody() {
    if (isLoading == true) {
      return LoadingWidget();
    }

    if (students.isEmpty == true) {
      return EmptyStateWidget(onAddStudent: addStudentsBack);
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      itemCount: students.length,
      itemBuilder: (context, index) {
        Student student = students[index];

        return Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: ProfileCard(
            key: ValueKey(student.studentId),
            student: student,
            onDelete: () {
              removeStudent(student);
            },
            onTap: () {
              openDetails(student);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('My First Flutter Application'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              if (isLoading == false) {
                reload();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAddStudent,
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: buildBody(),
        ),
      ),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  AddStudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Student'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fill in the information below:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            addField('Name'),
            addField('Student ID'),
            addField('Course & Section'),
            addField('Age', keyboard: TextInputType.number),
            addField('Height (m)', keyboard: TextInputType.number),
            addField('Birthdate'),
            addField('Email'),
            addField('Favorite Subject'),
            addField('Hobby'),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Save feature coming soon!')),
                  );
                },
                child: Text('Save Student'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addField(String label, {TextInputType? keyboard}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            keyboardType: keyboard,
          ),
        ],
      ),
    );
  }
}

class StudentDetailsScreen extends StatefulWidget {
  StudentDetailsScreen({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<StudentDetailsScreen> createState() {
    return _StudentDetailsScreenState();
  }
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  Student get student {
    return widget.student;
  }

  void openEditModal() {
    TextEditingController nameCtrl = TextEditingController();
    TextEditingController idCtrl = TextEditingController();
    TextEditingController courseCtrl = TextEditingController();
    TextEditingController ageCtrl = TextEditingController();
    TextEditingController heightCtrl = TextEditingController();
    TextEditingController birthdateCtrl = TextEditingController();
    TextEditingController emailCtrl = TextEditingController();
    TextEditingController subjectCtrl = TextEditingController();
    TextEditingController hobbyCtrl = TextEditingController();

    if (student.name != null) {
      nameCtrl.text = student.name!;
    }
    idCtrl.text = student.studentId;
    if (student.courseSection != null) {
      courseCtrl.text = student.courseSection!;
    }
    ageCtrl.text = student.age.toString();
    heightCtrl.text = student.height.toString();
    birthdateCtrl.text = student.birthdate;
    emailCtrl.text = student.email;
    subjectCtrl.text = student.favoriteSubject;
    if (student.hobby != null) {
      hobbyCtrl.text = student.hobby!;
    }

    int tempStatus = student.status;
    bool tempIsStudent = student.isStudent;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Student',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16),

                    editField('Name', nameCtrl),
                    editField('Student ID', idCtrl),
                    editField('Course & Section', courseCtrl),
                    editField('Age', ageCtrl, keyboard: TextInputType.number),
                    editField('Height (m)', heightCtrl,
                        keyboard: TextInputType.number),
                    editField('Birthdate', birthdateCtrl),
                    editField('Email', emailCtrl),
                    editField('Favorite Subject', subjectCtrl),
                    editField('Hobby', hobbyCtrl),

                    SizedBox(height: 4),
                    Text(
                      'Status',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    DropdownButton<int>(
                      value: tempStatus,
                      isExpanded: true,
                      dropdownColor: Color(0xFF2A2A2A),
                      style: TextStyle(color: Colors.white),
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: Text(
                            'Active',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text(
                            'Inactive',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setSheetState(() {
                          if (value != null) {
                            tempStatus = value;
                          }
                        });
                      },
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Currently enrolled',
                        style: TextStyle(color: Colors.white),
                      ),
                      activeColor: Colors.tealAccent,
                      value: tempIsStudent,
                      onChanged: (value) {
                        setSheetState(() {
                          tempIsStudent = value;
                        });
                      },
                    ),

                    SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white54),
                            ),
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (nameCtrl.text.isEmpty) {
                                  student.name = null;
                                } else {
                                  student.name = nameCtrl.text;
                                }

                                student.studentId = idCtrl.text;

                                if (courseCtrl.text.isEmpty) {
                                  student.courseSection = null;
                                } else {
                                  student.courseSection = courseCtrl.text;
                                }

                                int newAge = int.tryParse(ageCtrl.text) ?? 0;
                                if (newAge > 0) {
                                  student.age = newAge;
                                }

                                double newHeight =
                                    double.tryParse(heightCtrl.text) ?? 0;
                                if (newHeight > 0) {
                                  student.height = newHeight;
                                }

                                student.birthdate = birthdateCtrl.text;
                                student.email = emailCtrl.text;
                                student.favoriteSubject = subjectCtrl.text;

                                if (hobbyCtrl.text.isEmpty) {
                                  student.hobby = null;
                                } else {
                                  student.hobby = hobbyCtrl.text;
                                }

                                student.status = tempStatus;
                                student.isStudent = tempIsStudent;
                              });

                              Navigator.pop(sheetContext);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Save'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget editField(String label, TextEditingController controller,
      {TextInputType? keyboard}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white54),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.tealAccent),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = student.status == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Student Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: openEditModal,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.6),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 10),

                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage(student.image),
                ),
                SizedBox(height: 16),

                Text(
                  student.name ?? 'Not provided',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Card(
                  color: Colors.white.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Divider(color: Colors.white54),
                        infoRow('Name', student.name ?? 'Not provided'),
                        infoRow('Student ID', student.studentId),
                        infoRow(
                          'Course & Section',
                          student.courseSection ?? 'Unknown',
                        ),
                        infoRow('Status', isActive ? 'Active' : 'Inactive'),
                        infoRow('Age', student.age.toString()),
                        infoRow('Birthdate', student.birthdate),
                        infoRow('Email', student.email),
                        infoRow('Favorite Subject', student.favoriteSubject),
                        infoRow('Hobby', student.hobby ?? 'Not provided'),
                        infoRow('Height', student.height.toString() + ' m'),
                        infoRow(
                          'Enrollment',
                          student.isStudent
                              ? 'Currently enrolled'
                              : 'Not enrolled',
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: openEditModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Edit Student'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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

class EmptyStateWidget extends StatelessWidget {
  EmptyStateWidget({Key? key, required this.onAddStudent}) : super(key: key);

  final VoidCallback onAddStudent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No students found.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onAddStudent,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatefulWidget {
  ProfileCard({
    Key? key,
    required this.student,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  final Student student;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  @override
  State<ProfileCard> createState() {
    return _ProfileCardState();
  }
}

class _ProfileCardState extends State<ProfileCard> {
  bool isFavorited = false;
  int editCount = 0;

  void pressFavorite() {
    setState(() {
      if (isFavorited == true) {
        isFavorited = false;
      } else {
        isFavorited = true;
      }
    });

    String name = 'this student';
    if (widget.student.name != null) {
      name = widget.student.name!;
    }

    String message = '';
    if (isFavorited == true) {
      message = name + ' added to favorites!';
    } else {
      message = name + ' removed from favorites.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void pressDelete() {
    String name = 'this student';
    if (widget.student.name != null) {
      name = widget.student.name!;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete Student'),
          content: Text('Remove ' + name + ' from the directory?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Student student = widget.student;

    String displayName = 'Not provided';
    if (student.name != null) {
      displayName = student.name!;
    }

    String displayCourse = 'Unknown';
    if (student.courseSection != null) {
      displayCourse = student.courseSection!;
    }

    String displayHobby = 'Not provided';
    if (student.hobby != null) {
      displayHobby = student.hobby!;
    }

    String activeText = 'Inactive';
    Color activeColor = Colors.grey;
    if (student.status == 0) {
      activeText = 'Active';
      activeColor = Colors.green;
    }

    Color cardColor = Colors.white.withOpacity(0.15);
    if (isFavorited == true) {
      cardColor = Colors.amber.withOpacity(0.25);
    }

    BorderSide cardSide = BorderSide.none;
    if (isFavorited == true) {
      cardSide = BorderSide(color: Colors.amberAccent, width: 2);
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: cardSide,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: pressDelete,
                  child: Text(
                    'Remove',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),

              Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage(student.image),
                ),
              ),
              SizedBox(height: 20),

              if (isFavorited == true)
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Favorite',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

              Text(
                activeText,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),

              if (student.status != 0)
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Warning: This student is inactive.',
                    style: TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              Text(
                'Full Name: ' + displayName,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              Text(
                'Course & Section: ' + displayCourse,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 8),

              Text(
                'Hobby: ' + displayHobby,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 8),

              Text(
                'Student ID: ' + student.studentId,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 8),

              Text(
                'Email: ' + student.email,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              SizedBox(height: 8),

              Text(
                'Favorite Subject: ' + student.favoriteSubject,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 8),

              Text(
                'Height: ' + student.height.toString() + ' m',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 8),

              if (student.isStudent == true)
                Text(
                  'Student Status: Currently enrolled',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              else
                Text(
                  'Student Status: Not enrolled',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),

              Divider(color: Colors.white54, height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Age: ' + student.age.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Birthdate: ' + student.birthdate,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),

              Divider(color: Colors.white54, height: 30),

              Text(
                'Edited ' + editCount.toString() + ' time/s',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: pressFavorite,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isFavorited ? 'Favorited' : 'Favorite'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          editCount = editCount + 1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Edit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}