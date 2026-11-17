import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  /// Schedules of one subject, with the number of remaining slots.
  Future<List<Schedule>> getBySubject(int subjectId) async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
      Sql.named('''
        SELECT s.schedule_id, s.subject_id, s.day_of_week,
               to_char(s.start_time, 'HH24:MI') AS start_time,
               to_char(s.end_time, 'HH24:MI') AS end_time,
               s.room, s.slot_capacity,
               s.slot_capacity - (SELECT COUNT(*) FROM enrollment e
                   WHERE e.schedule_id = s.schedule_id AND e.status = 'Enrolled') AS remaining_slots
        FROM schedule s
        WHERE s.subject_id = @sid
        ORDER BY s.day_of_week, s.start_time
      '''),
      parameters: {'sid': subjectId},
    );
    return r.map((row) => Schedule.fromMap(row.toColumnMap())).toList();
  }

  Future<void> insert(Schedule s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('INSERT INTO schedule (subject_id, day_of_week, start_time, end_time, room, slot_capacity) '
          'VALUES (@sid, @day, @st::text::time, @et::text::time, @room, @cap)'),
      parameters: {
        'sid': s.subject_id,
        'day': s.day_of_week,
        'st': s.start_time,
        'et': s.end_time,
        'room': s.room,
        'cap': s.slot_capacity,
      },
    );
  }

  Future<void> update(Schedule s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE schedule SET day_of_week = @day, start_time = @st::text::time, '
          'end_time = @et::text::time, room = @room, slot_capacity = @cap '
          'WHERE schedule_id = @id'),
      parameters: {
        'day': s.day_of_week,
        'st': s.start_time,
        'et': s.end_time,
        'room': s.room,
        'cap': s.slot_capacity,
        'id': s.schedule_id,
      },
    );
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.get();
    await conn.execute(Sql.named('DELETE FROM schedule WHERE schedule_id = @id'),
        parameters: {'id': id});
  }
}
