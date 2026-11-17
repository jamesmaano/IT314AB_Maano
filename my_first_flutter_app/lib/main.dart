import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/student.dart';
import 'models/subject.dart';
import 'views/enroll_screen.dart';
import 'views/home_screen.dart';
import 'views/student_details_screen.dart';
import 'views/student_form.dart';
import 'views/subject_details_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env'); // reads DB_HOST, DB_NAME, DB_USER, DB_PASS
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enrollment System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.teal, foregroundColor: Colors.white),
        cardTheme: CardThemeData(
          color: Colors.white.withValues(alpha: 0.15),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.06),
          border: const OutlineInputBorder(),
        ),
        navigationBarTheme: NavigationBarThemeData(backgroundColor: Colors.black.withValues(alpha: 0.7)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add-student': (context) => const AddStudentScreen(),
      },
      // Screens that receive data through Navigator arguments.
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/student-details':
            final student = settings.arguments as Student;
            return MaterialPageRoute(builder: (_) => StudentDetailsScreen(student: student));
          case '/enroll':
            final student = settings.arguments as Student;
            return MaterialPageRoute(builder: (_) => EnrollScreen(student: student));
          case '/subject-details':
            final subject = settings.arguments as Subject;
            return MaterialPageRoute(builder: (_) => SubjectDetailsScreen(subject: subject));
        }
        return null;
      },
    );
  }
}
