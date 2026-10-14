import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// 1. START THE APP
// ============================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadStudents();
  runApp(MyApp());
}

// ============================================================
// 2. THE STUDENT BLUEPRINT
// ============================================================
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

// ============================================================
// 3. ONE LIST USED BY THE WHOLE APP
// ============================================================
List<Student> studentList = [];

// ============================================================
// 4. DEFAULT STUDENTS
// ============================================================
List<Student> makeDefaultStudents() {
  List<Student> list = [];

  list.add(Student(
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
  ));

  list.add(Student(
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
  ));

  list.add(Student(
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
  ));

  list.add(Student(
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
  ));

  list.add(Student(
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
  ));

  list.add(Student(
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
  ));

  return list;
}

Future<void> saveStudents() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<Map<String, dynamic>> listOfMaps = [];
  for (int i = 0; i < studentList.length; i++) {
    Student s = studentList[i];
    Map<String, dynamic> map = {
      'image': s.image,
      'name': s.name,
      'courseSection': s.courseSection,
      'age': s.age,
      'hobby': s.hobby,
      'height': s.height,
      'isStudent': s.isStudent,
      'birthdate': s.birthdate,
      'studentId': s.studentId,
      'email': s.email,
      'favoriteSubject': s.favoriteSubject,
      'status': s.status,
    };
    listOfMaps.add(map);
  }

  String text = jsonEncode(listOfMaps);
  await prefs.setString('students', text);
}

// ============================================================
// 6. LOAD FROM PHONE
// ============================================================
Future<void> loadStudents() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedText = prefs.getString('students');

  if (savedText == null) {
    studentList = makeDefaultStudents();
    await saveStudents();
    return;
  }

  try {
    List<dynamic> decoded = jsonDecode(savedText);
    List<Student> loadedList = [];

    for (int i = 0; i < decoded.length; i++) {
      Map<String, dynamic> map = decoded[i];

      Student s = Student(
        image: map['image'],
        name: map['name'],
        courseSection: map['courseSection'],
        age: map['age'],
        hobby: map['hobby'],
        height: (map['height'] as num).toDouble(),
        isStudent: map['isStudent'],
        birthdate: map['birthdate'],
        studentId: map['studentId'],
        email: map['email'],
        favoriteSubject: map['favoriteSubject'],
        status: map['status'],
      );

      loadedList.add(s);
    }

    studentList = loadedList;
  } catch (e) {
    studentList = makeDefaultStudents();
    await saveStudents();
  }
}

// ============================================================
// 7. EMAIL CHECKER
// ============================================================
bool isEmailOk(String email) {
  RegExp pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  return pattern.hasMatch(email);
}

// ============================================================
// 8. ID CHECKER
// ============================================================
bool isIdUsed(String id, Student? skipThisOne) {
  for (int i = 0; i < studentList.length; i++) {
    Student s = studentList[i];

    if (s == skipThisOne) {
      continue;
    }

    if (s.studentId.toLowerCase() == id.trim().toLowerCase()) {
      return true;
    }
  }
  return false;
}

// ============================================================
// 9. EDIT MODAL — with Save Snackbar
// ============================================================
Future<bool?> showEditStudentModal(BuildContext context, Student student) async {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController idCtrl = TextEditingController();
  TextEditingController courseCtrl = TextEditingController();
  TextEditingController ageCtrl = TextEditingController();
  TextEditingController heightCtrl = TextEditingController();
  TextEditingController birthCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController subjectCtrl = TextEditingController();
  TextEditingController hobbyCtrl = TextEditingController();

  if (student.name != null) nameCtrl.text = student.name!;
  idCtrl.text = student.studentId;
  if (student.courseSection != null) courseCtrl.text = student.courseSection!;
  ageCtrl.text = student.age.toString();
  heightCtrl.text = student.height.toString();
  birthCtrl.text = student.birthdate;
  emailCtrl.text = student.email;
  subjectCtrl.text = student.favoriteSubject;
  if (student.hobby != null) hobbyCtrl.text = student.hobby!;

  int tempStatus = student.status;
  bool tempIsStudent = student.isStudent;

  Widget editField(String label, TextEditingController ctrl,
      {TextInputType? keyboard}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
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

  bool? result = await showModalBottomSheet<bool>(
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
                  editField('Birthdate', birthCtrl),
                  editField('Email', emailCtrl),
                  editField('Favorite Subject', subjectCtrl),
                  editField('Hobby', hobbyCtrl),

                  SizedBox(height: 4),
                  Text('Status',
                      style:
                      TextStyle(color: Colors.white70, fontSize: 13)),
                  DropdownButton<int>(
                    value: tempStatus,
                    isExpanded: true,
                    dropdownColor: Color(0xFF2A2A2A),
                    style: TextStyle(color: Colors.white),
                    items: [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('Active',
                            style: TextStyle(color: Colors.white)),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('Inactive',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                    onChanged: (value) {
                      setSheetState(() {
                        if (value != null) tempStatus = value;
                      });
                    },
                  ),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Currently enrolled',
                        style: TextStyle(color: Colors.white)),
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
                            Navigator.pop(sheetContext, false);
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
                            if (idCtrl.text.trim().isEmpty) {
                              showDialogMessage(
                                  sheetContext, 'Student ID is required');
                              return;
                            }
                            if (isIdUsed(idCtrl.text, student)) {
                              showDialogMessage(
                                  sheetContext, 'Student ID already exists');
                              return;
                            }
                            if (emailCtrl.text.trim().isEmpty) {
                              showDialogMessage(
                                  sheetContext, 'Email is required');
                              return;
                            }
                            if (isEmailOk(emailCtrl.text.trim()) == false) {
                              showDialogMessage(
                                  sheetContext, 'Invalid email');
                              return;
                            }
                            int? newAge = int.tryParse(ageCtrl.text.trim());
                            if (newAge == null || newAge <= 0) {
                              showDialogMessage(
                                  sheetContext, 'Invalid age');
                              return;
                            }
                            double? newHeight =
                            double.tryParse(heightCtrl.text.trim());
                            if (newHeight == null || newHeight <= 0) {
                              showDialogMessage(
                                  sheetContext, 'Invalid height');
                              return;
                            }

                            if (nameCtrl.text.trim().isEmpty) {
                              student.name = null;
                            } else {
                              student.name = nameCtrl.text.trim();
                            }

                            student.studentId = idCtrl.text.trim();

                            if (courseCtrl.text.trim().isEmpty) {
                              student.courseSection = null;
                            } else {
                              student.courseSection =
                                  courseCtrl.text.trim();
                            }

                            student.age = newAge;
                            student.height = newHeight;
                            student.birthdate = birthCtrl.text.trim();
                            student.email = emailCtrl.text.trim();
                            student.favoriteSubject =
                                subjectCtrl.text.trim();

                            if (hobbyCtrl.text.trim().isEmpty) {
                              student.hobby = null;
                            } else {
                              student.hobby = hobbyCtrl.text.trim();
                            }

                            student.status = tempStatus;
                            student.isStudent = tempIsStudent;

                            saveStudents();

                            Navigator.pop(sheetContext, true);
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

  nameCtrl.dispose();
  idCtrl.dispose();
  courseCtrl.dispose();
  ageCtrl.dispose();
  heightCtrl.dispose();
  birthCtrl.dispose();
  emailCtrl.dispose();
  subjectCtrl.dispose();
  hobbyCtrl.dispose();

  return result;
}

// Small helper
void showDialogMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Oops'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

// ============================================================
// 10. APP ROOT
// ============================================================
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Directory',
      debugShowCheckedModeBanner: false,
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => StudentListScreen(),
        '/add-student': (context) => AddStudentScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/student-details') {
          Student student = settings.arguments as Student;
          return MaterialPageRoute(
            builder: (context) => StudentDetailsScreen(student: student),
          );
        }
        return null;
      },
    );
  }
}

// ============================================================
// 11. STUDENT LIST SCREEN
// ============================================================
class StudentListScreen extends StatefulWidget {
  StudentListScreen({Key? key}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void deleteStudent(Student student) {
    setState(() {
      studentList.remove(student);
    });
    saveStudents();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Student deleted!')),
    );
  }

  void restoreDefaults() {
    setState(() {
      studentList = makeDefaultStudents();
    });
    saveStudents();
  }

  void goToDetails(Student student) {
    Navigator.pushNamed(
      context,
      '/student-details',
      arguments: student,
    ).then((result) {
      setState(() {});
    });
  }

  void goToAdd() {
    Navigator.pushNamed(context, '/add-student').then((result) {
      setState(() {});
    });
  }

  void openEdit(Student student) async {
    bool? saved = await showEditStudentModal(context, student);
    if (saved == true) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student updated!')),
      );
    }
  }

  void sortList() {
    studentList.sort((a, b) {
      if (a.name == null && b.name == null) return 0;
      if (a.name == null) return 1;
      if (b.name == null) return -1;
      return a.name!.toUpperCase().compareTo(b.name!.toUpperCase());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return Scaffold(
        backgroundColor: Colors.teal,
        body: Center(
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
        ),
      );
    }

    sortList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Student Directory'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToAdd,
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
          child: studentList.length == 0
              ? Center(
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
                  onPressed: restoreDefaults,
                  child: Text('Add Default Students'),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding:
            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            itemCount: studentList.length,
            itemBuilder: (context, index) {
              Student student = studentList[index];

              return Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: ProfileCard(
                  student: student,
                  onDelete: () {
                    deleteStudent(student);
                  },
                  onTap: () {
                    goToDetails(student);
                  },
                  onEdit: () {
                    openEdit(student);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 12. ADD STUDENT SCREEN
// ============================================================
class AddStudentScreen extends StatefulWidget {
  AddStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController idCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController courseCtrl = TextEditingController();
  TextEditingController yearCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    idCtrl.dispose();
    nameCtrl.dispose();
    courseCtrl.dispose();
    yearCtrl.dispose();
    emailCtrl.dispose();
    super.dispose();
  }

  String? validateId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Student ID is required';
    }
    if (isIdUsed(value, null) == true) {
      return 'This Student ID already exists';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full Name is required';
    }
    return null;
  }

  String? validateCourse(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Course is required';
    }
    return null;
  }

  String? validateYear(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Year Level is required';
    }
    int? year = int.tryParse(value.trim());
    if (year == null) {
      return 'Year Level must be a number';
    }
    if (year < 1 || year > 4) {
      return 'Year Level must be from 1 to 4';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email Address is required';
    }
    if (isEmailOk(value.trim()) == false) {
      return 'Enter a valid email (example: name@school.edu.ph)';
    }
    return null;
  }

  void enrollStudent() {
    bool isValid = formKey.currentState!.validate();

    if (isValid == false) {
      return;
    }

    String courseSection =
        courseCtrl.text.trim() + ' ' + yearCtrl.text.trim();

    Student newStudent = Student(
      image: 'assets/zoro.jpg',
      name: nameCtrl.text.trim(),
      courseSection: courseSection,
      age: 18,
      hobby: null,
      height: 1.60,
      isStudent: true,
      birthdate: 'Not provided',
      studentId: idCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      favoriteSubject: 'Not provided',
      status: 0,
    );

    studentList.add(newStudent);
    saveStudents();

    idCtrl.clear();
    nameCtrl.clear();
    courseCtrl.clear();
    yearCtrl.clear();
    emailCtrl.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Student enrolled!')),
    );

    Navigator.pop(context);
  }

  Widget makeField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Student'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fill in the information below:'),
              SizedBox(height: 20),

              makeField(
                label: 'Student ID',
                controller: idCtrl,
                validator: validateId,
              ),
              makeField(
                label: 'Full Name',
                controller: nameCtrl,
                validator: validateName,
              ),
              makeField(
                label: 'Course (example: BSIT)',
                controller: courseCtrl,
                validator: validateCourse,
              ),
              makeField(
                label: 'Year Level (1 to 4)',
                controller: yearCtrl,
                keyboard: TextInputType.number,
                validator: validateYear,
              ),
              makeField(
                label: 'Email Address',
                controller: emailCtrl,
                keyboard: TextInputType.emailAddress,
                validator: validateEmail,
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: enrollStudent,
                  child: Text('Enroll Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 13. STUDENT DETAILS SCREEN
// ============================================================
class StudentDetailsScreen extends StatefulWidget {
  StudentDetailsScreen({Key? key, required this.student}) : super(key: key);

  final Student student;

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  void openEdit() async {
    bool? saved = await showEditStudentModal(context, widget.student);
    if (saved == true) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student updated!')),
      );
    }
  }

  Widget row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: TextStyle(fontSize: 15, color: Colors.white70)),
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

  @override
  Widget build(BuildContext context) {
    Student s = widget.student;

    String name = 'Not provided';
    if (s.name != null) name = s.name!;

    String course = 'Unknown';
    if (s.courseSection != null) course = s.courseSection!;

    String hobby = 'Not provided';
    if (s.hobby != null) hobby = s.hobby!;

    String status = 'Inactive';
    Color statusColor = Colors.grey;
    if (s.status == 0) {
      status = 'Active';
      statusColor = Colors.green;
    }

    String enroll = 'Not enrolled';
    if (s.isStudent == true) enroll = 'Currently enrolled';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Student Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: openEdit,
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
                CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage(s.image),
                ),
                SizedBox(height: 16),

                Text(
                  name,
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
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 24),

                Card(
                  color: Colors.white.withOpacity(0.15),
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
                        row('Name', name),
                        row('Student ID', s.studentId),
                        row('Course & Section', course),
                        row('Status', status),
                        row('Age', s.age.toString()),
                        row('Birthdate', s.birthdate),
                        row('Email', s.email),
                        row('Favorite Subject', s.favoriteSubject),
                        row('Hobby', hobby),
                        row('Height', s.height.toString() + ' m'),
                        row('Enrollment', enroll),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: openEdit,
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
}

// ============================================================
// 14. PROFILE CARD
// ============================================================
class ProfileCard extends StatefulWidget {
  ProfileCard({
    Key? key,
    required this.student,
    this.onDelete,
    this.onTap,
    this.onEdit,
  }) : super(key: key);

  final Student student;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void askDelete() {
    String name = 'this student';
    if (widget.student.name != null) name = widget.student.name!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Student'),
          content: Text('Remove ' + name + '?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (widget.onDelete != null) {
                  widget.onDelete!();
                }
              },
              child: Text('Delete',
                  style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Student s = widget.student;

    String name = 'Not provided';
    if (s.name != null) name = s.name!;

    String course = 'Unknown';
    if (s.courseSection != null) course = s.courseSection!;

    String hobby = 'Not provided';
    if (s.hobby != null) hobby = s.hobby!;

    String status = 'Inactive';
    Color statusColor = Colors.grey;
    if (s.status == 0) {
      status = 'Active';
      statusColor = Colors.green;
    }

    String enroll = 'Not enrolled';
    if (s.isStudent == true) enroll = 'Currently enrolled';

    Color cardColor = Colors.white.withOpacity(0.15);
    if (isFavorite == true) {
      cardColor = Colors.amber.withOpacity(0.25);
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                  onPressed: askDelete,
                  child: Text('Remove',
                      style: TextStyle(color: Colors.white70)),
                ),
              ),

              Center(
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: AssetImage(s.image),
                ),
              ),
              SizedBox(height: 20),

              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),

              Text('Full Name: ' + name,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 10),

              Text('Course & Section: ' + course,
                  style: TextStyle(fontSize: 16, color: Colors.white70)),
              SizedBox(height: 8),

              Text('Hobby: ' + hobby,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 8),

              Text('Student ID: ' + s.studentId,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 8),

              Text('Email: ' + s.email,
                  style: TextStyle(fontSize: 16, color: Colors.white70)),
              SizedBox(height: 8),

              Text('Favorite Subject: ' + s.favoriteSubject,
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 8),

              Text('Height: ' + s.height.toString() + ' m',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 8),

              Text('Student Status: ' + enroll,
                  style: TextStyle(fontSize: 16, color: Colors.white)),

              Divider(color: Colors.white54, height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Age: ' + s.age.toString(),
                      style:
                      TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Birthdate: ' + s.birthdate,
                      style:
                      TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),

              Divider(color: Colors.white54, height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: toggleFavorite,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(isFavorite ? 'Favorited' : 'Favorite'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.onEdit != null) {
                          widget.onEdit!();
                        }
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