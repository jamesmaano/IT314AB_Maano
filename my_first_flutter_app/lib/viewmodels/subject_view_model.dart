import '../models/subject.dart';
import '../repositories/subject_repository.dart';
import 'base_view_model.dart';

class SubjectViewModel extends BaseViewModel {
  final SubjectRepository repo;
  SubjectViewModel(this.repo);

  List<Subject> subjects = [];

  Future<void> loadSubjects() => load(() async {
        subjects = await repo.getAll();
      });

  Future<bool> add(Subject s) async {
    final ok = await run(() => repo.insert(s));
    if (ok) await loadSubjects();
    return ok;
  }

  Future<bool> update(Subject s) async {
    final ok = await run(() => repo.update(s));
    if (ok) await loadSubjects();
    return ok;
  }

  Future<bool> delete(Subject s) async {
    final ok = await run(() => repo.delete(s.subject_id!));
    if (ok) await loadSubjects();
    return ok;
  }
}
