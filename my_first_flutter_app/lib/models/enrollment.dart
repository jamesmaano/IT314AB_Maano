// ignore_for_file: non_constant_identifier_names
class Enrollment {
  final int? enrollment_id;
  final int student_id;
  final int subject_id;
  final int schedule_id;
  final String enrolled_at;
  final String status; // 'Enrolled' or 'Dropped'

  // Extra values joined from subject/schedule just for display.
  final String? subject_code;
  final String? subject_name;
  final String? day_of_week;
  final String? start_time;
  final String? end_time;
  final String? room;

  Enrollment({
    this.enrollment_id,
    required this.student_id,
    required this.subject_id,
    required this.schedule_id,
    required this.enrolled_at,
    required this.status,
    this.subject_code,
    this.subject_name,
    this.day_of_week,
    this.start_time,
    this.end_time,
    this.room,
  });

  factory Enrollment.fromMap(Map<String, dynamic> m) => Enrollment(
        enrollment_id: m['enrollment_id'] as int?,
        student_id: m['student_id'] as int,
        subject_id: m['subject_id'] as int,
        schedule_id: m['schedule_id'] as int,
        enrolled_at: m['enrolled_at'] as String,
        status: m['status'] as String,
        subject_code: m['subject_code'] as String?,
        subject_name: m['subject_name'] as String?,
        day_of_week: m['day_of_week'] as String?,
        start_time: m['start_time'] as String?,
        end_time: m['end_time'] as String?,
        room: m['room'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'student_id': student_id,
        'subject_id': subject_id,
        'schedule_id': schedule_id,
        'status': status,
      };
}
