// ignore_for_file: non_constant_identifier_names
class Schedule {
  final int? schedule_id;
  int subject_id;
  String day_of_week;
  String start_time; // "HH:MM"
  String end_time; // "HH:MM"
  String room;
  int slot_capacity;
  int? remaining_slots; // calculated by the query, not a table column

  Schedule({
    this.schedule_id,
    required this.subject_id,
    required this.day_of_week,
    required this.start_time,
    required this.end_time,
    required this.room,
    required this.slot_capacity,
    this.remaining_slots,
  });

  factory Schedule.fromMap(Map<String, dynamic> m) => Schedule(
        schedule_id: m['schedule_id'] as int?,
        subject_id: m['subject_id'] as int,
        day_of_week: m['day_of_week'] as String,
        start_time: m['start_time'] as String,
        end_time: m['end_time'] as String,
        room: m['room'] as String,
        slot_capacity: m['slot_capacity'] as int,
        remaining_slots: m['remaining_slots'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'subject_id': subject_id,
        'day_of_week': day_of_week,
        'start_time': start_time,
        'end_time': end_time,
        'room': room,
        'slot_capacity': slot_capacity,
      };

  String get label => '$day_of_week $start_time-$end_time, Room $room';
}
