// ignore_for_file: non_constant_identifier_names
// Field names are the SAME as the Neon table "students".
class Student {
  final int? student_id;
  String name;
  int? program_id;
  final int enrolledCount; // calculated by the query, not a table column

  Student({this.student_id, required this.name, this.program_id, this.enrolledCount = 0});

  factory Student.fromMap(Map<String, dynamic> m) => Student(
        student_id: m['student_id'] as int?,
        name: m['name'] as String,
        program_id: m['program_id'] as int?,
        enrolledCount: (m['enrolled_count'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {'name': name, 'program_id': program_id};
}

/// Table "programs" (used by the program dropdown).
class Program {
  final int program_id;
  final String program_code;
  final String program_name;

  Program({required this.program_id, required this.program_code, required this.program_name});

  factory Program.fromMap(Map<String, dynamic> m) => Program(
        program_id: m['program_id'] as int,
        program_code: m['program_code'] as String,
        program_name: m['program_name'] as String,
      );
}
