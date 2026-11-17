// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../core/locator.dart';
import '../models/schedule.dart';
import '../models/subject.dart';
import 'common.dart';

/// Shows one subject and manages its schedules (create / read / update / delete).
class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;
  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  int get id => widget.subject.subject_id!;

  @override
  void initState() {
    super.initState();
    scheduleVM.loadForSubject(id);
  }

  Future<void> delete(Schedule s) async {
    final yes = await confirmDialog(context, 'Delete Schedule', 'Delete ${s.label}?');
    if (!yes) return;
    final ok = await scheduleVM.delete(s);
    if (!mounted) return;
    showMessage(context, ok ? 'Schedule deleted' : (scheduleVM.error ?? 'Failed'), isError: !ok);
  }

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    return ListenableBuilder(
      listenable: scheduleVM,
      builder: (context, _) {
        return AppScaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            title: Text(subject.subject_code),
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Add Schedule'),
            onPressed: () => showScheduleDialog(context, id),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('${subject.subject_name}\n${subject.units} units\n${subject.description ?? ''}',
                    style: const TextStyle(fontSize: 16)),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Schedules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: StateView(
                  isLoading: scheduleVM.isLoading,
                  error: scheduleVM.loadError,
                  isEmpty: scheduleVM.schedules.isEmpty,
                  emptyText: 'No schedules yet.',
                  onRetry: () => scheduleVM.loadForSubject(id),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: scheduleVM.schedules.length,
                    itemBuilder: (context, i) {
                      final s = scheduleVM.schedules[i];
                      return Card(
                        child: ListTile(
                          title: Text('${s.day_of_week}  ${s.start_time}-${s.end_time}'),
                          subtitle: Text('Room ${s.room}  |  ${s.remaining_slots} of ${s.slot_capacity} slots left'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit), onPressed: () => showScheduleDialog(context, id, schedule: s)),
                              IconButton(icon: const Icon(Icons.delete), onPressed: () => delete(s)),
                            ],
                          ),
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

const _days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
final _timePattern = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

/// Add (schedule == null) or edit a schedule.
Future<void> showScheduleDialog(BuildContext context, int subjectId, {Schedule? schedule}) async {
  final formKey = GlobalKey<FormState>();
  final startCtrl = TextEditingController(text: schedule?.start_time ?? '');
  final endCtrl = TextEditingController(text: schedule?.end_time ?? '');
  final roomCtrl = TextEditingController(text: schedule?.room ?? '');
  final capCtrl = TextEditingController(text: schedule?.slot_capacity.toString() ?? '');
  String? day = schedule?.day_of_week;
  String? dialogError;

  await showDialog(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => AlertDialog(
        title: Text(schedule == null ? 'Add Schedule' : 'Edit Schedule'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: day,
                  decoration: const InputDecoration(labelText: 'Day'),
                  items: _days.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (v) => setS(() => day = v),
                  validator: (v) => v == null ? 'Select a day' : null,
                ),
                TextFormField(
                  controller: startCtrl,
                  decoration: const InputDecoration(labelText: 'Start time (HH:MM, 24-hour)'),
                  validator: (v) => _timePattern.hasMatch((v ?? '').trim()) ? null : 'Use HH:MM, e.g. 08:30',
                ),
                TextFormField(
                  controller: endCtrl,
                  decoration: const InputDecoration(labelText: 'End time (HH:MM, 24-hour)'),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (!_timePattern.hasMatch(t)) return 'Use HH:MM, e.g. 10:00';
                    if (t.compareTo(startCtrl.text.trim()) <= 0) return 'End time must be later than start time';
                    return null;
                  },
                ),
                TextFormField(
                  controller: roomCtrl,
                  decoration: const InputDecoration(labelText: 'Room'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Room is required' : null,
                ),
                TextFormField(
                  controller: capCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Slot capacity'),
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n <= 0) return 'Capacity must be a number above 0';
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
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final s = Schedule(
                schedule_id: schedule?.schedule_id,
                subject_id: subjectId,
                day_of_week: day!,
                start_time: startCtrl.text.trim(),
                end_time: endCtrl.text.trim(),
                room: roomCtrl.text.trim(),
                slot_capacity: int.parse(capCtrl.text.trim()),
              );
              final ok = schedule == null ? await scheduleVM.add(s) : await scheduleVM.update(s);
              if (ok) {
                if (ctx.mounted) Navigator.pop(ctx);
              } else {
                setS(() => dialogError = scheduleVM.error);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
  disposeLater([startCtrl, endCtrl, roomCtrl, capCtrl]);
}
