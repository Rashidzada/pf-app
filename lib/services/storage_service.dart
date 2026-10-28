import 'dart:convert';
import 'dart:io' show File, Platform, Process;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class StorageService extends ChangeNotifier {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  static const MethodChannel _channel =
      MethodChannel('com.rashidzada.pfapp/native');

  final Set<int> _completedWeeks = {};
  final Map<int, int> _bestQuizScores = {}; // weekNumber -> score out of 10
  final Map<int, int> _quizAttempts = {}; // weekNumber -> attempts count
  final Set<int> _checkedRevisionItems = {}; // index 0..13
  String _savedEditorCode = '''#include <iostream>
using namespace std;

int main() {
    cout << "Welcome to Programming Fundamentals!" << endl;
    cout << "Instructor: Rashid Zada" << endl;
    return 0;
}''';
  String _savedEditorInput = '';

  Set<int> get completedWeeks => _completedWeeks;
  Map<int, int> get bestQuizScores => _bestQuizScores;
  Map<int, int> get quizAttempts => _quizAttempts;
  Set<int> get checkedRevisionItems => _checkedRevisionItems;
  String get savedEditorCode => _savedEditorCode;
  String get savedEditorInput => _savedEditorInput;

  int get totalQuizScore =>
      _bestQuizScores.values.fold(0, (sum, score) => sum + score);

  int get quizzesTakenCount => _bestQuizScores.length;

  File? _getWindowsStorageFile() {
    if (kIsWeb) return null;
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        final appData =
            Platform.environment['APPDATA'] ??
            Platform.environment['USERPROFILE'] ??
            '.';
        return File('$appData\\pf_rashid_zada_state.json');
      }
    } catch (_) {}
    return null;
  }

  Future<void> init() async {
    try {
      String? raw;
      final winFile = _getWindowsStorageFile();
      if (winFile != null) {
        if (await winFile.exists()) {
          raw = await winFile.readAsString();
        }
      } else {
        raw = await _channel.invokeMethod<String>('loadData', {
          'key': 'student_state_v1',
        });
      }
      if (raw != null && raw.isNotEmpty) {
        final Map<String, dynamic> data = jsonDecode(raw);
        if (data['completedWeeks'] is List) {
          _completedWeeks
            ..clear()
            ..addAll((data['completedWeeks'] as List).map((e) => e as int));
        }
        if (data['bestQuizScores'] is Map) {
          _bestQuizScores.clear();
          (data['bestQuizScores'] as Map).forEach((k, v) {
            _bestQuizScores[int.parse(k.toString())] = v as int;
          });
        }
        if (data['quizAttempts'] is Map) {
          _quizAttempts.clear();
          (data['quizAttempts'] as Map).forEach((k, v) {
            _quizAttempts[int.parse(k.toString())] = v as int;
          });
        }
        if (data['checkedRevisionItems'] is List) {
          _checkedRevisionItems
            ..clear()
            ..addAll(
              (data['checkedRevisionItems'] as List).map((e) => e as int),
            );
        }
        if (data['savedEditorCode'] is String &&
            (data['savedEditorCode'] as String).trim().isNotEmpty) {
          _savedEditorCode = data['savedEditorCode'] as String;
        }
        if (data['savedEditorInput'] is String) {
          _savedEditorInput = data['savedEditorInput'] as String;
        }
        notifyListeners();
      }
    } catch (_) {
      // Fallback silently if running in test environment
    }
  }

  Future<void> _persist() async {
    try {
      final payload = jsonEncode({
        'completedWeeks': _completedWeeks.toList(),
        'bestQuizScores': _bestQuizScores.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
        'quizAttempts': _quizAttempts.map((k, v) => MapEntry(k.toString(), v)),
        'checkedRevisionItems': _checkedRevisionItems.toList(),
        'savedEditorCode': _savedEditorCode,
        'savedEditorInput': _savedEditorInput,
      });
      final winFile = _getWindowsStorageFile();
      if (winFile != null) {
        await winFile.writeAsString(payload);
      } else {
        await _channel.invokeMethod<bool>('saveData', {
          'key': 'student_state_v1',
          'value': payload,
        });
      }
    } catch (_) {}
  }

  void toggleWeekCompleted(int weekNumber) {
    if (_completedWeeks.contains(weekNumber)) {
      _completedWeeks.remove(weekNumber);
    } else {
      _completedWeeks.add(weekNumber);
    }
    notifyListeners();
    _persist();
  }

  void markWeekCompleted(int weekNumber) {
    if (!_completedWeeks.contains(weekNumber)) {
      _completedWeeks.add(weekNumber);
      notifyListeners();
      _persist();
    }
  }

  void recordQuizResult(int weekNumber, int score) {
    final prev = _bestQuizScores[weekNumber] ?? -1;
    if (score > prev) {
      _bestQuizScores[weekNumber] = score;
    }
    _quizAttempts[weekNumber] = (_quizAttempts[weekNumber] ?? 0) + 1;
    if (score >= 6) {
      _completedWeeks.add(weekNumber);
    }
    notifyListeners();
    _persist();
  }

  void toggleRevisionItem(int index) {
    if (_checkedRevisionItems.contains(index)) {
      _checkedRevisionItems.remove(index);
    } else {
      _checkedRevisionItems.add(index);
    }
    notifyListeners();
    _persist();
  }

  void saveEditorState(String code, String input) {
    _savedEditorCode = code;
    _savedEditorInput = input;
    _persist();
  }

  Future<bool> launchExternalUrl(String url) async {
    try {
      if (!kIsWeb && Platform.isWindows) {
        await Process.run('rundll32', ['url.dll,FileProtocolHandler', url]);
        return true;
      }
      final ok = await _channel.invokeMethod<bool>('launchUrl', {'url': url});
      return ok ?? false;
    } catch (_) {
      return false;
    }
  }
}
