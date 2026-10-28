import '../models/course_models.dart';
import 'weeks_1_to_8.dart';
import 'weeks_9_to_15.dart';

class CourseData {
  static const String courseTitle = 'Programming Fundamentals';
  static const String courseSubtitle =
      'A Beginner-Friendly Guide to C++ and Problem Solving';
  static const String creditHours = '3-3';
  static const String coverage = 'Weeks 1 to 15 of the provided syllabus';

  // Instructor Info
  static const String instructorName = 'Rashid Zada';
  static const String instructorRole =
      'Instructor & Full Stack Developer (Python, Java, C++, AI)';
  static const String instructorBio =
      'Passionate Full Stack Developer and Computer Science Instructor specializing in Python, Java, C++, Artificial Intelligence, and modern software development. Dedicated to making programming simple, practical, and logical for students.';
  static const String instructorEmail = 'rashidzada6@gmail.com';
  static const String instructorWhatsappDisplay = '03470983567';
  static const String instructorWhatsappIntl = '923470983567';

  static const List<String> instructorSkills = [
    'Python',
    'Java',
    'C++',
    'Artificial Intelligence (AI)',
    'Full Stack Development',
    'Mobile App Development (Flutter)',
    'Algorithms & Problem Solving',
    'Data Structures & Databases',
  ];

  static const String aboutBooklet =
      'This small book follows the 15 teaching weeks in the supplied Programming Fundamentals syllabus. Each week uses simple explanations, a short C++ example, expected output, and a practice task. It is designed for first-semester learners and for quick revision before class or examinations.';

  static const List<String> howToStudySteps = [
    'Read the main idea and learn the key words.',
    'Trace the example line by line before running it.',
    'Predict the output, then compare it with the output shown.',
    'Try the practice task yourself and test your program.',
  ];

  static const List<String> revisionChecklist = [
    'I can explain the difference between a problem, an algorithm, pseudocode, and a program.',
    'I can identify input, process, and output.',
    'I can declare variables and choose suitable data types.',
    'I can use cin and cout.',
    'I can use arithmetic, comparison, and logical operators.',
    'I can write if, if-else, else-if, and switch statements.',
    'I can use for, while, and do-while loops.',
    'I understand break and continue.',
    'I can define and call a simple function.',
    'I can store similar values in an array.',
    'I can explain what a pointer stores and what & and * do.',
    'I can group different fields in a struct.',
    'I can write to a file using ofstream.',
    'I can test a program and identify syntax, runtime, and logical errors.',
  ];

  static const List<OperatorReminder> operatorReminders = [
    OperatorReminder(
      operators: '+  -  *  /  %',
      meaning: 'Arithmetic',
      example: '10 % 3 gives 1',
    ),
    OperatorReminder(
      operators: '=  +=  -=  *=  /=',
      meaning: 'Assignment',
      example: 'x += 2 adds 2 to x',
    ),
    OperatorReminder(
      operators: '==  !=  >  <  >=  <=',
      meaning: 'Comparison',
      example: 'x >= 5',
    ),
    OperatorReminder(
      operators: '&&  ||  !',
      meaning: 'Logical',
      example: '(age >= 18) && (age < 60)',
    ),
    OperatorReminder(
      operators: '++  --',
      meaning: 'Increase / decrease by one',
      example: 'i++',
    ),
    OperatorReminder(
      operators: '?:',
      meaning: 'Conditional choice',
      example: 'x > 0 ? 1 : 0',
    ),
  ];

  static const List<String> suggestedReading = [
    'Tony Gaddis, Starting Out with Programming Logic and Design.',
    'Brian W. Kernighan and Dennis M. Ritchie, The C Programming Language.',
    'Robert Lafore, Object-Oriented Programming in C++.',
    'Paul Deitel and Harvey Deitel, C How to Program.',
    'Jeri R. Hanly and Elliot B. Koffman, Problem Solving and Program Design in C++.',
  ];

  static const String finalAdvice =
      'Do not try to memorize code without understanding it. First explain the steps in your own words, then write the code, run it, and test it with different inputs. Practice a little every day.';

  static const String backCoverMotto =
      'THINK LOGICALLY.\nWRITE CLEARLY.\nTEST CAREFULLY.';

  static const String backCoverQuote =
      'Programming is not only typing code. It is learning how to break a problem into small steps and turn those steps into a working solution.';

  static final List<WeekModule> allWeeks = [
    ...weeks1To8,
    ...weeks9To15,
  ];
}
