import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/course_data.dart';
import '../models/course_models.dart';
import '../services/storage_service.dart';
import 'cpp_editor_screen.dart';
import 'week_quiz_widget.dart';

class WeekDetailScreen extends StatefulWidget {
  final WeekModule week;
  final int initialTabIndex;

  const WeekDetailScreen({
    super.key,
    required this.week,
    this.initialTabIndex = 0,
  });

  @override
  State<WeekDetailScreen> createState() => _WeekDetailScreenState();
}

class _WeekDetailScreenState extends State<WeekDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showPracticeHint = false;
  bool _showPracticeSolution = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openCodeInEditor(String title, String code, String sampleInput) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CppEditorScreen(
          initialTitle: title,
          initialCode: code,
          initialInput: sampleInput,
          isStandalonePage: true,
        ),
      ),
    );
  }

  void _goToNextWeek() {
    final nextNum = widget.week.weekNumber + 1;
    if (nextNum <= CourseData.allWeeks.length) {
      final nextWeek = CourseData.allWeeks[nextNum - 1];
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => WeekDetailScreen(week: nextWeek),
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final week = widget.week;
    return ListenableBuilder(
      listenable: StorageService.instance,
      builder: (context, _) {
        final isDone = StorageService.instance.completedWeeks.contains(
          week.weekNumber,
        );
        final bestScore =
            StorageService.instance.bestQuizScores[week.weekNumber];

        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          appBar: AppBar(
            backgroundColor: const Color(0xFF091E36),
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WEEK ${week.weekNumber} OF 15',
                  style: const TextStyle(
                    color: Color(0xFF00E5FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  week.title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: isDone ? 'Completed' : 'Mark Week Completed',
                onPressed: () {
                  StorageService.instance.toggleWeekCompleted(week.weekNumber);
                },
                icon: Icon(
                  isDone
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                  color: isDone ? const Color(0xFF00E676) : Colors.white70,
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF00E5FF),
              indicatorWeight: 3,
              labelColor: const Color(0xFF00E5FF),
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
              tabs: [
                const Tab(
                  icon: Icon(Icons.menu_book_rounded, size: 18),
                  text: 'Lesson',
                ),
                Tab(
                  icon: const Icon(Icons.code_rounded, size: 18),
                  text: 'Examples (${week.allExamples.length})',
                ),
                Tab(
                  icon: const Icon(Icons.quiz_rounded, size: 18),
                  text: bestScore != null
                      ? '10 MCQs ($bestScore/10)'
                      : '10 MCQs',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildLessonTab(week, isDone),
              _buildExamplesAndPracticeTab(week),
              WeekQuizWidget(
                week: week,
                onNextWeek: week.weekNumber < 15 ? _goToNextWeek : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLessonTab(WeekModule week, bool isDone) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Learning Aim Box (Matches PDF Booklet style)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF00838F),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.flag_rounded,
                  color: Color(0xFF006064),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'LEARNING AIM',
                        style: TextStyle(
                          color: Color(0xFF006064),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        week.learningAim,
                        style: const TextStyle(
                          color: Color(0xFF004D40),
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Numbered Concept Sections from Booklet
          ...week.sections.map(
            (sec) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E395E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${sec.number}',
                          style: const TextStyle(
                            color: Color(0xFF00E5FF),
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          sec.heading,
                          style: const TextStyle(
                            color: Color(0xFF0E395E),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    sec.body,
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 14.5,
                      height: 1.48,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Remember Callout Card from PDF
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF091E36), Color(0xFF10345B)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFFFFC400),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REMEMBER',
                        style: TextStyle(
                          color: Color(0xFFFFD54F),
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.9,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        week.rememberTip,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Buttons to Continue to Examples or Mark Completed
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    StorageService.instance.toggleWeekCompleted(week.weekNumber);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: BorderSide(
                      color: isDone
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF0E395E),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    isDone
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: isDone
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF0E395E),
                  ),
                  label: Text(
                    isDone ? 'Week Completed' : 'Mark Completed',
                    style: TextStyle(
                      color: isDone
                          ? const Color(0xFF16A34A)
                          : const Color(0xFF0E395E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _tabController.animateTo(1),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E395E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.code_rounded),
                  label: const Text(
                    'View Examples',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesAndPracticeTab(WeekModule week) {
    final examples = week.allExamples;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(examples.length, (idx) {
            final ex = examples[idx];
            return _buildCodeExampleCard(week.weekNumber, ex, idx + 1);
          }),

          const SizedBox(height: 8),

          // "Try It Yourself" Practice Task Card from Booklet
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF59E0B),
                width: 1.6,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'TRY IT YOURSELF (BOOKLET TASK)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  week.practiceTask.prompt,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _showPracticeHint = !_showPracticeHint);
                      },
                      icon: const Icon(Icons.tips_and_updates_rounded, size: 17),
                      label: Text(_showPracticeHint ? 'Hide Hint' : 'Show Hint'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(
                          () => _showPracticeSolution = !_showPracticeSolution,
                        );
                      },
                      icon: const Icon(Icons.visibility_rounded, size: 17),
                      label: Text(
                        _showPracticeSolution
                            ? 'Hide Solution'
                            : 'Show Solution',
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openCodeInEditor(
                        'W${week.weekNumber} Practice Task',
                        week.practiceTask.solutionCode,
                        week.practiceTask.sampleInput,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E395E),
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.play_arrow_rounded, size: 18),
                      label: const Text('Open & Run in C++ Editor'),
                    ),
                  ],
                ),
                if (_showPracticeHint) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Text(
                      'Hint: ${week.practiceTask.hint}',
                      style: const TextStyle(
                        color: Color(0xFF92400E),
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                if (_showPracticeSolution) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF071324),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SelectableText(
                      week.practiceTask.solutionCode,
                      style: const TextStyle(
                        color: Color(0xFFE2F1FF),
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Expected Output:\n${week.practiceTask.expectedOutput}',
                    style: const TextStyle(
                      color: Color(0xFF065F46),
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(2),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.quiz_rounded),
              label: Text(
                'Take Week ${week.weekNumber} Quiz (10 MCQs)',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExampleCard(int weekNum, CodeExample ex, int index) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ex.isFromPdf
              ? const Color(0xFF0284C7)
              : Colors.grey.shade300,
          width: ex.isFromPdf ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: ex.isFromPdf
                  ? const Color(0xFF0E395E)
                  : const Color(0xFF1E293B),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  ex.isFromPdf ? Icons.menu_book_rounded : Icons.code_rounded,
                  color: const Color(0xFF00E5FF),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    ex.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Copy Code',
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: ex.code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code copied to clipboard!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: Colors.white70,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ex.description,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                // Code Block
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFF071324),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    ex.code,
                    style: const TextStyle(
                      color: Color(0xFFE2F1FF),
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Expected Result Box (matching PDF teal style)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF00ACC1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ex.sampleInput.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            'Sample Input: ${ex.sampleInput}',
                            style: const TextStyle(
                              color: Color(0xFF006064),
                              fontFamily: 'monospace',
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      Text(
                        'Expected Result:\n${ex.expectedOutput}',
                        style: const TextStyle(
                          color: Color(0xFF004D40),
                          fontFamily: 'monospace',
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  'How it works: ${ex.explanation}',
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 13,
                    height: 1.38,
                  ),
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () => _openCodeInEditor(
                      'W$weekNum: ${ex.title}',
                      ex.code,
                      ex.sampleInput,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      foregroundColor: const Color(0xFF051A10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text(
                      'Run & Edit in C++ Editor',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
