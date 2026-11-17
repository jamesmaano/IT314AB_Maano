import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/subject.dart';

class SubjectRepository {
  Future<List<Subject>> getAll() async {
    final conn = await DbConnection.get();
    final r = await conn.execute(
        'SELECT subject_id, subject_code, subject_name, units, description '
        'FROM subject ORDER BY subject_code');
    return r.map((row) => Subject.fromMap(row.toColumnMap())).toList();
  }

  Future<void> insert(Subject s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('INSERT INTO subject (subject_code, subject_name, units, description) '
          'VALUES (@code, @name, @units, @desc)'),
      parameters: {'code': s.subject_code, 'name': s.subject_name, 'units': s.units, 'desc': s.description},
    );
  }

  Future<void> update(Subject s) async {
    final conn = await DbConnection.get();
    await conn.execute(
      Sql.named('UPDATE subject SET subject_code = @code, subject_name = @name, '
          'units = @units, description = @desc WHERE subject_id = @id'),
      parameters: {
        'code': s.subject_code,
        'name': s.subject_name,
        'units': s.units,
        'desc': s.description,
        'id': s.subject_id,
      },
    );
  }

  Future<void> delete(int id) async {
    final conn = await DbConnection.get();
    await conn.execute(Sql.named('DELETE FROM subject WHERE subject_id = @id'),
        parameters: {'id': id});
  }
}
