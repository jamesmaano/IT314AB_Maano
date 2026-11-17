// ignore_for_file: non_constant_identifier_names
class Subject {
  final int? subject_id;
  String subject_code;
  String subject_name;
  int units;
  String? description;

  Subject({
    this.subject_id,
    required this.subject_code,
    required this.subject_name,
    required this.units,
    this.description,
  });

  factory Subject.fromMap(Map<String, dynamic> m) => Subject(
        subject_id: m['subject_id'] as int?,
        subject_code: m['subject_code'] as String,
        subject_name: m['subject_name'] as String,
        units: m['units'] as int,
        description: m['description'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'subject_code': subject_code,
        'subject_name': subject_name,
        'units': units,
        'description': description,
      };
}
