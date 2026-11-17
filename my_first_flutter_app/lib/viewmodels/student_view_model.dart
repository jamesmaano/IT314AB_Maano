import '../core/db_connection.dart';
import '../core/errors.dart';
import '../models/student.dart';
import '../repositories/student_repository.dart';
import 'base_view_model.dart';

class StudentViewModel extends BaseViewModel {
  final StudentRepository repo;
  StudentViewModel(this.repo);

  List<Student> students = [];
  List<Program> programs = [];
  bool? connected; // null = not tested yet
  String connectionMessage = '';

  Future<void> checkConnection() async {
    try {
      connected = await DbConnection.test();
      connectionMessage = connected == true
          ? 'Connected to Neon database'
          : 'Connection test failed';
    } catch (e) {
      connected = false;
      connectionMessage = 'Connection failed: ${friendlyError(e)}';
    }
    notifyListeners();
  }

  Future<void> loadStudents() => load(() async {
        students = await repo.getAll();
        programs = await repo.getPrograms();
      });

  String programName(int? id) {
    if (id == null) return 'No program';
    for (final p in programs) {
      if (p.program_id == id) return p.program_code;
    }
    return 'Program $id';
  }

  String programFullName(int? id) {
    if (id == null) return 'No program';
    for (final p in programs) {
      if (p.program_id == id) return '${p.program_code} - ${p.program_name}';
    }
    return 'Program $id';
  }

  /// Reloads the list WITHOUT the full-screen spinner (used when coming back from details).
  Future<void> refreshQuietly() async {
    try {
      students = await repo.getAll();
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> add(String name, int? programId) async {
    final ok = await run(() => repo.insert(Student(name: name, program_id: programId)));
    if (ok) await loadStudents();
    return ok;
  }

  Future<bool> update(Student s, String name, int? programId) async {
    final ok = await run(() => repo.update(
        Student(student_id: s.student_id, name: name, program_id: programId)));
    if (ok) await loadStudents();
    return ok;
  }

  Future<bool> delete(Student s) async {
    final ok = await run(() => repo.delete(s.student_id!));
    if (ok) await loadStudents();
    return ok;
  }
}
