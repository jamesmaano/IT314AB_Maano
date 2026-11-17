import '../repositories/student_repository.dart';
import '../repositories/subject_repository.dart';
import '../repositories/schedule_repository.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/grade_repository.dart';
import '../viewmodels/student_view_model.dart';
import '../viewmodels/subject_view_model.dart';
import '../viewmodels/schedule_view_model.dart';
import '../viewmodels/enrollment_view_model.dart';
import '../viewmodels/grade_view_model.dart';

// One ViewModel per table, shared by the whole app.
final studentVM = StudentViewModel(StudentRepository());
final subjectVM = SubjectViewModel(SubjectRepository());
final scheduleVM = ScheduleViewModel(ScheduleRepository());
final enrollmentVM = EnrollmentViewModel(EnrollmentRepository());
final gradeVM = GradeViewModel(GradeRepository());
