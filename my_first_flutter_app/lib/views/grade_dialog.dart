// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../models/grade.dart';
import '../models/student.dart';
import 'common.dart';

/// Add (grade == null) or edit a grade.
Future<void> showGradeDialog(BuildContext context, Student student, {Grade? grade}) async {
  final scoreCtrl = TextEditingController(text: grade == null ? '' : grade.score.toString());
  final formKey = GlobalKey<FormState>();
  int? enrollmentId;
  String? dialogError;

  // Only active enrollments that do not have a grade yet can be graded.
  final gradedIds = gradeVM.grades.map((g) => g.enrollment_id).toSet();
  final options = enrollmentVM.enrollments
      .where((e) => e.status == 'Enrolled' && !gradedIds.contains(e.enrollment_id))
      .toList();

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text(grade == null ? 'Add Grade' : 'Edit Grade'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (grade == null)
                DropdownButtonFormField<int>(
                  value: enrollmentId,
                  isExpanded: true,
                  hint: const Text('Select enrolled subject'),
                  items: options
                      .map((e) => DropdownMenuItem(
                            value: e.enrollment_id,
                            child: Text('${e.subject_code} - ${e.subject_name}', overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (v) => setS(() => enrollmentId = v),
                  validator: (v) => v == null ? 'Select an enrolled subject first' : null,
                )
              else
                Align(alignment: Alignment.centerLeft, child: Text(grade.subject ?? '')),
              const SizedBox(height: 12),
              TextFormField(
                controller: scoreCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Score (0 to 100)', border: OutlineInputBorder()),
                validator: (v) {
                  final n = double.tryParse((v ?? '').trim());
                  if (n == null) return 'Enter a number';
                  if (n < 0 || n > 100) return 'Score must be from 0 to 100';
                  return null;
                },
              ),
              if (dialogError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(dialogError!, style: const TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final score = double.parse(scoreCtrl.text.trim());
              final ok = grade == null
                  ? await gradeVM.add(student.student_id!, enrollmentId!, score)
                  : await gradeVM.update(student.student_id!, grade, score);
              if (ok) {
                if (ctx.mounted) Navigator.pop(ctx);
              } else {
                setS(() => dialogError = gradeVM.error);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  disposeLater([scoreCtrl]);
}
