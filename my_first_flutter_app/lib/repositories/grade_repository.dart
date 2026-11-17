import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../core/errors.dart';
import '../models/grade.dart';

class GradeRepository {
  Future<List<Grade>> getByStudent(int studentId) async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
      Sql.named('SELECT grade_id, student_id, subject, score::float8 AS score, enrollment_id '
          'FROM grades WHERE student_id = @sid ORDER BY grade_id'),
      parameters: {'sid': studentId},
    );
    return r.map((row) => Grade.fromMap(row.toColumnMap())).toList();
  }

  /// A grade can only be added for an EXISTING, active enrollment (one grade each).
  Future<void> add(int enrollmentId, double score) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      final e = await tx.execute(
        Sql.named('SELECT e.student_id, e.status, sub.subject_name FROM enrollment e '
            'JOIN subject sub ON sub.subject_id = e.subject_id WHERE e.enrollment_id = @id'),
        parameters: {'id': enrollmentId},
      );
      if (e.isEmpty) {
        throw AppException('An enrollment must exist before a grade can be added.');
      }
      final m = e.first.toColumnMap();
      if (m['status'] != 'Enrolled') {
        throw AppException('Cannot grade a dropped enrollment.');
      }
      final dup = await tx.execute(
        Sql.named('SELECT 1 FROM grades WHERE enrollment_id = @id'),
        parameters: {'id': enrollmentId},
      );
      if (dup.isNotEmpty) throw AppException('This enrollment already has a grade.');

      await tx.execute(
        Sql.named('INSERT INTO grades (grade_id, student_id, subject, score, enrollment_id) '
            'VALUES ((SELECT COALESCE(MAX(grade_id), 0) + 1 FROM grades), @sid, '
            'LEFT(@subj::text, 50), @score::float8, @eid)'),
        parameters: {
          'sid': m['student_id'],
          'subj': m['subject_name'],
          'score': score,
          'eid': enrollmentId,
        },
      );
    });
  }

  Future<void> update(int gradeId, double score) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE grades SET score = @score::float8 WHERE grade_id = @id'),
      parameters: {'score': score, 'id': gradeId},
    );
  }

  Future<void> delete(int gradeId) async {
    final conn = await DbConnection.get();
    await conn.execute(Sql.named('DELETE FROM grades WHERE grade_id = @id'),
        parameters: {'id': gradeId});
  }
}
