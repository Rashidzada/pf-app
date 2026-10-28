import 'dart:math' as math;

class CppExecutionResult {
  final bool success;
  final String output;
  final String? errorMessage;
  final Map<String, String> virtualFiles;
  final int executionTimeMs;

  const CppExecutionResult({
    required this.success,
    required this.output,
    this.errorMessage,
    this.virtualFiles = const {},
    this.executionTimeMs = 1,
  });
}

class _FuncDef {
  final String returnType;
  final String name;
  final List<_Param> params;
  final String body;
  _FuncDef(this.returnType, this.name, this.params, this.body);
}

class _Param {
  final String type;
  final String name;
  _Param(this.type, this.name);
}

class _BreakSignal implements Exception {}

class _ContinueSignal implements Exception {}

class _ReturnSignal implements Exception {
  final dynamic value;
  _ReturnSignal(this.value);
}

class _SyntaxException implements Exception {
  final String message;
  _SyntaxException(this.message);
}

class CppSimulator {
  static CppExecutionResult execute(String rawCode, {String rawInput = ''}) {
    final sw = Stopwatch()..start();
    try {
      final trimmed = rawCode.trim();
      if (trimmed.isEmpty) {
        return const CppExecutionResult(
          success: false,
          output: '',
          errorMessage: 'Editor is empty. Write or load a C++ program first.',
        );
      }

      // Support Week 2 Algorithm / Pseudocode blocks directly
      if (!trimmed.contains('main') &&
          (trimmed.toLowerCase().contains('pseudocode') ||
              trimmed.toLowerCase().contains('algorithm') ||
              trimmed.toLowerCase().startsWith('start'))) {
        return _runPseudocode(trimmed, rawInput, sw);
      }

      final runner = _CppInterpreter(rawCode, rawInput);
      final out = runner.run();
      sw.stop();
      return CppExecutionResult(
        success: true,
        output: out,
        virtualFiles: Map.from(runner.virtualFiles),
        executionTimeMs: math.max(1, sw.elapsedMilliseconds),
      );
    } on _SyntaxException catch (e) {
      sw.stop();
      return CppExecutionResult(
        success: false,
        output: '',
        errorMessage: e.message,
        executionTimeMs: math.max(1, sw.elapsedMilliseconds),
      );
    } catch (e) {
      sw.stop();
      return CppExecutionResult(
        success: false,
        output: '',
        errorMessage: 'Compile / Runtime Error: $e',
        executionTimeMs: math.max(1, sw.elapsedMilliseconds),
      );
    }
  }

  static CppExecutionResult _runPseudocode(
    String code,
    String rawInput,
    Stopwatch sw,
  ) {
    final tokens = rawInput
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    final a = tokens.isNotEmpty ? (num.tryParse(tokens[0]) ?? 4) : 4;
    final b = tokens.length > 1 ? (num.tryParse(tokens[1]) ?? 7) : 7;
    final lower = code.toLowerCase();
    String out;
    if (lower.contains('area') || lower.contains('length')) {
      out =
          '[Pseudocode Trace Simulation]\nInput: Length = $a, Width = $b\nProcess: Area = $a * $b\nOutput: Area = ${a * b}';
    } else if (lower.contains('average')) {
      final c = tokens.length > 2 ? (num.tryParse(tokens[2]) ?? 9) : 9;
      final avg = ((a + b + c) / 3).toStringAsFixed(2);
      out =
          '[Pseudocode Trace Simulation]\nInput: $a, $b, $c\nProcess: Sum = ${a + b + c}, Average = Sum / 3\nOutput: Average = $avg';
    } else {
      out =
          '[Pseudocode Trace Simulation]\nStep 1: Start\nStep 2: Input A = $a, B = $b\nStep 3: Process Sum = $a + $b = ${a + b}\nStep 4: Output Sum = ${a + b}\nStep 5: Stop';
    }
    sw.stop();
    return CppExecutionResult(
      success: true,
      output: out,
      executionTimeMs: math.max(1, sw.elapsedMilliseconds),
    );
  }
}

class _CppInterpreter {
  final String rawCode;
  final List<String> inputTokens;
  int inputIndex = 0;

  final StringBuffer output = StringBuffer();
  final Map<String, String> virtualFiles = {};
  final Map<String, String> openFileStreams = {}; // varName -> filename
  final Map<String, String> fileModes = {}; // varName -> 'out' | 'in'
  final Map<String, List<String>> structs = {}; // structName -> fieldNames
  final Map<String, _FuncDef> functions = {};
  int loopSafetyCounter = 0;

  _CppInterpreter(this.rawCode, String rawInput)
      : inputTokens = rawInput
            .trim()
            .split(RegExp(r'\s+'))
            .where((t) => t.isNotEmpty)
            .toList();

  String run() {
    // 1. Check line-level syntax errors (like missing semicolons) before stripping comments
    _checkCommonSyntaxErrors(rawCode);

    // 2. Strip comments and preprocessor directives
    final cleaned = _stripCommentsAndIncludes(rawCode);

    // 3. Parse structs and top-level functions (or snippet if no main())
    if (!RegExp(r'\bmain\s*\(').hasMatch(cleaned)) {
      // Snippet mode (e.g. Week 15 snippet `cout << 5 + 5;`)
      final env = <String, dynamic>{};
      _executeBlock(cleaned, env);
      return output.toString();
    }

    _parseTopLevel(cleaned);

    final mainFunc = functions['main'];
    if (mainFunc == null) {
      throw _SyntaxException('Compile Error: int main() function not found.');
    }

    final globalEnv = <String, dynamic>{};
    try {
      _executeBlock(mainFunc.body, globalEnv);
    } on _ReturnSignal catch (_) {
      // Normal return from main()
    }
    return output.toString();
  }

  void _checkCommonSyntaxErrors(String src) {
    final lines = src.split('\n');
    int braceDepth = 0;
    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];
      // remove // comment
      final cIdx = line.indexOf('//');
      if (cIdx != -1) line = line.substring(0, cIdx);
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      for (int c = 0; c < line.length; c++) {
        if (line[c] == '{') braceDepth++;
        if (line[c] == '}') braceDepth--;
      }

      // Check obvious missing semicolon on cout / cin / return lines
      if ((line.startsWith('cout') ||
              line.startsWith('cin') ||
              line.startsWith('return')) &&
          !line.endsWith(';') &&
          !line.endsWith('{') &&
          !line.endsWith('<<')) {
        // Check if next non-empty line continues it
        bool continued = false;
        if (i + 1 < lines.length) {
          final nextTrim = lines[i + 1].trim();
          if (nextTrim.startsWith('<<') ||
              nextTrim.startsWith('>>') ||
              nextTrim.startsWith(';')) {
            continued = true;
          }
        }
        if (!continued) {
          throw _SyntaxException(
            'Syntax Error on line ${i + 1}: Missing semicolon ";" at end of statement:\n  $line',
          );
        }
      }
    }
    if (braceDepth != 0) {
      throw _SyntaxException(
        'Syntax Error: Unmatched curly braces "{ }". Please check that every "{" has a matching "}".',
      );
    }
  }

  String _stripCommentsAndIncludes(String src) {
    // Remove /* ... */
    var s = src.replaceAll(RegExp(r'/\*[\s\S]*?\*/'), '');
    final outLines = <String>[];
    for (final line in s.split('\n')) {
      var l = line;
      // Remove // comments outside quotes
      bool inQuotes = false;
      int cutAt = -1;
      for (int i = 0; i < l.length; i++) {
        if (l[i] == '"' && (i == 0 || l[i - 1] != '\\')) {
          inQuotes = !inQuotes;
        } else if (!inQuotes && i + 1 < l.length && l[i] == '/' && l[i + 1] == '/') {
          cutAt = i;
          break;
        }
      }
      if (cutAt != -1) l = l.substring(0, cutAt);
      final t = l.trim();
      if (t.startsWith('#include')) continue;
      if (t.startsWith('using namespace')) continue;
      outLines.add(l);
    }
    return outLines.join('\n');
  }

  void _parseTopLevel(String code) {
    int i = 0;
    final n = code.length;
    while (i < n) {
      while (i < n && code[i].trim().isEmpty) {
        i++;
      }
      if (i >= n) break;

      // Check struct definition: struct Name { ... };
      final structMatch =
          RegExp(r'struct\s+([A-Za-z_]\w*)\s*\{').matchAsPrefix(code, i);
      if (structMatch != null) {
        final structName = structMatch.group(1)!;
        final openBrace = code.indexOf('{', i);
        final closeBrace = _findMatching(code, openBrace, '{', '}');
        final body = code.substring(openBrace + 1, closeBrace);
        final fields = <String>[];
        for (final rawField in body.split(';')) {
          final ft = rawField.trim();
          if (ft.isEmpty) continue;
          final parts = ft.split(RegExp(r'\s+'));
          if (parts.length >= 2) {
            fields.add(parts.last.replaceAll(';', '').trim());
          }
        }
        structs[structName] = fields;
        i = closeBrace + 1;
        while (i < n && (code[i] == ';' || code[i].trim().isEmpty)) {
          i++;
        }
        continue;
      }

      // Match function definition or prototype: type name(params) { ... } or ;
      final funcMatch = RegExp(
        r'(int|float|double|char|string|bool|void)\s+([A-Za-z_]\w*)\s*\(([^)]*)\)',
      ).matchAsPrefix(code, i);
      if (funcMatch != null) {
        final retType = funcMatch.group(1)!;
        final funcName = funcMatch.group(2)!;
        final paramsRaw = funcMatch.group(3)!.trim();
        int afterParen = funcMatch.end;
        while (afterParen < n && code[afterParen].trim().isEmpty) {
          afterParen++;
        }
        if (afterParen < n && code[afterParen] == ';') {
          // Function prototype declaration
          i = afterParen + 1;
          continue;
        }
        if (afterParen < n && code[afterParen] == '{') {
          final closeBrace = _findMatching(code, afterParen, '{', '}');
          final body = code.substring(afterParen + 1, closeBrace);
          final params = <_Param>[];
          if (paramsRaw.isNotEmpty) {
            for (final p in paramsRaw.split(',')) {
              final pt = p.trim().split(RegExp(r'\s+'));
              if (pt.length >= 2) {
                params.add(_Param(pt.first, pt.last));
              }
            }
          }
          functions[funcName] = _FuncDef(retType, funcName, params, body);
          i = closeBrace + 1;
          continue;
        }
      }
      i++;
    }
  }

  int _findMatching(String s, int openPos, String openCh, String closeCh) {
    int depth = 0;
    bool inQuote = false;
    for (int i = openPos; i < s.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) {
        inQuote = !inQuote;
      }
      if (inQuote) continue;
      if (ch == openCh) depth++;
      if (ch == closeCh) {
        depth--;
        if (depth == 0) return i;
      }
    }
    throw _SyntaxException('Unmatched "$openCh" in code.');
  }

  void _executeBlock(String block, Map<String, dynamic> env) {
    int i = 0;
    final s = block;
    final n = s.length;

    while (i < n) {
      while (i < n && s[i].trim().isEmpty) {
        i++;
      }
      if (i >= n) break;

      if (s[i] == ';') {
        i++;
        continue;
      }

      if (s[i] == '{') {
        final endBrace = _findMatching(s, i, '{', '}');
        _executeBlock(s.substring(i + 1, endBrace), env);
        i = endBrace + 1;
        continue;
      }

      // Check control structures: if, for, while, do, switch, break, continue, return
      final kwMatch = RegExp(r'([A-Za-z_]\w*)\b').matchAsPrefix(s, i);
      final kw = kwMatch?.group(1);

      if (kw == 'if') {
        i = _handleIf(s, i, env);
        continue;
      } else if (kw == 'for') {
        i = _handleFor(s, i, env);
        continue;
      } else if (kw == 'while') {
        i = _handleWhile(s, i, env);
        continue;
      } else if (kw == 'do') {
        i = _handleDoWhile(s, i, env);
        continue;
      } else if (kw == 'switch') {
        i = _handleSwitch(s, i, env);
        continue;
      } else if (kw == 'break') {
        throw _BreakSignal();
      } else if (kw == 'continue') {
        throw _ContinueSignal();
      } else if (kw == 'return') {
        final semi = _findStatementEnd(s, i);
        final exprStr = s.substring(i + 6, semi).trim();
        final val = exprStr.isEmpty ? 0 : _evalExpr(exprStr, env);
        throw _ReturnSignal(val);
      }

      // Regular semicolon-terminated statement
      final semi = _findStatementEnd(s, i);
      final stmt = s.substring(i, semi).trim();
      if (stmt.isNotEmpty) {
        _executeSimpleStatement(stmt, env);
      }
      i = semi + 1;
    }
  }

  int _findStatementEnd(String s, int start) {
    bool inQuote = false;
    int parenDepth = 0;
    int braceDepth = 0;
    for (int i = start; i < s.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) {
        inQuote = !inQuote;
      }
      if (inQuote) continue;
      if (ch == '(') parenDepth++;
      if (ch == ')') parenDepth--;
      if (ch == '{') braceDepth++;
      if (ch == '}') braceDepth--;
      if (ch == ';' && parenDepth <= 0 && braceDepth <= 0) {
        return i;
      }
    }
    return s.length;
  }

  (String, int) _extractBodyOrStatement(String s, int start) {
    int i = start;
    while (i < s.length && s[i].trim().isEmpty) {
      i++;
    }
    if (i < s.length && s[i] == '{') {
      final close = _findMatching(s, i, '{', '}');
      return (s.substring(i + 1, close), close + 1);
    }
    // Check if the body is another control statement (e.g., nested if)
    final kw = RegExp(r'([A-Za-z_]\w*)\b').matchAsPrefix(s, i)?.group(1);
    if (kw == 'if' || kw == 'for' || kw == 'while') {
      final openParen = s.indexOf('(', i);
      final closeParen = _findMatching(s, openParen, '(', ')');
      final (innerBody, afterInner) = _extractBodyOrStatement(s, closeParen + 1);
      int endPos = afterInner;
      if (kw == 'if') {
        int look = endPos;
        while (look < s.length && s[look].trim().isEmpty) {
          look++;
        }
        if (RegExp(r'else\b').matchAsPrefix(s, look) != null) {
          final (_, afterElse) = _extractBodyOrStatement(s, look + 4);
          endPos = afterElse;
        }
      }
      return (s.substring(i, endPos), endPos);
    }
    final semi = _findStatementEnd(s, i);
    final nextPos = semi < s.length ? semi + 1 : s.length;
    return (s.substring(i, nextPos), nextPos);
  }

  int _handleIf(String s, int start, Map<String, dynamic> env) {
    int i = start;
    bool executedBranch = false;

    while (true) {
      final openParen = s.indexOf('(', i);
      final closeParen = _findMatching(s, openParen, '(', ')');
      final condStr = s.substring(openParen + 1, closeParen).trim();
      final (body, nextIdx) = _extractBodyOrStatement(s, closeParen + 1);

      if (!executedBranch && _isTruthy(_evalExpr(condStr, env))) {
        _executeBlock(body, env);
        executedBranch = true;
      }

      i = nextIdx;
      while (i < s.length && s[i].trim().isEmpty) {
        i++;
      }
      final elseMatch = RegExp(r'else\b').matchAsPrefix(s, i);
      if (elseMatch == null) break;

      i = elseMatch.end;
      while (i < s.length && s[i].trim().isEmpty) {
        i++;
      }
      final elseIfMatch = RegExp(r'if\b').matchAsPrefix(s, i);
      if (elseIfMatch != null) {
        continue;
      } else {
        final (elseBody, afterElse) = _extractBodyOrStatement(s, i);
        if (!executedBranch) {
          _executeBlock(elseBody, env);
        }
        i = afterElse;
        break;
      }
    }
    return i;
  }

  int _handleFor(String s, int start, Map<String, dynamic> env) {
    final openParen = s.indexOf('(', start);
    final closeParen = _findMatching(s, openParen, '(', ')');
    final header = s.substring(openParen + 1, closeParen);
    final parts = header.split(';');
    final initStmt = parts.isNotEmpty ? parts[0].trim() : '';
    final condExpr = parts.length > 1 ? parts[1].trim() : 'true';
    final updateStmt = parts.length > 2 ? parts[2].trim() : '';

    final (body, nextIdx) = _extractBodyOrStatement(s, closeParen + 1);

    if (initStmt.isNotEmpty) {
      _executeSimpleStatement(initStmt, env);
    }

    while (condExpr.isEmpty || _isTruthy(_evalExpr(condExpr, env))) {
      _checkLoopGuard();
      try {
        _executeBlock(body, env);
      } on _BreakSignal {
        break;
      } on _ContinueSignal {
        // Continue to updateStmt
      }
      if (updateStmt.isNotEmpty) {
        _executeSimpleStatement(updateStmt, env);
      }
    }
    return nextIdx;
  }

  int _handleWhile(String s, int start, Map<String, dynamic> env) {
    final openParen = s.indexOf('(', start);
    final closeParen = _findMatching(s, openParen, '(', ')');
    final condExpr = s.substring(openParen + 1, closeParen).trim();
    final (body, nextIdx) = _extractBodyOrStatement(s, closeParen + 1);

    while (_isTruthy(_evalExpr(condExpr, env))) {
      _checkLoopGuard();
      try {
        _executeBlock(body, env);
      } on _BreakSignal {
        break;
      } on _ContinueSignal {
        continue;
      }
    }
    return nextIdx;
  }

  int _handleDoWhile(String s, int start, Map<String, dynamic> env) {
    final (body, afterBody) = _extractBodyOrStatement(s, start + 2);
    int i = afterBody;
    while (i < s.length && s[i].trim().isEmpty) {
      i++;
    }
    final whileMatch = RegExp(r'while\b').matchAsPrefix(s, i);
    if (whileMatch == null) {
      throw _SyntaxException('Syntax Error: Expected "while (condition);" after do block.');
    }
    final openParen = s.indexOf('(', whileMatch.end);
    final closeParen = _findMatching(s, openParen, '(', ')');
    final condExpr = s.substring(openParen + 1, closeParen).trim();
    int afterClose = closeParen + 1;
    while (afterClose < s.length && s[afterClose].trim().isEmpty) {
      afterClose++;
    }
    if (afterClose >= s.length || s[afterClose] != ';') {
      throw _SyntaxException(
        'Syntax Error: Do not forget the semicolon ";" after while (condition); in a do-while loop!',
      );
    }

    do {
      _checkLoopGuard();
      try {
        _executeBlock(body, env);
      } on _BreakSignal {
        break;
      } on _ContinueSignal {
        // Continue to condition check
      }
    } while (_isTruthy(_evalExpr(condExpr, env)));

    return afterClose + 1;
  }

  int _handleSwitch(String s, int start, Map<String, dynamic> env) {
    final openParen = s.indexOf('(', start);
    final closeParen = _findMatching(s, openParen, '(', ')');
    final switchVal = _evalExpr(s.substring(openParen + 1, closeParen).trim(), env);
    int i = closeParen + 1;
    while (i < s.length && s[i].trim().isEmpty) {
      i++;
    }
    final closeBrace = _findMatching(s, i, '{', '}');
    final switchBody = s.substring(i + 1, closeBrace);

    // Split cases
    final caseRegex = RegExp(r'(case\s+[^:]+:|default\s*:)');
    final matches = caseRegex.allMatches(switchBody).toList();
    bool matched = false;

    for (int m = 0; m < matches.length; m++) {
      final header = matches[m].group(0)!;
      final bodyStart = matches[m].end;
      final bodyEnd = (m + 1 < matches.length) ? matches[m + 1].start : switchBody.length;
      final sectionCode = switchBody.substring(bodyStart, bodyEnd);

      if (!matched) {
        if (header.startsWith('default')) {
          matched = true;
        } else {
          final caseExpr =
              header.replaceFirst(RegExp(r'^case\s+'), '').replaceFirst(':', '').trim();
          final caseVal = _evalExpr(caseExpr, env);
          if (caseVal == switchVal || caseVal.toString() == switchVal.toString()) {
            matched = true;
          }
        }
      }

      if (matched) {
        try {
          _executeBlock(sectionCode, env);
        } on _BreakSignal {
          break;
        }
      }
    }

    return closeBrace + 1;
  }

  void _checkLoopGuard() {
    loopSafetyCounter++;
    if (loopSafetyCounter > 2000) {
      throw _SyntaxException(
        'Infinite Loop Detected! Your loop ran over 2,000 times without stopping. Check your loop condition and variable update (Week 6 tip).',
      );
    }
  }

  void _executeSimpleStatement(String stmt, Map<String, dynamic> env) {
    final t = stmt.trim();
    if (t.isEmpty) return;

    // 1. cout << ...
    if (t.startsWith('cout')) {
      _handleStreamOut(t.substring(4).trim(), env, isFile: false);
      return;
    }

    // 2. cin >> ...
    if (t.startsWith('cin')) {
      _handleCin(t.substring(3).trim(), env);
      return;
    }

    // 3. getline(cin, varName)
    final getlineMatch =
        RegExp(r'^getline\s*\(\s*cin\s*,\s*([A-Za-z_]\w*)\s*\)$').firstMatch(t);
    if (getlineMatch != null) {
      final varName = getlineMatch.group(1)!;
      if (inputIndex < inputTokens.length) {
        env[varName] = inputTokens.sublist(inputIndex).join(' ');
        inputIndex = inputTokens.length;
      } else {
        env[varName] = 'Sample Text';
      }
      return;
    }

    // 4. ofstream / ifstream declarations: ofstream outFile("student.txt")
    final fileDeclMatch = RegExp(
      r'^(ofstream|ifstream)\s+([A-Za-z_]\w*)\s*\(\s*"([^"]+)"\s*\)$',
    ).firstMatch(t);
    if (fileDeclMatch != null) {
      final mode = fileDeclMatch.group(1)! == 'ofstream' ? 'out' : 'in';
      final streamVar = fileDeclMatch.group(2)!;
      final fileName = fileDeclMatch.group(3)!;
      openFileStreams[streamVar] = fileName;
      fileModes[streamVar] = mode;
      if (mode == 'out') {
        virtualFiles[fileName] = '';
      }
      return;
    }

    // 5. streamVar.close()
    final closeMatch = RegExp(r'^([A-Za-z_]\w*)\.close\s*\(\s*\)$').firstMatch(t);
    if (closeMatch != null) {
      return;
    }

    // 6. fileStream << ... or fileStream >> ...
    final streamOutMatch = RegExp(r'^([A-Za-z_]\w*)\s*<<(.*)$').firstMatch(t);
    if (streamOutMatch != null &&
        openFileStreams.containsKey(streamOutMatch.group(1)!)) {
      final streamVar = streamOutMatch.group(1)!;
      final fileName = openFileStreams[streamVar]!;
      _handleStreamOut(
        '<<${streamOutMatch.group(2)!}',
        env,
        isFile: true,
        fileName: fileName,
      );
      return;
    }
    final streamInMatch = RegExp(r'^([A-Za-z_]\w*)\s*>>(.*)$').firstMatch(t);
    if (streamInMatch != null &&
        openFileStreams.containsKey(streamInMatch.group(1)!)) {
      final streamVar = streamInMatch.group(1)!;
      final fileName = openFileStreams[streamVar]!;
      final content = virtualFiles[fileName] ?? 'Ali 85';
      final fileTokens = content
          .trim()
          .split(RegExp(r'\s+'))
          .where((e) => e.isNotEmpty)
          .toList();
      final vars = streamInMatch
          .group(2)!
          .split('>>')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      for (int k = 0; k < vars.length; k++) {
        env[vars[k]] = k < fileTokens.length ? fileTokens[k] : '';
      }
      return;
    }

    // 7. Struct variable declaration: Student s1 = {"Ali", 101, 88.5}; or Student s1;
    for (final structName in structs.keys) {
      final structMatch =
          RegExp('^$structName\\s+([A-Za-z_]\\w*)\\s*(?:=\\s*\\{([^}]*)\\})?\$')
              .firstMatch(t);
      if (structMatch != null) {
        final varName = structMatch.group(1)!;
        final initValsRaw = structMatch.group(2);
        final fields = structs[structName]!;
        final values = initValsRaw != null ? _splitByCommaOutsideQuotes(initValsRaw) : <String>[];
        for (int f = 0; f < fields.length; f++) {
          final key = '$varName.${fields[f]}';
          env[key] = f < values.length ? _evalExpr(values[f], env) : 0;
        }
        return;
      }
    }

    // 8. Pointer declaration: int* p = &x; or int *p = &x;
    final ptrMatch = RegExp(
      r'^(?:int|float|double|char|string)\s*\*\s*([A-Za-z_]\w*)\s*(?:=\s*(.+))?$',
    ).firstMatch(t);
    if (ptrMatch != null) {
      final ptrName = ptrMatch.group(1)!;
      final rhs = ptrMatch.group(2)?.trim();
      if (rhs != null && rhs.startsWith('&')) {
        final targetVar = rhs.substring(1).trim();
        env[ptrName] = '@ref:$targetVar';
      } else if (rhs != null) {
        env[ptrName] = _evalExpr(rhs, env);
      } else {
        env[ptrName] = '@ref:null';
      }
      return;
    }

    // 9. Array declaration: int marks[4] = {45, 67, 88, 92}; or int arr[5];
    final arrMatch = RegExp(
      r'^(?:const\s+)?(?:int|float|double|char|string|bool)\s+([A-Za-z_]\w*)\s*\[\s*(\d*)\s*\]\s*(?:=\s*\{([^}]*)\})?$',
    ).firstMatch(t);
    if (arrMatch != null) {
      final arrName = arrMatch.group(1)!;
      final sizeStr = arrMatch.group(2)!;
      final initRaw = arrMatch.group(3);
      final items = initRaw != null
          ? _splitByCommaOutsideQuotes(initRaw).map((e) => _evalExpr(e, env)).toList()
          : <dynamic>[];
      final size = sizeStr.isNotEmpty ? int.parse(sizeStr) : items.length;
      final list = List<dynamic>.filled(math.max(size, items.length), 0);
      for (int idx = 0; idx < items.length; idx++) {
        list[idx] = items[idx];
      }
      env[arrName] = list;
      return;
    }

    // 10. Standard variable declaration: int a = 5, b = 10;
    final declMatch = RegExp(
      r'^(?:const\s+)?(int|float|double|char|string|bool)\s+(.+)$',
    ).firstMatch(t);
    if (declMatch != null) {
      final type = declMatch.group(1)!;
      final rest = declMatch.group(2)!;
      final parts = _splitByCommaOutsideQuotes(rest);
      for (final part in parts) {
        final eqIdx = part.indexOf('=');
        if (eqIdx != -1) {
          final vName = part.substring(0, eqIdx).trim();
          final vExpr = part.substring(eqIdx + 1).trim();
          env[vName] = _coerceType(type, _evalExpr(vExpr, env));
        } else {
          final vName = part.trim();
          env[vName] = type == 'string' ? '' : (type == 'bool' ? false : 0);
        }
      }
      return;
    }

    // 11. Increment / Decrement: i++, ++i, i--, --i
    final incMatch =
        RegExp(r'^(?:\+\+([A-Za-z_]\w*)|([A-Za-z_]\w*)\+\+)$').firstMatch(t);
    if (incMatch != null) {
      final v = incMatch.group(1) ?? incMatch.group(2)!;
      env[v] = (_toNum(env[v]) + 1);
      return;
    }
    final decMatch =
        RegExp(r'^(?:--([A-Za-z_]\w*)|([A-Za-z_]\w*)--)$').firstMatch(t);
    if (decMatch != null) {
      final v = decMatch.group(1) ?? decMatch.group(2)!;
      env[v] = (_toNum(env[v]) - 1);
      return;
    }

    // 12. Dereference assignment: *p = 50
    final derefAssign = RegExp(r'^\*([A-Za-z_]\w*)\s*=\s*(.+)$').firstMatch(t);
    if (derefAssign != null) {
      final ptrName = derefAssign.group(1)!;
      final val = _evalExpr(derefAssign.group(2)!, env);
      final ref = env[ptrName];
      if (ref is String && ref.startsWith('@ref:')) {
        final target = ref.substring(5);
        env[target] = val;
      }
      return;
    }

    // 13. Array element assignment: arr[i] = val
    final arrAssign =
        RegExp(r'^([A-Za-z_]\w*)\s*\[\s*([^\]]+)\s*\]\s*=\s*(.+)$').firstMatch(t);
    if (arrAssign != null) {
      final arrName = arrAssign.group(1)!;
      final idx = _toNum(_evalExpr(arrAssign.group(2)!, env)).toInt();
      final val = _evalExpr(arrAssign.group(3)!, env);
      final list = env[arrName];
      if (list is List && idx >= 0 && idx < list.length) {
        list[idx] = val;
      }
      return;
    }

    // 14. Compound assignment: x += 2, x -= 1, x *= 3, x /= 2
    final compAssign =
        RegExp(r'^([A-Za-z_][\w\.]*)\s*(\+=|-=|\*=|/=)\s*(.+)$').firstMatch(t);
    if (compAssign != null) {
      final vName = compAssign.group(1)!;
      final op = compAssign.group(2)!;
      final rhs = _evalExpr(compAssign.group(3)!, env);
      final cur = env[vName] ?? 0;
      if (op == '+=' && (cur is String || rhs is String)) {
        env[vName] = '$cur$rhs';
      } else {
        final a = _toNum(cur);
        final b = _toNum(rhs);
        switch (op) {
          case '+=':
            env[vName] = a + b;
            break;
          case '-=':
            env[vName] = a - b;
            break;
          case '*=':
            env[vName] = a * b;
            break;
          case '/=':
            env[vName] = b == 0 ? 0 : a / b;
            break;
        }
      }
      return;
    }

    // 15. Standard assignment: sum = a + b; or s1.name = "Ali";
    final assignMatch = RegExp(r'^([A-Za-z_][\w\.]*)\s*=\s*(.+)$').firstMatch(t);
    if (assignMatch != null) {
      final vName = assignMatch.group(1)!;
      final rhs = assignMatch.group(2)!;
      env[vName] = _evalExpr(rhs, env);
      return;
    }

    // 16. Standalone function call: greet();
    _evalExpr(t, env);
  }

  void _handleStreamOut(
    String rest,
    Map<String, dynamic> env, {
    required bool isFile,
    String? fileName,
  }) {
    var s = rest.trim();
    if (s.startsWith('<<')) s = s.substring(2).trim();
    final parts = _splitStreamOperator(s, '<<');
    final buf = StringBuffer();
    for (final part in parts) {
      final p = part.trim();
      if (p.isEmpty) continue;
      if (p == 'endl' || p == r'"\n"' || p == r"'\n'") {
        buf.write('\n');
      } else {
        final val = _evalExpr(p, env);
        buf.write(_formatValue(val));
      }
    }
    if (isFile && fileName != null) {
      virtualFiles[fileName] = (virtualFiles[fileName] ?? '') + buf.toString();
    } else {
      output.write(buf.toString());
    }
  }

  void _handleCin(String rest, Map<String, dynamic> env) {
    var s = rest.trim();
    if (s.startsWith('>>')) s = s.substring(2).trim();
    final vars = _splitStreamOperator(s, '>>');
    for (final rawVar in vars) {
      final v = rawVar.trim();
      if (v.isEmpty) continue;
      String token;
      if (inputIndex < inputTokens.length) {
        token = inputTokens[inputIndex++];
      } else {
        // Smart default if user didn't type enough tokens in cin box
        final existing = env[v];
        if (existing is String) {
          token = 'Ali';
        } else {
          token = (inputIndex == 0) ? '4' : '7';
          inputIndex++;
        }
      }

      // Check array target: arr[i]
      final arrMatch = RegExp(r'^([A-Za-z_]\w*)\[([^\]]+)\]$').firstMatch(v);
      if (arrMatch != null) {
        final arrName = arrMatch.group(1)!;
        final idx = _toNum(_evalExpr(arrMatch.group(2)!, env)).toInt();
        final list = env[arrName];
        final parsed = num.tryParse(token) ?? token;
        if (list is List && idx >= 0 && idx < list.length) {
          list[idx] = parsed;
        }
        continue;
      }

      final cur = env[v];
      if (cur is String) {
        env[v] = token;
      } else if (cur is int) {
        env[v] = int.tryParse(token) ?? num.tryParse(token)?.toInt() ?? 0;
      } else if (cur is double) {
        env[v] = double.tryParse(token) ?? 0.0;
      } else {
        env[v] = num.tryParse(token) ?? token;
      }
    }
  }

  List<String> _splitStreamOperator(String s, String op) {
    final res = <String>[];
    bool inQuotes = false;
    int parenDepth = 0;
    int last = 0;
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) {
        inQuotes = !inQuotes;
      }
      if (!inQuotes) {
        if (ch == '(') parenDepth++;
        if (ch == ')') parenDepth--;
        if (parenDepth == 0 && i + 1 < s.length && s.substring(i, i + 2) == op) {
          res.add(s.substring(last, i));
          i++;
          last = i + 1;
        }
      }
    }
    if (last <= s.length) {
      res.add(s.substring(last));
    }
    return res;
  }

  List<String> _splitByCommaOutsideQuotes(String s) {
    final res = <String>[];
    bool inQuotes = false;
    int parenDepth = 0;
    int last = 0;
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) {
        inQuotes = !inQuotes;
      }
      if (!inQuotes) {
        if (ch == '(' || ch == '{') parenDepth++;
        if (ch == ')' || ch == '}') parenDepth--;
        if (ch == ',' && parenDepth == 0) {
          res.add(s.substring(last, i).trim());
          last = i + 1;
        }
      }
    }
    if (last <= s.length) {
      final tail = s.substring(last).trim();
      if (tail.isNotEmpty) res.add(tail);
    }
    return res;
  }

  dynamic _evalExpr(String expr, Map<String, dynamic> env) {
    var e = expr.trim();
    if (e.isEmpty) return 0;

    // Strip outer redundant parentheses if balanced
    while (e.startsWith('(') &&
        e.endsWith(')') &&
        _findMatching(e, 0, '(', ')') == e.length - 1) {
      e = e.substring(1, e.length - 1).trim();
    }

    // String literal
    if (e.startsWith('"') && e.endsWith('"') && e.length >= 2) {
      final inner = e.substring(1, e.length - 1);
      if (!inner.contains('"')) {
        return inner.replaceAll(r'\n', '\n').replaceAll(r'\t', '\t');
      }
    }

    // Char literal
    if (e.startsWith("'") && e.endsWith("'") && e.length >= 2) {
      return e
          .substring(1, e.length - 1)
          .replaceAll(r'\n', '\n')
          .replaceAll(r'\t', '\t');
    }

    if (e == 'true') return true;
    if (e == 'false') return false;

    // Numeric literal
    final numVal = int.tryParse(e) ?? double.tryParse(e);
    if (numVal != null) return numVal;

    // Ternary operator: cond ? a : b
    final qIdx = _findTopLevelOp(e, '?');
    if (qIdx != -1) {
      final cIdx = _findTopLevelOp(e.substring(qIdx + 1), ':');
      if (cIdx != -1) {
        final condPart = e.substring(0, qIdx).trim();
        final truePart = e.substring(qIdx + 1, qIdx + 1 + cIdx).trim();
        final falsePart = e.substring(qIdx + 1 + cIdx + 1).trim();
        return _isTruthy(_evalExpr(condPart, env))
            ? _evalExpr(truePart, env)
            : _evalExpr(falsePart, env);
      }
    }

    // Logical OR ||
    final orIdx = _findTopLevelMultiOp(e, '||');
    if (orIdx != -1) {
      return _isTruthy(_evalExpr(e.substring(0, orIdx), env)) ||
          _isTruthy(_evalExpr(e.substring(orIdx + 2), env));
    }

    // Logical AND &&
    final andIdx = _findTopLevelMultiOp(e, '&&');
    if (andIdx != -1) {
      return _isTruthy(_evalExpr(e.substring(0, andIdx), env)) &&
          _isTruthy(_evalExpr(e.substring(andIdx + 2), env));
    }

    // Comparisons: ==, !=, <=, >=, <, >
    for (final op in ['==', '!=', '<=', '>=', '<', '>']) {
      final idx = _findTopLevelComparison(e, op);
      if (idx != -1) {
        final left = _evalExpr(e.substring(0, idx), env);
        final right = _evalExpr(e.substring(idx + op.length), env);
        switch (op) {
          case '==':
            if (left is num && right is num) return left == right;
            return left.toString() == right.toString();
          case '!=':
            if (left is num && right is num) return left != right;
            return left.toString() != right.toString();
          case '<=':
            return _toNum(left) <= _toNum(right);
          case '>=':
            return _toNum(left) >= _toNum(right);
          case '<':
            return _toNum(left) < _toNum(right);
          case '>':
            return _toNum(left) > _toNum(right);
        }
      }
    }

    // Addition / Subtraction (+, -) from right to left at top level
    final addSubIdx = _findLastTopLevelAddSub(e);
    if (addSubIdx != -1) {
      final op = e[addSubIdx];
      final leftStr = e.substring(0, addSubIdx).trim();
      final rightStr = e.substring(addSubIdx + 1).trim();
      if (leftStr.isEmpty) {
        final r = _toNum(_evalExpr(rightStr, env));
        return op == '-' ? -r : r;
      }
      final left = _evalExpr(leftStr, env);
      final right = _evalExpr(rightStr, env);
      if (op == '+') {
        if (left is String || right is String) {
          return '${_formatValue(left)}${_formatValue(right)}';
        }
        return _toNum(left) + _toNum(right);
      } else {
        return _toNum(left) - _toNum(right);
      }
    }

    // Multiplication / Division / Modulo (*, /, %)
    final mulDivIdx = _findLastTopLevelMulDiv(e);
    if (mulDivIdx != -1) {
      final op = e[mulDivIdx];
      final leftStr = e.substring(0, mulDivIdx).trim();
      final rightStr = e.substring(mulDivIdx + 1).trim();
      if (leftStr.isNotEmpty) {
        final left = _toNum(_evalExpr(leftStr, env));
        final right = _toNum(_evalExpr(rightStr, env));
        if (op == '*') return left * right;
        if (op == '/') {
          if (right == 0) {
            throw _SyntaxException('Runtime Error: Division by zero!');
          }
          if (left is int && right is int) return left ~/ right;
          return left / right;
        }
        if (op == '%') {
          if (right == 0) {
            throw _SyntaxException('Runtime Error: Modulo by zero!');
          }
          return left.toInt() % right.toInt();
        }
      }
    }

    // Unary logical NOT: !expr
    if (e.startsWith('!')) {
      return !_isTruthy(_evalExpr(e.substring(1), env));
    }

    // Address-of operator: &x
    if (e.startsWith('&') && e.length > 1) {
      final target = e.substring(1).trim();
      return '@ref:$target';
    }

    // Dereference operator: *p
    if (e.startsWith('*') && e.length > 1) {
      final ptrName = e.substring(1).trim();
      final ref = env[ptrName];
      if (ref is String && ref.startsWith('@ref:')) {
        final target = ref.substring(5);
        return env[target] ?? 0;
      }
      return 0;
    }

    // Function call: funcName(arg1, arg2)
    final fnCallMatch = RegExp(r'^([A-Za-z_]\w*)\s*\((.*)\)$').firstMatch(e);
    if (fnCallMatch != null) {
      final fnName = fnCallMatch.group(1)!;
      final argsRaw = fnCallMatch.group(2)!.trim();
      final argValues = argsRaw.isEmpty
          ? <dynamic>[]
          : _splitByCommaOutsideQuotes(argsRaw)
              .map((a) => _evalExpr(a, env))
              .toList();

      // Built-in math helpers if student uses them
      if (fnName == 'sqrt' && argValues.isNotEmpty) {
        return math.sqrt(_toNum(argValues.first));
      }
      if (fnName == 'pow' && argValues.length >= 2) {
        return math.pow(_toNum(argValues[0]), _toNum(argValues[1]));
      }
      if (fnName == 'max' && argValues.length >= 2) {
        return math.max(_toNum(argValues[0]), _toNum(argValues[1]));
      }
      if (fnName == 'min' && argValues.length >= 2) {
        return math.min(_toNum(argValues[0]), _toNum(argValues[1]));
      }

      final fnDef = functions[fnName];
      if (fnDef != null) {
        final localEnv = <String, dynamic>{};
        for (int p = 0; p < fnDef.params.length; p++) {
          final param = fnDef.params[p];
          localEnv[param.name] = p < argValues.length
              ? _coerceType(param.type, argValues[p])
              : 0;
        }
        try {
          _executeBlock(fnDef.body, localEnv);
        } on _ReturnSignal catch (ret) {
          return ret.value;
        }
        return 0;
      }
    }

    // Array indexing: marks[2]
    final arrIdxMatch = RegExp(r'^([A-Za-z_]\w*)\s*\[\s*([^\]]+)\s*\]$').firstMatch(e);
    if (arrIdxMatch != null) {
      final arrName = arrIdxMatch.group(1)!;
      final idx = _toNum(_evalExpr(arrIdxMatch.group(2)!, env)).toInt();
      final list = env[arrName];
      if (list is List) {
        if (idx < 0 || idx >= list.length) {
          throw _SyntaxException(
            'Runtime Error: Array index $idx is out of range for "$arrName" (valid indexes: 0 to ${list.length - 1}).',
          );
        }
        return list[idx];
      }
    }

    // Variable or struct field lookup (e.g. s1.name or x)
    if (env.containsKey(e)) {
      final val = env[e];
      if (val is String && val.startsWith('@ref:')) {
        return '0x7ffee4b8'; // Display realistic memory address when printing pointer directly
      }
      return val;
    }

    return 0;
  }

  int _findTopLevelOp(String s, String op) {
    bool inQuote = false;
    int depth = 0;
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) inQuote = !inQuote;
      if (inQuote) continue;
      if (ch == '(' || ch == '[') depth++;
      if (ch == ')' || ch == ']') depth--;
      if (depth == 0 && ch == op) return i;
    }
    return -1;
  }

  int _findTopLevelMultiOp(String s, String op) {
    bool inQuote = false;
    int depth = 0;
    for (int i = 0; i <= s.length - op.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) inQuote = !inQuote;
      if (inQuote) continue;
      if (ch == '(' || ch == '[') depth++;
      if (ch == ')' || ch == ']') depth--;
      if (depth == 0 && s.substring(i, i + op.length) == op) return i;
    }
    return -1;
  }

  int _findTopLevelComparison(String s, String op) {
    bool inQuote = false;
    int depth = 0;
    for (int i = 0; i <= s.length - op.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) inQuote = !inQuote;
      if (inQuote) continue;
      if (ch == '(' || ch == '[') depth++;
      if (ch == ')' || ch == ']') depth--;
      if (depth == 0 && s.substring(i, i + op.length) == op) {
        if (op == '<' || op == '>') {
          if (i + 1 < s.length && s[i + 1] == '=') continue;
          if (i + 1 < s.length && s[i + 1] == op) continue;
          if (i > 0 && s[i - 1] == op) continue;
        }
        return i;
      }
    }
    return -1;
  }

  int _findLastTopLevelAddSub(String s) {
    bool inQuote = false;
    int depth = 0;
    int found = -1;
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) inQuote = !inQuote;
      if (inQuote) continue;
      if (ch == '(' || ch == '[') depth++;
      if (ch == ')' || ch == ']') depth--;
      if (depth == 0 && (ch == '+' || ch == '-')) {
        // Ignore unary sign after operator
        final prev = s.substring(0, i).trim();
        if (prev.isEmpty ||
            prev.endsWith('+') ||
            prev.endsWith('-') ||
            prev.endsWith('*') ||
            prev.endsWith('/') ||
            prev.endsWith('%')) {
          continue;
        }
        found = i;
      }
    }
    return found;
  }

  int _findLastTopLevelMulDiv(String s) {
    bool inQuote = false;
    int depth = 0;
    int found = -1;
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];
      if (ch == '"' && (i == 0 || s[i - 1] != '\\')) inQuote = !inQuote;
      if (inQuote) continue;
      if (ch == '(' || ch == '[') depth++;
      if (ch == ')' || ch == ']') depth--;
      if (depth == 0 && (ch == '*' || ch == '/' || ch == '%')) {
        final prev = s.substring(0, i).trim();
        if (prev.isEmpty) continue; // unary *p
        found = i;
      }
    }
    return found;
  }

  dynamic _coerceType(String type, dynamic val) {
    switch (type) {
      case 'int':
        return _toNum(val).toInt();
      case 'float':
      case 'double':
        return _toNum(val).toDouble();
      case 'bool':
        return _isTruthy(val);
      case 'string':
      case 'char':
        return val.toString();
      default:
        return val;
    }
  }

  num _toNum(dynamic v) {
    if (v is num) return v;
    if (v is bool) return v ? 1 : 0;
    if (v is String) return num.tryParse(v) ?? 0;
    return 0;
  }

  bool _isTruthy(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v.isNotEmpty && v != '0' && v != 'false';
    return v != null;
  }

  String _formatValue(dynamic v) {
    if (v is double) {
      if (v == v.roundToDouble()) {
        return v.toInt().toString();
      }
      return v
          .toStringAsFixed(4)
          .replaceFirst(RegExp(r'0+$'), '')
          .replaceFirst(RegExp(r'\.$'), '');
    }
    if (v is bool) return v ? '1' : '0';
    return v.toString();
  }
}
