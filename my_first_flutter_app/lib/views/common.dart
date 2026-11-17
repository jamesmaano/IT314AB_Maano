import 'package:flutter/material.dart';

/// Profile pictures from your assets folder (picked by student id, so each student keeps the same picture).
const kAvatars = [
  'assets/OIP (1).jpg',
  'assets/alright.jpg',
  'assets/chopper.jpg',
  'assets/broke.jpg',
  'assets/zoro.jpg',
  'assets/rebon.jpg',
];

String avatarFor(int? id) => id == null ? kAvatars[0] : kAvatars[id % kAvatars.length];

void showMessage(BuildContext context, String text, {bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
  ));
}

Future<bool> confirmDialog(BuildContext context, String title, String message) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Yes')),
      ],
    ),
  );
  return result == true;
}

/// Dispose text controllers AFTER a dialog's closing animation has finished
/// (disposing right after showDialog returns can crash the fading-out dialog).
void disposeLater(List<TextEditingController> controllers) {
  Future.delayed(const Duration(milliseconds: 600), () {
    for (final c in controllers) {
      c.dispose();
    }
  });
}

/// Your background.jpg with a dark layer on top, used by every screen.
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/background.jpg'), fit: BoxFit.cover),
      ),
      child: Container(color: Colors.black.withValues(alpha: 0.5), child: child),
    );
  }
}

/// A Scaffold that sits on top of [AppBackground].
class AppScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

/// Small rounded label (program, enrollment status, ...).
class StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const StatusChip({super.key, required this.text, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

/// "Label    Value" row used in the Student Information card.
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 15, color: Colors.white70))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

/// Conditional widget: loading -> error -> empty -> data.
class StateView extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final bool isEmpty;
  final String emptyText;
  final VoidCallback onRetry;
  final Widget child;

  const StateView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.isEmpty,
    required this.emptyText,
    required this.onRetry,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [CircularProgressIndicator(color: Colors.white), SizedBox(height: 12), Text('Loading...')],
        ),
      );
    }
    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 8),
              Text(error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }
    if (isEmpty) {
      return Center(
        child: Text(emptyText, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      );
    }
    return child;
  }
}
