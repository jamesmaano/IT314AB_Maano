import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../core/errors.dart';
import '../models/enrollment.dart';

class EnrollmentRepository {
  Future<List<Enrollment>> getByStudent(int studentId) async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
      Sql.named('''
        SELECT e.enrollment_id, e.student_id, e.subject_id, e.schedule_id,
               to_char(e.enrolled_at, 'YYYY-MM-DD HH24:MI') AS enrolled_at, e.status,
               sub.subject_code, sub.subject_name, sc.day_of_week,
               to_char(sc.start_time, 'HH24:MI') AS start_time,
               to_char(sc.end_time, 'HH24:MI') AS end_time, sc.room
        FROM enrollment e
        JOIN subject sub ON sub.subject_id = e.subject_id
        JOIN schedule sc ON sc.schedule_id = e.schedule_id
        WHERE e.student_id = @sid
        ORDER BY e.enrollment_id
      '''),
      parameters: {'sid': studentId},
    );
    return r.map((row) => Enrollment.fromMap(row.toColumnMap())).toList();
  }

  /// Enrollment workflow: duplicate check -> slots -> schedule conflict -> save.
  /// Everything runs in ONE transaction; any error cancels the whole thing.
  Future<void> enroll(int studentId, int subjectId, int scheduleId) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      final existing = await tx.execute(
        Sql.named('SELECT enrollment_id, status FROM enrollment '
            'WHERE student_id = @sid AND subject_id = @sub'),
        parameters: {'sid': studentId, 'sub': subjectId},
      );

      int? existingId;
      if (existing.isNotEmpty) {
        final m = existing.first.toColumnMap();
        if (m['status'] == 'Enrolled') {
          throw AppException('This student is already enrolled in this subject.');
        }
        existingId = m['enrollment_id'] as int; // a Dropped one: re-activate it
      }

      await _validate(tx,
          studentId: studentId,
          subjectId: subjectId,
          scheduleId: scheduleId,
          ignoreEnrollmentId: existingId);

      if (existingId != null) {
        await tx.execute(
          Sql.named("UPDATE enrollment SET status = 'Enrolled', schedule_id = @sch, "
              'enrolled_at = CURRENT_TIMESTAMP WHERE enrollment_id = @id'),
          parameters: {'sch': scheduleId, 'id': existingId},
        );
      } else {
        await tx.execute(
          Sql.named("INSERT INTO enrollment (student_id, subject_id, schedule_id, status) "
              "VALUES (@sid, @sub, @sch, 'Enrolled')"),
          parameters: {'sid': studentId, 'sub': subjectId, 'sch': scheduleId},
        );
      }
    });
  }

  Future<void> changeSchedule(Enrollment e, int newScheduleId) async {
    final conn = await DbConnection.get();
    await conn.runTx((tx) async {
      await _validate(tx,
          studentId: e.student_id,
          subjectId: e.subject_id,
          scheduleId: newScheduleId,
          ignoreEnrollmentId: e.enrollment_id);
      await tx.execute(
        Sql.named('UPDATE enrollment SET schedule_id = @sch WHERE enrollment_id = @id'),
        parameters: {'sch': newScheduleId, 'id': e.enrollment_id},
      );
    });
  }

  /// Drop = keep the row but set status to 'Dropped'.
  Future<void> drop(int enrollmentId) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named("UPDATE enrollment SET status = 'Dropped' WHERE enrollment_id = @id"),
      parameters: {'id': enrollmentId},
    );
  }

  // ---- shared business rules ----
  Future<void> _validate(
    Session s, {
    required int studentId,
    required int subjectId,
    required int scheduleId,
    int? ignoreEnrollmentId,
  }) async {
    // 1. the schedule must exist and belong to the subject
    final sch = await s.execute(
      Sql.named("SELECT subject_id, day_of_week, to_char(start_time, 'HH24:MI:SS') AS st, "
          "to_char(end_time, 'HH24:MI:SS') AS et, slot_capacity "
          'FROM schedule WHERE schedule_id = @id'),
      parameters: {'id': scheduleId},
    );
    if (sch.isEmpty) throw AppException('Schedule not found.');
    final m = sch.first.toColumnMap();
    if (m['subject_id'] != subjectId) {
      throw AppException('That schedule does not belong to the selected subject.');
    }

    // 2. remaining slots
    final cnt = await s.execute(
      Sql.named("SELECT COUNT(*) FROM enrollment WHERE schedule_id = @sch AND status = 'Enrolled' "
          'AND (@ign::int IS NULL OR enrollment_id <> @ign::int)'),
      parameters: {'sch': scheduleId, 'ign': ignoreEnrollmentId},
    );
    final taken = cnt.first.first as int;
    if (taken >= (m['slot_capacity'] as int)) {
      throw AppException('No slots left in this schedule (it is full).');
    }

    // 3. schedule conflict with the student's other active enrollments
    final conflict = await s.execute(
      Sql.named('''
        SELECT sub.subject_code FROM enrollment e
        JOIN schedule sc ON sc.schedule_id = e.schedule_id
        JOIN subject sub ON sub.subject_id = e.subject_id
        WHERE e.student_id = @sid AND e.status = 'Enrolled'
          AND sc.day_of_week = @day
          AND sc.start_time < @et::text::time AND sc.end_time > @st::text::time
          AND (@ign::int IS NULL OR e.enrollment_id <> @ign::int)
        LIMIT 1
      '''),
      parameters: {
        'sid': studentId,
        'day': m['day_of_week'],
        'st': m['st'],
        'et': m['et'],
        'ign': ignoreEnrollmentId,
      },
    );
    if (conflict.isNotEmpty) {
      throw AppException(
          'Schedule conflict with ${conflict.first.first} (same day, overlapping time).');
    }
  }
}
