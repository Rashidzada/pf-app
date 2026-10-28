import 'package:flutter/material.dart';
import '../models/course_models.dart';
import '../services/storage_service.dart';

class WeekQuizWidget extends StatefulWidget {
  final WeekModule week;
  final VoidCallback? onNextWeek;

  const WeekQuizWidget({
    super.key,
    required this.week,
    this.onNextWeek,
  });

  @override
  State<WeekQuizWidget> createState() => _WeekQuizWidgetState();
}

class _WeekQuizWidgetState extends State<WeekQuizWidget> {
  int _currentIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _submitted = false;

  void _selectOption(int optionIndex) {
    if (_submitted) return;
    setState(() {
      _selectedAnswers[_currentIndex] = optionIndex;
    });
  }

  void _submitQuiz() {
    int score = 0;
    final questions = widget.week.quiz;
    for (int i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i].correctIndex) {
        score++;
      }
    }
    StorageService.instance.recordQuizResult(widget.week.weekNumber, score);
    setState(() {
      _submitted = true;
    });
  }

  void _resetQuiz() {
    setState(() {
      _selectedAnswers.clear();
      _currentIndex = 0;
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.week.quiz;
    if (_submitted) {
      return _buildResultView(questions);
    }

    final q = questions[_currentIndex];
    final selected = _selectedAnswers[_currentIndex];
    final answeredCount = _selectedAnswers.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz Header Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0E294B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF00E5FF).withValues(alpha: 0.35)),
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
                        color: const Color(0xFF00E5FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Question ${_currentIndex + 1} of ${questions.length}',
                        style: const TextStyle(
                          color: Color(0xFF071527),
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Answered: $answeredCount / ${questions.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / questions.length,
                    minHeight: 7,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00E5FF),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Quick Question Number Pills
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: questions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (_, idx) {
                      final isCur = idx == _currentIndex;
                      final isAns = _selectedAnswers.containsKey(idx);
                      return InkWell(
                        onTap: () => setState(() => _currentIndex = idx),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isCur
                                ? const Color(0xFFFFC400)
                                : (isAns
                                      ? const Color(0xFF00E676).withValues(alpha: 0.25)
                                      : Colors.white10),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isCur
                                  ? const Color(0xFFFFC400)
                                  : (isAns
                                        ? const Color(0xFF00E676)
                                        : Colors.white24),
                            ),
                          ),
                          child: Text(
                            '${idx + 1}',
                            style: TextStyle(
                              color: isCur ? const Color(0xFF071527) : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Question Text Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q${_currentIndex + 1}. ${q.question}',
                  style: const TextStyle(
                    color: Color(0xFF0D233A),
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    height: 1.38,
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(q.options.length, (optIdx) {
                  final isChosen = selected == optIdx;
                  final isCorrect = optIdx == q.correctIndex;
                  final showInstantFeedback = selected != null;

                  Color borderColor = Colors.grey.shade300;
                  Color bgColor = const Color(0xFFF8FAFC);
                  Color badgeColor = const Color(0xFFE2E8F0);
                  Color badgeTextColor = const Color(0xFF1E293B);

                  if (showInstantFeedback) {
                    if (isCorrect) {
                      borderColor = const Color(0xFF16A34A);
                      bgColor = const Color(0xFFDCFCE7);
                      badgeColor = const Color(0xFF16A34A);
                      badgeTextColor = Colors.white;
                    } else if (isChosen) {
                      borderColor = const Color(0xFFDC2626);
                      bgColor = const Color(0xFFFEE2E2);
                      badgeColor = const Color(0xFFDC2626);
                      badgeTextColor = Colors.white;
                    }
                  }

                  final optionLetter = String.fromCharCode(65 + optIdx);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () => _selectOption(optIdx),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: 1.6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: badgeColor,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                optionLetter,
                                style: TextStyle(
                                  color: badgeTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  q.options[optIdx],
                                  style: const TextStyle(
                                    color: Color(0xFF0F172A),
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ),
                            if (showInstantFeedback && isCorrect)
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF16A34A),
                                size: 22,
                              )
                            else if (showInstantFeedback && isChosen && !isCorrect)
                              const Icon(
                                Icons.cancel_rounded,
                                color: Color(0xFFDC2626),
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                // Instant Explanation Box once Student Picks an Option
                if (selected != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected == q.correctIndex
                          ? const Color(0xFFF0FDF4)
                          : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected == q.correctIndex
                            ? const Color(0xFF86EFAC)
                            : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          selected == q.correctIndex
                              ? Icons.verified_rounded
                              : Icons.info_outline_rounded,
                          color: selected == q.correctIndex
                              ? const Color(0xFF15803D)
                              : const Color(0xFFB45309),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            q.explanation,
                            style: const TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Navigation & Finish Buttons
          Row(
            children: [
              if (_currentIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() => _currentIndex--),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Color(0xFF0E395E)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: const Text('Previous'),
                  ),
                ),
              if (_currentIndex > 0) const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _currentIndex < questions.length - 1
                    ? ElevatedButton.icon(
                        onPressed: () => setState(() => _currentIndex++),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E395E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text(
                          'Next Question',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: _submitQuiz,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF16A34A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.emoji_events_rounded, size: 20),
                        label: const Text(
                          'Show Quiz Result',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          if (answeredCount == questions.length &&
              _currentIndex < questions.length - 1) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.done_all_rounded),
                label: const Text(
                  'All 10 Answered — View Final Result',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultView(List<McqQuestion> questions) {
    int correctCount = 0;
    for (int i = 0; i < questions.length; i++) {
      if (_selectedAnswers[i] == questions[i].correctIndex) {
        correctCount++;
      }
    }
    final int total = questions.length;
    final int percent = ((correctCount / total) * 100).round();

    String gradeTitle;
    String gradeMessage;
    Color gradeColor;

    if (correctCount >= 9) {
      gradeTitle = 'Outstanding! (Grade A+)';
      gradeMessage =
          'Excellent mastery of Week ${widget.week.weekNumber}: ${widget.week.title}!';
      gradeColor = const Color(0xFF16A34A);
    } else if (correctCount >= 7) {
      gradeTitle = 'Well Done! (Grade B+)';
      gradeMessage =
          'Great job! Review the explanations below to reach 10/10.';
      gradeColor = const Color(0xFF0284C7);
    } else if (correctCount >= 5) {
      gradeTitle = 'Good Effort! (Passed)';
      gradeMessage =
          'You passed! Re-read the lesson notes and try the quiz again.';
      gradeColor = const Color(0xFFD97706);
    } else {
      gradeTitle = 'Keep Practicing!';
      gradeMessage =
          'Review Week ${widget.week.weekNumber} examples and retake the quiz to improve.';
      gradeColor = const Color(0xFFDC2626);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Score Summary Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF081C33), Color(0xFF0E395E)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Text(
                  'WEEK ${widget.week.weekNumber} QUIZ RESULT',
                  style: const TextStyle(
                    color: Color(0xFF80DEEA),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 108,
                  height: 108,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: const Color(0xFF00E5FF),
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$correctCount / $total',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: const TextStyle(
                          color: Color(0xFFFFD54F),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: gradeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    gradeTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  gradeMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetQuiz,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.replay_rounded, size: 18),
                        label: const Text('Retake Quiz'),
                      ),
                    ),
                    if (widget.onNextWeek != null) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onNextWeek,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00E5FF),
                            foregroundColor: const Color(0xFF071527),
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.skip_next_rounded, size: 18),
                          label: const Text(
                            'Next Week',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            'Detailed Answer Key & Explanations',
            style: TextStyle(
              color: Color(0xFF0D233A),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),

          ...List.generate(questions.length, (idx) {
            final q = questions[idx];
            final userAns = _selectedAnswers[idx];
            final isRight = userAns == q.correctIndex;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isRight
                      ? const Color(0xFF86EFAC)
                      : const Color(0xFFFCA5A5),
                  width: 1.4,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isRight
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        color: isRight
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Q${idx + 1}. ${q.question}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.5,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!isRight)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Your Answer: ${userAns != null ? q.options[userAns] : "Not Answered"}',
                        style: const TextStyle(
                          color: Color(0xFFDC2626),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Text(
                    'Correct Answer: ${q.options[q.correctIndex]}',
                    style: const TextStyle(
                      color: Color(0xFF15803D),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Explanation: ${q.explanation}',
                    style: const TextStyle(
                      color: Color(0xFF475569),
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
