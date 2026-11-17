import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/student.dart';

/// The ONLY place that runs SQL for students/programs.
class StudentRepository {
  Future<List<Student>> getAll() async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
        'SELECT s.student_id, s.name, s.program_id, '
        "(SELECT COUNT(*)::int FROM enrollment e WHERE e.student_id = s.student_id AND e.status = 'Enrolled') AS enrolled_count "
        'FROM students s ORDER BY s.name');
    return r.map((row) => Student.fromMap(row.toColumnMap())).toList();
  }

  Future<List<Program>> getPrograms() async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
        'SELECT program_id, program_code, program_name FROM programs ORDER BY program_code');
    return r.map((row) => Program.fromMap(row.toColumnMap())).toList();
  }

  Future<void> insert(Student s) async {
    final conn = await DbConnection.get();
    // MAX+1 works whether or not student_id has an auto-increment default.
    await conn.execute(
      Sql.named('INSERT INTO students (student_id, name, program_id) '
          'VALUES ((SELECT COALESCE(MAX(student_id), 1000) + 1 FROM students), @name, @pid)'),
      parameters: {'name': s.name, 'pid': s.program_id},
    );
  }

  Future<void> update(Student s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE students SET name = @name, program_id = @pid WHERE student_id = @id'),
      parameters: {'name': s.name, 'pid': s.program_id, 'id': s.student_id},
    );
  }

  /// Deletes the student together with its grades and enrollments (one transaction).
  Future<void> delete(int id) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      await tx.execute(
          Sql.named('DELETE FROM grades WHERE student_id = @id OR enrollment_id IN '
              '(SELECT enrollment_id FROM enrollment WHERE student_id = @id)'),
          parameters: {'id': id});
      await tx.execute(Sql.named('DELETE FROM enrollment WHERE student_id = @id'),
          parameters: {'id': id});
      await tx.execute(Sql.named('DELETE FROM students WHERE student_id = @id'),
          parameters: {'id': id});
    });
  }
}
