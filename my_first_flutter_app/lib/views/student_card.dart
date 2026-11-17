import 'package:flutter/material.dart';
import '../models/student.dart';
import 'common.dart';

/// Your original ProfileCard, now showing data from the database.
class StudentCard extends StatefulWidget {
  final Student student;
  final String programName;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentCard({
    super.key,
    required this.student,
    required this.programName,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    final enrolled = s.enrolledCount > 0;
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      foregroundColor: Colors.white,
    );

    return Card(
      color: isFavorite ? Colors.amber.withValues(alpha: 0.25) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: widget.onDelete,
                  child: const Text('Remove', style: TextStyle(color: Colors.white70)),
                ),
              ),
              CircleAvatar(radius: 55, backgroundImage: AssetImage(avatarFor(s.student_id))),
              const SizedBox(height: 12),
              Text(
                s.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('Student ID: ${s.student_id}', style: const TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 10),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  StatusChip(text: widget.programName, color: Colors.teal, icon: Icons.school),
                  StatusChip(
                    text: enrolled
                        ? 'Enrolled in ${s.enrolledCount} subject${s.enrolledCount == 1 ? '' : 's'}'
                        : 'Not enrolled',
                    color: enrolled ? Colors.green : Colors.grey,
                    icon: enrolled ? Icons.check_circle : Icons.remove_circle_outline,
                  ),
                ],
              ),
              const Divider(color: Colors.white54, height: 28),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: toggleFavorite,
                      style: buttonStyle,
                      child: Text(isFavorite ? 'Favorited' : 'Favorite'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onEdit,
                      style: buttonStyle,
                      child: const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
