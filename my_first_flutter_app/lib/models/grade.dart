// ignore_for_file: non_constant_identifier_names
// Matches the Neon table "grades".
class Grade {
  final int? grade_id;
  final int? student_id;
  String? subject;
  double score;
  final int? enrollment_id;

  Grade({this.grade_id, this.student_id, this.subject, required this.score, this.enrollment_id});

  factory Grade.fromMap(Map<String, dynamic> m) => Grade(
        grade_id: m['grade_id'] as int?,
        student_id: m['student_id'] as int?,
        subject: m['subject'] as String?,
        score: (m['score'] as num?)?.toDouble() ?? 0,
        enrollment_id: m['enrollment_id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'student_id': student_id,
        'subject': subject,
        'score': score,
        'enrollment_id': enrollment_id,
      };
}
