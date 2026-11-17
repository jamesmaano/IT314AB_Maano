import '../models/grade.dart';
import '../repositories/grade_repository.dart';
import 'base_view_model.dart';

class GradeViewModel extends BaseViewModel {
  final GradeRepository repo;
  GradeViewModel(this.repo);

  List<Grade> grades = [];

  Future<void> loadForStudent(int studentId) => load(() async {
        grades = await repo.getByStudent(studentId);
      });

  Future<bool> add(int studentId, int enrollmentId, double score) async {
    final ok = await run(() => repo.add(enrollmentId, score));
    if (ok) await loadForStudent(studentId);
    return ok;
  }

  Future<bool> update(int studentId, Grade g, double score) async {
    final ok = await run(() => repo.update(g.grade_id!, score));
    if (ok) await loadForStudent(studentId);
    return ok;
  }

  Future<bool> delete(int studentId, Grade g) async {
    final ok = await run(() => repo.delete(g.grade_id!));
    if (ok) await loadForStudent(studentId);
    return ok;
  }
}
