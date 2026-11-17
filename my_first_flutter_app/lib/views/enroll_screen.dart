// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../models/student.dart';
import 'common.dart';

/// Workflow: student (already selected) -> subject -> schedule -> validate -> save.
class EnrollScreen extends StatefulWidget {
  final Student student;
  const EnrollScreen({super.key, required this.student});

  @override
  State<EnrollScreen> createState() => _EnrollScreenState();
}

class _EnrollScreenState extends State<EnrollScreen> {
  int? subjectId;
  int? scheduleId;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    scheduleVM.clear();
    subjectVM.loadSubjects();
  }

  Future<void> enroll() async {
    if (subjectId == null || scheduleId == null) {
      showMessage(context, 'Select a subject and a schedule first', isError: true);
      return;
    }
    setState(() => saving = true);
    final ok = await enrollmentVM.enroll(widget.student.student_id!, subjectId!, scheduleId!);
    if (!mounted) return;
    setState(() => saving = false);
    if (ok) {
      Navigator.pop(context, true); // the previous screen shows the success message
    } else {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.error, color: Colors.red),
          title: const Text('Enrollment failed'),
          content: Text(enrollmentVM.error ?? 'Unknown error'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
        ),
      );
      if (subjectId != null) scheduleVM.loadForSubject(subjectId!); // refresh slots
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([subjectVM, scheduleVM]),
      builder: (context, _) {
        return AppScaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            title: Text('Enroll ${widget.student.name}'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              if (subjectVM.isLoading) const LinearProgressIndicator(),
              if (subjectVM.loadError != null) Text(subjectVM.loadError!, style: const TextStyle(color: Colors.red)),
              DropdownButtonFormField<int>(
                value: subjectId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Subject', border: OutlineInputBorder()),
                items: subjectVM.subjects
                    .map((s) => DropdownMenuItem(
                          value: s.subject_id,
                          child: Text('${s.subject_code} - ${s.subject_name}', overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    subjectId = v;
                    scheduleId = null;
                  });
                  if (v != null) scheduleVM.loadForSubject(v);
                },
              ),
              const SizedBox(height: 16),
              if (subjectId != null && scheduleVM.isLoading) const LinearProgressIndicator(),
              if (subjectId != null && !scheduleVM.isLoading && scheduleVM.schedules.isEmpty)
                const Text('This subject has no schedule yet. Add one in Subjects.'),
              if (subjectId != null && scheduleVM.schedules.isNotEmpty)
                DropdownButtonFormField<int>(
                  value: scheduleId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Schedule', border: OutlineInputBorder()),
                  items: scheduleVM.schedules
                      .map((s) => DropdownMenuItem(
                            value: s.schedule_id,
                            child: Text('${s.label}  (${s.remaining_slots} slots left)', overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => scheduleId = v),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saving ? null : enroll,
                child: Text(saving ? 'Saving...' : 'Enroll Student'),
              ),
            ],
          ),
        );
      },
    );
  }
}
