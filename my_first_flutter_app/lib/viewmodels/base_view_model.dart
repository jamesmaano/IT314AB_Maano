import 'package:flutter/foundation.dart';
import '../core/errors.dart';

/// Shared state: loading flag + error message.
class BaseViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  bool _actionError = false;

  /// Error from LOADING data. Lists show this instead of their data.
  /// Errors from create/update/delete (see run) are read from [error] and shown
  /// in dialogs or snackbars, so a failed drop never wipes out a list.
  String? get loadError => _actionError ? null : error;

  /// Loads data and handles loading/error state.
  Future<void> load(Future<void> Function() action) async {
    isLoading = true;
    error = null;
    _actionError = false;
    notifyListeners();
    try {
      await action();
    } catch (e) {
      error = friendlyError(e);
    }
    isLoading = false;
    notifyListeners();
  }

  /// Runs a create/update/delete action. Returns true when it worked.
  Future<bool> run(Future<void> Function() action) async {
    error = null;
    _actionError = true;
    try {
      await action();
      return true;
    } catch (e) {
      error = friendlyError(e);
      return false;
    }
  }
}
