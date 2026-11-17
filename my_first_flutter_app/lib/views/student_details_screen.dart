// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../models/enrollment.dart';
import '../models/student.dart';
import 'common.dart';
import 'grade_dialog.dart';
import 'student_form.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  int get id => widget.student.student_id!;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    await enrollmentVM.loadForStudent(id);
    await gradeVM.loadForStudent(id);
  }

  Student currentStudent() {
    for (final s in studentVM.students) {
      if (s.student_id == id) return s;
    }
    return widget.student;
  }

  Future<void> edit() async {
    final saved = await showEditStudentModal(context, currentStudent());
    if (saved == true && mounted) showMessage(context, 'Student updated!');
  }

  Future<void> delete() async {
    final s = currentStudent();
    final yes = await confirmDialog(context, 'Delete Student',
        'Delete ${s.name}? Their enrollments and grades will be deleted too.');
    if (!yes) return;
    final ok = await studentVM.delete(s);
    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, 'deleted'); // the list screen shows "Student deleted!"
    } else {
      showMessage(context, studentVM.error ?? 'Delete failed', isError: true);
    }
  }

  Future<void> drop(Enrollment e) async {
    final yes = await confirmDialog(context, 'Drop Subject', 'Drop ${e.subject_code}?');
    if (!yes) return;
    final ok = await enrollmentVM.drop(e);
    if (!mounted) return;
    showMessage(context, ok ? 'Subject dropped' : (enrollmentVM.error ?? 'Failed'), isError: !ok);
  }

  Future<void> changeSchedule(Enrollment e) async {
    await scheduleVM.loadForSubject(e.subject_id);
    if (!mounted) return;
    int? chosen;
    String? dialogError;
    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text('Change schedule: ${e.subject_code}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                value: chosen,
                isExpanded: true,
                hint: const Text('Select new schedule'),
                items: scheduleVM.schedules
                    .where((s) => s.schedule_id != e.schedule_id)
                    .map((s) => DropdownMenuItem(
                          value: s.schedule_id,
                          child: Text('${s.label} (${s.remaining_slots} left)', overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (v) => setS(() => chosen = v),
              ),
              if (dialogError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(dialogError!, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: chosen == null
                  ? null
                  : () async {
                      final ok = await enrollmentVM.changeSchedule(e, chosen!);
                      if (ok) {
                        if (ctx.mounted) Navigator.pop(ctx);
                      } else {
                        setS(() => dialogError = enrollmentVM.error);
                      }
                    },
              child: const Text('Change'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([studentVM, enrollmentVM, gradeVM]),
      builder: (context, _) {
        final s = currentStudent();
        final activeCount = enrollmentVM.enrollments.where((e) => e.status == 'Enrolled').length;
        return AppScaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            title: const Text('Student Details'),
            actions: [
              IconButton(icon: const Icon(Icons.edit), onPressed: edit),
              IconButton(icon: const Icon(Icons.delete), onPressed: delete),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: CircleAvatar(radius: 70, backgroundImage: AssetImage(avatarFor(s.student_id))),
              ),
              const SizedBox(height: 14),
              Text(
                s.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (!enrollmentVM.isLoading)
                Center(
                  child: StatusChip(
                    text: activeCount > 0
                        ? 'Enrolled in $activeCount subject${activeCount == 1 ? '' : 's'}'
                        : 'Not enrolled',
                    color: activeCount > 0 ? Colors.green : Colors.grey,
                    icon: activeCount > 0 ? Icons.check_circle : Icons.remove_circle_outline,
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Student Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Divider(color: Colors.white54),
                      InfoRow('Student ID', '${s.student_id}'),
                      InfoRow('Name', s.name),
                      InfoRow('Program', studentVM.programFullName(s.program_id)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Expanded(
                    child: Text('Enrolled Subjects', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Enroll'),
                    onPressed: () async {
                      final enrolled = await Navigator.pushNamed(context, '/enroll', arguments: s);
                      await reload();
                      if (enrolled == true && mounted) showMessage(context, 'Enrollment successful!');
                    },
                  ),
                ],
              ),
              if (enrollmentVM.isLoading)
                const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator()))
              else if (enrollmentVM.loadError != null)
                Text(enrollmentVM.loadError!, style: const TextStyle(color: Colors.red))
              else if (enrollmentVM.enrollments.isEmpty)
                const Padding(padding: EdgeInsets.all(16), child: Text('Not enrolled in any subject yet.'))
              else
                ...enrollmentVM.enrollments.map((e) {
                  final active = e.status == 'Enrolled';
                  return Card(
                    child: ListTile(
                      title: Text('${e.subject_code} - ${e.subject_name}'),
                      subtitle: Text('${e.day_of_week} ${e.start_time}-${e.end_time}, Room ${e.room}\nStatus: ${e.status}'),
                      isThreeLine: true,
                      leading: Icon(active ? Icons.check_circle : Icons.cancel, color: active ? Colors.green : Colors.grey),
                      trailing: active
                          ? PopupMenuButton<String>(
                              onSelected: (v) => v == 'drop' ? drop(e) : changeSchedule(e),
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'change', child: Text('Change schedule')),
                                PopupMenuItem(value: 'drop', child: Text('Drop')),
                              ],
                            )
                          : null,
                    ),
                  );
                }),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text('Grades', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Grade'),
                    onPressed: () => showGradeDialog(context, s),
                  ),
                ],
              ),
              if (gradeVM.grades.isEmpty)
                const Padding(padding: EdgeInsets.all(16), child: Text('No grades yet.'))
              else
                ...gradeVM.grades.map((g) => Card(
                      child: ListTile(
                        title: Text(g.subject ?? 'Subject'),
                        subtitle: Text('Score: ${g.score}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => showGradeDialog(context, s, grade: g)),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final yes = await confirmDialog(context, 'Delete Grade', 'Delete this grade?');
                                if (!yes) return;
                                final ok = await gradeVM.delete(id, g);
                                if (!context.mounted) return;
                                showMessage(context, ok ? 'Grade deleted' : (gradeVM.error ?? 'Failed'), isError: !ok);
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }
}
