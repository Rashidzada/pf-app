import 'package:flutter_test/flutter_test.dart';
import 'package:pf_app/data/course_data.dart';
import 'package:pf_app/main.dart';
import 'package:pf_app/services/cpp_simulator.dart';

void main() {
  test('All 15 weeks have 4 examples, practice task, and 10 MCQs, and all examples execute cleanly', () {
    expect(CourseData.allWeeks.length, 15);
    for (final week in CourseData.allWeeks) {
      expect(week.quiz.length, 10, reason: 'Week ${week.weekNumber} should have 10 MCQs');
      expect(week.allExamples.length, 4, reason: 'Week ${week.weekNumber} should have 4 examples');

      for (final ex in week.allExamples) {
        final res = CppSimulator.execute(ex.code, rawInput: ex.sampleInput);
        expect(
          res.success,
          isTrue,
          reason:
              'Week ${week.weekNumber} example "${ex.title}" failed: ${res.errorMessage}',
        );
        expect(res.output.trim(), isNotEmpty);
      }

      final pracRes = CppSimulator.execute(
        week.practiceTask.solutionCode,
        rawInput: week.practiceTask.sampleInput,
      );
      expect(
        pracRes.success,
        isTrue,
        reason:
            'Week ${week.weekNumber} practice solution failed: ${pracRes.errorMessage}',
      );
    }
  });

  testWidgets('Splash screen renders and transitions to MainShell', (WidgetTester tester) async {
    await tester.pumpWidget(const ProgrammingFundamentalsApp());
    expect(find.textContaining('PROGRAMMING'), findsWidgets);
    expect(find.textContaining('Rashid Zada'), findsWidgets);

    await tester.tap(find.text('Start Learning C++'));
    await tester.pumpAndSettle();

    expect(find.text('15 Weeks'), findsOneWidget);
    expect(find.text('C++ Editor'), findsOneWidget);
  });
}
