class ConceptSection {
  final int number;
  final String heading;
  final String body;

  const ConceptSection({
    required this.number,
    required this.heading,
    required this.body,
  });
}

class CodeExample {
  final String title;
  final String description;
  final String code;
  final String sampleInput;
  final String expectedOutput;
  final String explanation;
  final bool isFromPdf;

  const CodeExample({
    required this.title,
    required this.description,
    required this.code,
    this.sampleInput = '',
    required this.expectedOutput,
    required this.explanation,
    this.isFromPdf = false,
  });
}

class PracticeTask {
  final String prompt;
  final String hint;
  final String solutionCode;
  final String sampleInput;
  final String expectedOutput;

  const PracticeTask({
    required this.prompt,
    required this.hint,
    required this.solutionCode,
    this.sampleInput = '',
    required this.expectedOutput,
  });
}

class McqQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const McqQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class WeekModule {
  final int weekNumber;
  final String title;
  final String learningAim;
  final List<ConceptSection> sections;
  final CodeExample pdfExample;
  final List<CodeExample> extraExamples;
  final PracticeTask practiceTask;
  final String rememberTip;
  final List<McqQuestion> quiz;

  const WeekModule({
    required this.weekNumber,
    required this.title,
    required this.learningAim,
    required this.sections,
    required this.pdfExample,
    required this.extraExamples,
    required this.practiceTask,
    required this.rememberTip,
    required this.quiz,
  });

  List<CodeExample> get allExamples => [pdfExample, ...extraExamples];
}

class OperatorReminder {
  final String operators;
  final String meaning;
  final String example;

  const OperatorReminder({
    required this.operators,
    required this.meaning,
    required this.example,
  });
}
