import 'package:flutter/material.dart';
import '../data/course_data.dart';
import '../models/course_models.dart';
import '../services/storage_service.dart';
import 'about_instructor_screen.dart';
import 'cpp_editor_screen.dart';
import 'revision_screen.dart';
import 'week_detail_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  String _searchQuery = '';

  static const List<String> _tabTitles = [
    'Programming Fundamentals',
    'Offline C++ Code Editor',
    'Weekly MCQ Quizzes (150 MCQs)',
    'Quick Revision & Operators',
    'Instructor & Contact',
  ];

  void _openWeek(WeekModule week, {int tabIndex = 0}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WeekDetailScreen(
          week: week,
          initialTabIndex: tabIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: StorageService.instance,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF1F5F9),
          appBar: AppBar(
            backgroundColor: const Color(0xFF091E36),
            foregroundColor: Colors.white,
            elevation: 2,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tabTitles[_selectedIndex],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Text(
                        'By Rashid Zada • Offline Student App',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF80DEEA),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              if (_selectedIndex != 4)
                IconButton(
                  tooltip: 'Contact Instructor (Rashid Zada)',
                  onPressed: () => setState(() => _selectedIndex = 4),
                  icon: const Icon(
                    Icons.contact_phone_rounded,
                    color: Color(0xFFFFD54F),
                  ),
                ),
            ],
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildWeeksHomeTab(),
              const CppEditorScreen(),
              _buildQuizzesHubTab(),
              const RevisionScreen(),
              const AboutInstructorScreen(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (idx) =>
                setState(() => _selectedIndex = idx),
            backgroundColor: Colors.white,
            indicatorColor: const Color(0xFF00E5FF).withValues(alpha: 0.25),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF091E36),
                ),
                label: '15 Weeks',
              ),
              NavigationDestination(
                icon: Icon(Icons.code_outlined),
                selectedIcon: Icon(
                  Icons.code_rounded,
                  color: Color(0xFF091E36),
                ),
                label: 'C++ Editor',
              ),
              NavigationDestination(
                icon: Icon(Icons.quiz_outlined),
                selectedIcon: Icon(
                  Icons.quiz_rounded,
                  color: Color(0xFF091E36),
                ),
                label: 'MCQs Quiz',
              ),
              NavigationDestination(
                icon: Icon(Icons.fact_check_outlined),
                selectedIcon: Icon(
                  Icons.fact_check_rounded,
                  color: Color(0xFF091E36),
                ),
                label: 'Revision',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF091E36),
                ),
                label: 'About Me',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeeksHomeTab() {
    final completedCount = StorageService.instance.completedWeeks.length;
    final totalScore = StorageService.instance.totalQuizScore;
    final filteredWeeks = CourseData.allWeeks.where((w) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return w.title.toLowerCase().contains(q) ||
          w.learningAim.toLowerCase().contains(q) ||
          'week ${w.weekNumber}'.contains(q) ||
          w.sections.any(
            (s) =>
                s.heading.toLowerCase().contains(q) ||
                s.body.toLowerCase().contains(q),
          );
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Progress & Welcome Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF071629), Color(0xFF0E395E)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0E395E).withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'A Beginner-Friendly Guide to C++',
                            style: TextStyle(
                              color: Color(0xFF00E5FF),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '15 Teaching Weeks • Offline Course',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Instructor: Rashid Zada (Credit Hours: 3-3)',
                            style: TextStyle(
                              color: Color(0xFFFFD54F),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedIndex = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        foregroundColor: const Color(0xFF051A10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.terminal_rounded, size: 17),
                      label: const Text(
                        'C++ IDE',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _StatPill(
                      label: 'Weeks Completed',
                      value: '$completedCount / 15',
                      icon: Icons.check_circle_rounded,
                    ),
                    const SizedBox(width: 10),
                    _StatPill(
                      label: 'Total MCQ Score',
                      value: '$totalScore / 150',
                      icon: Icons.emoji_events_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Collapsible "How to Study Each Week" Card from Booklet Page 3
          Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              leading: const Icon(
                Icons.auto_stories_rounded,
                color: Color(0xFF0E395E),
              ),
              title: const Text(
                'How to Study Each Week (Booklet Guide)',
                style: TextStyle(
                  color: Color(0xFF0E395E),
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              children: [
                ...CourseData.howToStudySteps.map(
                  (step) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(
                            color: Color(0xFF0284C7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            step,
                            style: const TextStyle(
                              color: Color(0xFF334155),
                              fontSize: 13.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Search Box
          TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              hintText:
                  'Search any topic (e.g., loops, pointers, arrays, struct, cin)...',
              hintStyle: const TextStyle(fontSize: 13.5, color: Colors.black45),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: Color(0xFF0E395E),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () => setState(() => _searchQuery = ''),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // List of 15 Weeks
          ...filteredWeeks.map((week) => _buildWeekCard(week)),
        ],
      ),
    );
  }

  Widget _buildWeekCard(WeekModule week) {
    final isDone =
        StorageService.instance.completedWeeks.contains(week.weekNumber);
    final quizScore =
        StorageService.instance.bestQuizScores[week.weekNumber];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? const Color(0xFF86EFAC) : Colors.grey.shade200,
          width: isDone ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openWeek(week, tabIndex: 0),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDone
                            ? [const Color(0xFF16A34A), const Color(0xFF15803D)]
                            : [const Color(0xFF091E36), const Color(0xFF0E395E)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'WEEK',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${week.weekNumber}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          week.title,
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          week.learningAim,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF475569),
                            fontSize: 13,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF64748B),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _MiniChip(
                    icon: Icons.list_alt_rounded,
                    label: '${week.sections.length} Topics',
                    color: const Color(0xFF0E395E),
                    onTap: () => _openWeek(week, tabIndex: 0),
                  ),
                  _MiniChip(
                    icon: Icons.code_rounded,
                    label: '${week.allExamples.length} Examples + Task',
                    color: const Color(0xFF0284C7),
                    onTap: () => _openWeek(week, tabIndex: 1),
                  ),
                  _MiniChip(
                    icon: Icons.quiz_rounded,
                    label: quizScore != null
                        ? 'Quiz: $quizScore/10'
                        : '10 MCQs Quiz',
                    color: quizScore != null
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFD97706),
                    onTap: () => _openWeek(week, tabIndex: 2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizzesHubTab() {
    final scores = StorageService.instance.bestQuizScores;
    final totalScore = StorageService.instance.totalQuizScore;
    final attempted = scores.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF071629), Color(0xFF0E395E)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00E5FF),
                      width: 3,
                    ),
                  ),
                  child: Text(
                    '$totalScore\n/150',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      height: 1.15,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly 10-MCQ Assessments',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Quizzes Completed: $attempted of 15 Weeks',
                        style: const TextStyle(
                          color: Color(0xFF80DEEA),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Each week includes 10 MCQs with instant explanations and a full result report.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...CourseData.allWeeks.map((week) {
            final best = scores[week.weekNumber];
            final attempts =
                StorageService.instance.quizAttempts[week.weekNumber] ?? 0;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  backgroundColor: best != null
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF0E395E),
                  foregroundColor: Colors.white,
                  child: Text(
                    'W${week.weekNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                title: Text(
                  'Week ${week.weekNumber}: ${week.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    color: Color(0xFF0F172A),
                  ),
                ),
                subtitle: Text(
                  best != null
                      ? 'Best Score: $best / 10 (${best * 10}%) • Attempts: $attempts'
                      : '10 MCQs • Not attempted yet',
                  style: TextStyle(
                    color: best != null
                        ? const Color(0xFF15803D)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                ),
                trailing: ElevatedButton(
                  onPressed: () => _openWeek(week, tabIndex: 2),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: best != null
                        ? const Color(0xFF16A34A)
                        : const Color(0xFF0E395E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(best != null ? 'Retry' : 'Start Quiz'),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00E5FF), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MiniChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
