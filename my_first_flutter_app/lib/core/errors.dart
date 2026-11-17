import 'package:postgres/postgres.dart';

/// Business-rule errors (duplicate enrollment, schedule conflict, ...).
class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

/// Turns any error into a message that is safe to show to the user.
String friendlyError(Object e) {
  if (e is AppException) return e.message;
  if (e is ServerException) {
    switch (e.code) {
      case '23503':
        return 'Cannot complete: this record is linked to other records.';
      case '23505':
        return 'Duplicate value: that record already exists.';
      case '23514':
        return 'A value is not allowed by the database rules.';
      case '23502':
        return 'A required field is missing.';
    }
    return 'Database error: ${e.message}';
  }
  return 'Could not reach the database. Check your internet and credentials.';
}
