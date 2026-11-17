import '../models/schedule.dart';
import '../repositories/schedule_repository.dart';
import 'base_view_model.dart';

class ScheduleViewModel extends BaseViewModel {
  final ScheduleRepository repo;
  ScheduleViewModel(this.repo);

  List<Schedule> schedules = [];
  int? currentSubjectId;

  void clear() {
    schedules = [];
    currentSubjectId = null;
    notifyListeners();
  }

  Future<void> loadForSubject(int subjectId) {
    currentSubjectId = subjectId;
    return load(() async {
      schedules = await repo.getBySubject(subjectId);
    });
  }

  Future<bool> add(Schedule s) async {
    final ok = await run(() => repo.insert(s));
    if (ok) await loadForSubject(s.subject_id);
    return ok;
  }

  Future<bool> update(Schedule s) async {
    final ok = await run(() => repo.update(s));
    if (ok) await loadForSubject(s.subject_id);
    return ok;
  }

  Future<bool> delete(Schedule s) async {
    final ok = await run(() => repo.delete(s.schedule_id!));
    if (ok) await loadForSubject(s.subject_id);
    return ok;
  }
}
