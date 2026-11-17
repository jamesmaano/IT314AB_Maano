// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../models/student.dart';
import 'common.dart';

/// Used for BOTH creating (AddStudentScreen) and editing (bottom sheet).
class StudentForm extends StatefulWidget {
  final Student? student; // null = create
  final bool isModal; // true = shown inside the Edit bottom sheet
  const StudentForm({super.key, this.student, this.isModal = false});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController nameCtrl;
  int? programId;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.student?.name ?? '');
    programId = widget.student?.program_id;
    // avoid a dropdown crash if the saved program is not in the list
    if (!studentVM.programs.any((p) => p.program_id == programId)) programId = null;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => saving = true);
    final name = nameCtrl.text.trim();
    final ok = widget.student == null
        ? await studentVM.add(name, programId)
        : await studentVM.update(widget.student!, name, programId);
    if (!mounted) return;
    setState(() => saving = false);
    if (ok) {
      Navigator.pop(context, true);
    } else {
      showMessage(context, studentVM.error ?? 'Could not save', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.student != null;
    final saveText = saving ? 'Saving...' : (isEdit ? 'Save Changes' : 'Add Student');

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isModal) ...[
            const Text('Edit Student', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
          ],
          if (isEdit) ...[
            Text('Student ID: ${widget.student!.student_id}', style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Full Name is required';
              if (v.trim().length > 100) return 'Name is too long (max 100)';
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            value: programId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Program', border: OutlineInputBorder()),
            items: studentVM.programs
                .map((p) => DropdownMenuItem(
                      value: p.program_id,
                      child: Text('${p.program_code} - ${p.program_name}', overflow: TextOverflow.ellipsis),
                    ))
                .toList(),
            onChanged: (v) => setState(() => programId = v),
            validator: (v) => v == null ? 'Select a program' : null,
          ),
          const SizedBox(height: 20),
          if (widget.isModal)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(onPressed: saving ? null : save, child: Text(saveText)),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: saving ? null : save, child: Text(saveText)),
            ),
        ],
      ),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(backgroundColor: Colors.teal, foregroundColor: Colors.white, title: const Text('Add Student')),
      body: const SingleChildScrollView(padding: EdgeInsets.all(20), child: StudentForm()),
    );
  }
}

/// Edit Student modal (dark bottom sheet like your original).
Future<bool?> showEditStudentModal(BuildContext context, Student student) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF2A2A2A),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(child: StudentForm(student: student, isModal: true)),
    ),
  );
}
