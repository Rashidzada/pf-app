import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/course_data.dart';
import '../services/cpp_simulator.dart';
import '../services/storage_service.dart';

class CppEditorScreen extends StatefulWidget {
  final String? initialCode;
  final String? initialInput;
  final String? initialTitle;
  final bool isStandalonePage;

  const CppEditorScreen({
    super.key,
    this.initialCode,
    this.initialInput,
    this.initialTitle,
    this.isStandalonePage = false,
  });

  @override
  State<CppEditorScreen> createState() => _CppEditorScreenState();
}

class _CppEditorScreenState extends State<CppEditorScreen> {
  late final TextEditingController _codeController;
  late final TextEditingController _inputController;
  CppExecutionResult? _lastResult;
  String _currentTemplateTitle = 'Custom C++ Program';
  bool _showInputPanel = false;

  static const List<String> _quickTokens = [
    '{',
    '}',
    '(',
    ')',
    '[',
    ']',
    ';',
    '<<',
    '>>',
    '"',
    '=',
    '==',
    '+',
    '-',
    '*',
    '/',
    '%',
    'cout << ',
    'cin >> ',
    'endl;',
    'int ',
    'return 0;',
  ];

  @override
  void initState() {
    super.initState();
    final startCode = widget.initialCode ?? StorageService.instance.savedEditorCode;
    final startInput =
        widget.initialInput ?? StorageService.instance.savedEditorInput;
    if (widget.initialTitle != null) {
      _currentTemplateTitle = widget.initialTitle!;
    }
    _codeController = TextEditingController(text: startCode);
    _inputController = TextEditingController(text: startInput);
    _showInputPanel = startInput.trim().isNotEmpty || startCode.contains('cin');

    // Run initial code automatically so the student immediately sees the output
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runProgram();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _runProgram() {
    final code = _codeController.text;
    final input = _inputController.text;
    StorageService.instance.saveEditorState(code, input);
    final res = CppSimulator.execute(code, rawInput: input);
    setState(() {
      _lastResult = res;
    });
  }

  void _insertToken(String token) {
    final text = _codeController.text;
    final selection = _codeController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final newText = text.replaceRange(start, end, token);
    _codeController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + token.length),
    );
  }

  void _showTemplatePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0E2238),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          maxChildSize: 0.92,
          minChildSize: 0.45,
          builder: (_, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Load a C++ Example by Week (1–15)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: CourseData.allWeeks.length,
                    itemBuilder: (_, idx) {
                      final week = CourseData.allWeeks[idx];
                      return ExpansionTile(
                        iconColor: const Color(0xFF00E5FF),
                        collapsedIconColor: Colors.white70,
                        title: Text(
                          'Week ${week.weekNumber}: ${week.title}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          ...week.allExamples.map(
                            (ex) => ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.code_rounded,
                                color: Color(0xFF00E5FF),
                                size: 20,
                              ),
                              title: Text(
                                ex.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                ex.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white60),
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                setState(() {
                                  _currentTemplateTitle =
                                      'W${week.weekNumber}: ${ex.title}';
                                  _codeController.text = ex.code;
                                  _inputController.text = ex.sampleInput;
                                  _showInputPanel =
                                      ex.sampleInput.isNotEmpty ||
                                      ex.code.contains('cin');
                                });
                                _runProgram();
                              },
                            ),
                          ),
                          ListTile(
                            dense: true,
                            leading: const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Color(0xFFFFC400),
                              size: 20,
                            ),
                            title: const Text(
                              'Try It Yourself (Practice Solution)',
                              style: TextStyle(color: Color(0xFFFFD54F)),
                            ),
                            subtitle: Text(
                              week.practiceTask.prompt,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white60),
                            ),
                            onTap: () {
                              Navigator.pop(ctx);
                              setState(() {
                                _currentTemplateTitle =
                                    'W${week.weekNumber} Practice Solution';
                                _codeController.text =
                                    week.practiceTask.solutionCode;
                                _inputController.text =
                                    week.practiceTask.sampleInput;
                                _showInputPanel =
                                    week.practiceTask.sampleInput.isNotEmpty ||
                                    week.practiceTask.solutionCode.contains('cin');
                              });
                              _runProgram();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        // Top Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF0A1D33),
            border: Border(bottom: BorderSide(color: Colors.white12)),
          ),
          child: Row(
            children: [
              const Icon(Icons.terminal_rounded, color: Color(0xFF00E5FF), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentTemplateTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _showTemplatePicker,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF00E5FF),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
                icon: const Icon(Icons.folder_open_rounded, size: 17),
                label: const Text('Examples', style: TextStyle(fontSize: 12.5)),
              ),
              IconButton(
                tooltip: 'Copy Code',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.copy_rounded, color: Colors.white70, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _codeController.text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('C++ code copied to clipboard!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                tooltip: 'Reset to Starter Template',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 19),
                onPressed: () {
                  setState(() {
                    _currentTemplateTitle = 'Blank C++ Template';
                    _codeController.text = '''#include <iostream>
using namespace std;

int main() {
    cout << "Hello from C++!" << endl;
    return 0;
}''';
                    _inputController.clear();
                  });
                  _runProgram();
                },
              ),
            ],
          ),
        ),

        // Quick Symbol Bar for Easy Student Typing on Mobile
        Container(
          height: 42,
          color: const Color(0xFF102845),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            itemCount: _quickTokens.length,
            separatorBuilder: (_, _) => const SizedBox(width: 6),
            itemBuilder: (_, idx) {
              final tok = _quickTokens[idx];
              return InkWell(
                onTap: () => _insertToken(tok),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A3A60),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    tok.trim(),
                    style: const TextStyle(
                      color: Color(0xFF80DEEA),
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Code Editor Area
        Expanded(
          flex: 5,
          child: Container(
            color: const Color(0xFF071324),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: _codeController,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                color: Color(0xFFE2F1FF),
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.45,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '// Write your C++ program here...',
                hintStyle: TextStyle(color: Colors.white38),
              ),
            ),
          ),
        ),

        // Optional cin Input Bar + Run Action Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Color(0xFF0D233D),
            border: Border(
              top: BorderSide(color: Colors.white12),
              bottom: BorderSide(color: Colors.white12),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => setState(() => _showInputPanel = !_showInputPanel),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(
                            _showInputPanel
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_right_rounded,
                            color: const Color(0xFFFFD54F),
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Program Input (cin)',
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _runProgram();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      foregroundColor: const Color(0xFF051A10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 20),
                    label: const Text(
                      'RUN C++ CODE',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              if (_showInputPanel) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _inputController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFF071324),
                    hintText:
                        'Enter values separated by space (e.g. 4 7 or Ali 19)',
                    hintStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                    prefixIcon: const Icon(
                      Icons.input_rounded,
                      color: Color(0xFFFFD54F),
                      size: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Console Output Area
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            color: const Color(0xFF050E1A),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _lastResult == null || _lastResult!.success
                            ? Icons.check_circle_rounded
                            : Icons.error_rounded,
                        size: 16,
                        color: _lastResult == null || _lastResult!.success
                            ? const Color(0xFF00E676)
                            : const Color(0xFFFF5252),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _lastResult == null
                            ? 'OUTPUT CONSOLE'
                            : (_lastResult!.success
                                  ? 'OUTPUT CONSOLE (${_lastResult!.executionTimeMs} ms)'
                                  : 'COMPILER / RUNTIME DIAGNOSTIC'),
                        style: TextStyle(
                          color: _lastResult == null || _lastResult!.success
                              ? const Color(0xFF80DEEA)
                              : const Color(0xFFFF8A80),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_lastResult != null && !_lastResult!.success)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5252).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFFF5252).withValues(alpha: 0.5),
                        ),
                      ),
                      child: SelectableText(
                        _lastResult!.errorMessage ?? 'Error executing program.',
                        style: const TextStyle(
                          color: Color(0xFFFF8A80),
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                      ),
                    )
                  else
                    SelectableText(
                      (_lastResult?.output.isEmpty ?? true)
                          ? '(Program finished with no screen output)'
                          : _lastResult!.output,
                      style: const TextStyle(
                        color: Color(0xFF00E676),
                        fontFamily: 'monospace',
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  if (_lastResult != null &&
                      _lastResult!.virtualFiles.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ..._lastResult!.virtualFiles.entries.map(
                      (entry) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF102A45),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF00E5FF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.description_rounded,
                                  size: 15,
                                  color: Color(0xFFFFD54F),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Virtual File Saved: ${entry.key}',
                                  style: const TextStyle(
                                    color: Color(0xFFFFD54F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            SelectableText(
                              entry.value,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'monospace',
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (!widget.isStandalonePage) {
      return body;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF071324),
      appBar: AppBar(
        backgroundColor: const Color(0xFF091E36),
        foregroundColor: Colors.white,
        title: const Text(
          'C++ Practice Editor',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: body,
    );
  }
}
