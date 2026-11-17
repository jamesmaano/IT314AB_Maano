import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../models/student.dart';
import 'common.dart';
import 'student_card.dart';
import 'student_form.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final searchCtrl = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    await studentVM.checkConnection(); // test query + success/failure feedback
    if (!mounted) return;
    showMessage(context, studentVM.connectionMessage, isError: studentVM.connected != true);
    if (studentVM.connected == true) await studentVM.loadStudents();
  }

  /// Search by name or student ID.
  List<Student> get filtered {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return studentVM.students;
    return studentVM.students
        .where((s) => s.name.toLowerCase().contains(q) || '${s.student_id}'.contains(q))
        .toList();
  }

  Future<void> goToAdd() async {
    final added = await Navigator.pushNamed(context, '/add-student');
    if (!mounted) return;
    if (added == true) showMessage(context, 'Student added!');
  }

  Future<void> goToDetails(Student s) async {
    final result = await Navigator.pushNamed(context, '/student-details', arguments: s);
    studentVM.refreshQuietly(); // enrollment count may have changed
    if (!mounted) return;
    if (result == 'deleted') showMessage(context, 'Student deleted!');
  }

  Future<void> openEdit(Student s) async {
    final saved = await showEditStudentModal(context, s);
    if (!mounted) return;
    if (saved == true) showMessage(context, 'Student updated!');
  }

  Future<void> deleteStudent(Student s) async {
    final yes = await confirmDialog(
        context, 'Delete Student', 'Remove ${s.name}? Their enrollments and grades will be deleted too.');
    if (!yes) return;
    final ok = await studentVM.delete(s);
    if (!mounted) return;
    showMessage(context, ok ? 'Student deleted!' : (studentVM.error ?? 'Delete failed'), isError: !ok);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: studentVM,
      builder: (context, _) {
        final list = filtered;
        return AppScaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            title: const Text('Student Directory'),
            actions: [
              Icon(
                studentVM.connected == true ? Icons.cloud_done : Icons.cloud_off,
                color: studentVM.connected == true ? Colors.white : Colors.red.shade100,
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _start),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: null,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            onPressed: goToAdd,
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: TextField(
                  controller: searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search by name or ID',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchCtrl.clear();
                              setState(() => query = '');
                            },
                          ),
                  ),
                  onChanged: (v) => setState(() => query = v),
                ),
              ),
              Expanded(
                child: StateView(
                  isLoading: studentVM.isLoading,
                  error: studentVM.loadError ?? (studentVM.connected == false ? studentVM.connectionMessage : null),
                  isEmpty: list.isEmpty,
                  emptyText: query.isEmpty ? 'No students found.' : 'No student matches "$query".',
                  onRetry: _start,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final s = list[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: StudentCard(
                          student: s,
                          programName: studentVM.programName(s.program_id),
                          onTap: () => goToDetails(s),
                          onEdit: () => openEdit(s),
                          onDelete: () => deleteStudent(s),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
