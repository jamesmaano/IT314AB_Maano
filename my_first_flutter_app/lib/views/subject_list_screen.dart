import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../models/subject.dart';
import 'common.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  @override
  void initState() {
    super.initState();
    subjectVM.loadSubjects();
  }

  Future<void> delete(Subject s) async {
    final yes = await confirmDialog(context, 'Delete Subject', 'Delete ${s.subject_code}?');
    if (!yes) return;
    final ok = await subjectVM.delete(s);
    if (!mounted) return;
    showMessage(context, ok ? 'Subject deleted' : (subjectVM.error ?? 'Failed'), isError: !ok);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: subjectVM,
      builder: (context, _) {
        return AppScaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            title: const Text('Subjects'),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            onPressed: () => showSubjectDialog(context),
            child: const Icon(Icons.add),
          ),
          body: StateView(
            isLoading: subjectVM.isLoading,
            error: subjectVM.loadError,
            isEmpty: subjectVM.subjects.isEmpty,
            emptyText: 'No subjects yet. Tap + to add one.',
            onRetry: subjectVM.loadSubjects,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: subjectVM.subjects.length,
              itemBuilder: (context, i) {
                final s = subjectVM.subjects[i];
                return Card(
                  child: ListTile(
                    title: Text('${s.subject_code} - ${s.subject_name}'),
                    subtitle: Text('${s.units} units'),
                    onTap: () => Navigator.pushNamed(context, '/subject-details', arguments: s),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => showSubjectDialog(context, subject: s)),
                        IconButton(icon: const Icon(Icons.delete), onPressed: () => delete(s)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Add (subject == null) or edit a subject.
Future<void> showSubjectDialog(BuildContext context, {Subject? subject}) async {
  final formKey = GlobalKey<FormState>();
  final codeCtrl = TextEditingController(text: subject?.subject_code ?? '');
  final nameCtrl = TextEditingController(text: subject?.subject_name ?? '');
  final unitsCtrl = TextEditingController(text: subject?.units.toString() ?? '');
  final descCtrl = TextEditingController(text: subject?.description ?? '');
  String? dialogError;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text(subject == null ? 'Add Subject' : 'Edit Subject'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: codeCtrl,
                  decoration: const InputDecoration(labelText: 'Subject Code'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Subject code is required' : null,
                ),
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Subject Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Subject name is required' : null,
                ),
                TextFormField(
                  controller: unitsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Units (1 to 6)'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null) return 'Units must be a number';
                    if (n < 1 || n > 6) return 'Units must be from 1 to 6';
                    return null;
                  },
                ),
                TextFormField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description (optional)')),
                if (dialogError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(dialogError!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final desc = descCtrl.text.trim();
              final s = Subject(
                subject_id: subject?.subject_id,
                subject_code: codeCtrl.text.trim(),
                subject_name: nameCtrl.text.trim(),
                units: int.parse(unitsCtrl.text.trim()),
                description: desc.isEmpty ? null : desc,
              );
              final ok = subject == null ? await subjectVM.add(s) : await subjectVM.update(s);
              if (ok) {
                if (ctx.mounted) Navigator.pop(ctx);
              } else {
                setS(() => dialogError = subjectVM.error);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  disposeLater([codeCtrl, nameCtrl, unitsCtrl, descCtrl]);
}
