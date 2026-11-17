import '../models/enrollment.dart';
import '../repositories/enrollment_repository.dart';
import 'base_view_model.dart';

class EnrollmentViewModel extends BaseViewModel {
  final EnrollmentRepository repo;
  EnrollmentViewModel(this.repo);

  List<Enrollment> enrollments = [];

  Future<void> loadForStudent(int studentId) => load(() async {
        enrollments = await repo.getByStudent(studentId);
      });

  Future<bool> enroll(int studentId, int subjectId, int scheduleId) async {
    final ok = await run(() => repo.enroll(studentId, subjectId, scheduleId));
    if (ok) await loadForStudent(studentId);
    return ok;
  }

  Future<bool> changeSchedule(Enrollment e, int newScheduleId) async {
    final ok = await run(() => repo.changeSchedule(e, newScheduleId));
    if (ok) await loadForStudent(e.student_id);
    return ok;
  }

  Future<bool> drop(Enrollment e) async {
    final ok = await run(() => repo.drop(e.enrollment_id!));
    if (ok) await loadForStudent(e.student_id);
    return ok;
  }
}
