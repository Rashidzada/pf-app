import '../models/course_models.dart';

const List<WeekModule> weeks1To8 = [
  // ==================== WEEK 1 ====================
  WeekModule(
    weekNumber: 1,
    title: 'Overview of Computer Programming',
    learningAim:
        'Understand programming, why it is used, and how structured and modular programming help organize solutions.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'What is programming?',
        body:
            'Programming means giving a computer clear instructions, written as code, to perform a task. Computers follow instructions exactly, so the instructions must be logical and correctly written.',
      ),
      ConceptSection(
        number: 2,
        heading: 'Why do we program?',
        body:
            'We use programs to solve problems, perform repeated tasks quickly, process information, and build applications, games, and websites. Common languages include C, C++, Java, and Python.',
      ),
      ConceptSection(
        number: 3,
        heading: 'Structured programming',
        body:
            'Structured programming organizes a solution into clear steps. Its three basic control structures are sequence (steps in order), selection (choosing based on a condition), and repetition (repeating steps).',
      ),
      ConceptSection(
        number: 4,
        heading: 'Modular programming',
        body:
            'Modular programming divides a large program into smaller parts, often functions. Each part performs a particular task, such as receiving input, calculating a result, or displaying output. Smaller parts are easier to test and reuse.',
      ),
      ConceptSection(
        number: 5,
        heading: 'Problem-solving path',
        body:
            'Understand the problem, identify input and output, plan the solution, write code, run it, test it, and correct errors.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: A simple output program',
      description: 'Displays a welcome message on the screen using cout.',
      code: '''#include <iostream>
using namespace std;

int main() {
    cout << "Welcome to C++";
    return 0;
}''',
      expectedOutput: 'Welcome to C++',
      explanation:
          '#include <iostream> includes the input/output library. main() is the starting point of every C++ program, and cout << sends text to the screen.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: Printing Multiple Lines with endl',
        description: 'Shows how to print multiple lines of text neatly using endl.',
        code: '''#include <iostream>
using namespace std;

int main() {
    cout << "Course: Programming Fundamentals" << endl;
    cout << "Instructor: Rashid Zada" << endl;
    cout << "Language: C++" << endl;
    return 0;
}''',
        expectedOutput: '''Course: Programming Fundamentals
Instructor: Rashid Zada
Language: C++''',
        explanation:
            'endl moves the cursor to a new line after printing each message.',
      ),
      CodeExample(
        title: 'Example 3: Sequence of Steps in Order',
        description: 'Demonstrates structured sequence execution from top to bottom.',
        code: '''#include <iostream>
using namespace std;

int main() {
    cout << "Step 1: Understand the problem" << endl;
    cout << "Step 2: Plan the solution" << endl;
    cout << "Step 3: Write and test C++ code" << endl;
    return 0;
}''',
        expectedOutput: '''Step 1: Understand the problem
Step 2: Plan the solution
Step 3: Write and test C++ code''',
        explanation:
            'In sequence structure, C++ executes statements one after another from top to bottom.',
      ),
      CodeExample(
        title: 'Example 4: Displaying a Formatted Welcome Card',
        description: 'Uses text borders to print a clean student welcome card.',
        code: '''#include <iostream>
using namespace std;

int main() {
    cout << "==============================" << endl;
    cout << "   WELCOME TO FIRST SEMESTER  " << endl;
    cout << "   Department of CS & IT      " << endl;
    cout << "==============================" << endl;
    return 0;
}''',
        expectedOutput: '''==============================
   WELCOME TO FIRST SEMESTER  
   Department of CS & IT      
==============================''',
        explanation:
            'You can combine multiple cout statements to format console output clearly.',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Write a program that displays your name and your department.',
      hint: 'Use cout << with endl to display your name on the first line and your department on the second line.',
      solutionCode: '''#include <iostream>
using namespace std;

int main() {
    cout << "Name: Ali Khan" << endl;
    cout << "Department: Computer Science" << endl;
    return 0;
}''',
      expectedOutput: '''Name: Ali Khan
Department: Computer Science''',
    ),
    rememberTip:
        'Programming begins with logical thinking. Code is the way we express that thinking to a computer.',
    quiz: [
      McqQuestion(
        question: 'What does computer programming mean?',
        options: [
          'Giving a computer clear instructions written as code to perform a task',
          'Repairing computer hardware components',
          'Browsing websites on the internet',
          'Drawing pictures on paper only',
        ],
        correctIndex: 0,
        explanation:
            'Programming means giving a computer clear, logical instructions written as code to perform a task.',
      ),
      McqQuestion(
        question: 'Which of the following is NOT one of the three basic control structures of structured programming?',
        options: ['Sequence', 'Selection', 'Repetition', 'Compilation'],
        correctIndex: 3,
        explanation:
            'The three basic control structures in structured programming are sequence, selection, and repetition.',
      ),
      McqQuestion(
        question: 'What is modular programming?',
        options: [
          'Writing the entire program on a single line',
          'Dividing a large program into smaller, manageable parts (often functions)',
          'Running a program without a compiler',
          'Deleting all variables from a program',
        ],
        correctIndex: 1,
        explanation:
            'Modular programming divides a large program into smaller parts (functions) that are easier to test and reuse.',
      ),
      McqQuestion(
        question: 'Which function is the required starting point of every C++ program?',
        options: ['start()', 'program()', 'main()', 'begin()'],
        correctIndex: 2,
        explanation: 'Every C++ program begins execution from the main() function.',
      ),
      McqQuestion(
        question: 'Which header file is needed to use cout in C++?',
        options: ['#include <iostream>', '#include <math.h>', '#include <stdio>', '#include <file>'],
        correctIndex: 0,
        explanation: '#include <iostream> provides standard input and output streams like cin and cout.',
      ),
      McqQuestion(
        question: 'What does cout << "Welcome to C++"; do?',
        options: [
          'Takes input from the keyboard',
          'Displays Welcome to C++ on the screen',
          'Closes the C++ compiler',
          'Saves a file to disk',
        ],
        correctIndex: 1,
        explanation: 'cout with the << insertion operator displays output on the screen.',
      ),
      McqQuestion(
        question: 'What is the first step in the problem-solving path?',
        options: [
          'Write code immediately',
          'Understand the problem',
          'Compile the program',
          'Delete syntax errors',
        ],
        correctIndex: 1,
        explanation:
            'The problem-solving path starts with understanding the problem and identifying input and output before writing code.',
      ),
      McqQuestion(
        question: 'What is the purpose of return 0; at the end of int main()?',
        options: [
          'It restarts the computer',
          'It indicates that the program ended successfully',
          'It prints the number 0 on the screen',
          'It deletes the output',
        ],
        correctIndex: 1,
        explanation: 'return 0; tells the operating system that main() finished successfully.',
      ),
      McqQuestion(
        question: 'In structured programming, what does "sequence" mean?',
        options: [
          'Repeating steps forever',
          'Executing steps in order, one after another',
          'Choosing between two branches',
          'Jumping randomly between files',
        ],
        correctIndex: 1,
        explanation: 'Sequence means steps are executed in order, one after another.',
      ),
      McqQuestion(
        question: 'Which symbol is required at the end of a C++ output statement like cout << "Hi";?',
        options: ['Colon (:)', 'Period (.)', 'Semicolon (;)', 'Comma (,)'],
        correctIndex: 2,
        explanation: 'In C++, statements end with a semicolon (;).',
      ),
    ],
  ),

  // ==================== WEEK 2 ====================
  WeekModule(
    weekNumber: 2,
    title: 'Designing, Testing, and Translating an Algorithm',
    learningAim: 'Plan a solution before coding, represent it clearly, and translate it into C++.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'Analyze the problem',
        body:
            'First decide what the problem asks for. Identify the input, the process, and the output. This prevents confusion during coding.',
      ),
      ConceptSection(
        number: 2,
        heading: 'Design the algorithm',
        body:
            'An algorithm is a finite sequence of clear steps for solving a problem. A good algorithm should be understandable and should finish after a limited number of steps.',
      ),
      ConceptSection(
        number: 3,
        heading: 'Pseudocode',
        body:
            'Pseudocode describes an algorithm in simple, code-like language. It focuses on logic and does not require the exact syntax of C++.',
      ),
      ConceptSection(
        number: 4,
        heading: 'Flowchart',
        body:
            'A flowchart draws the steps using symbols and arrows. Common symbols are an oval for Start/Stop, a parallelogram for input/output, a rectangle for processing, and a diamond for a decision.',
      ),
      ConceptSection(
        number: 5,
        heading: 'Test the designed solution',
        body:
            'Try sample inputs and check whether the result is correct. Include more than one test when possible, such as small values and values that create different outcomes.',
      ),
      ConceptSection(
        number: 6,
        heading: 'Translate into C++',
        body:
            'After checking the logic, write the statements using C++ syntax, compile, run, and debug the program.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: Add two numbers (Algorithm & Pseudocode)',
      description: 'Step-by-step algorithm and pseudocode for adding two numbers A and B.',
      code: '''Algorithm:
1. Start
2. Input A and B
3. Sum = A + B
4. Display Sum
5. Stop

Pseudocode:
Start
    Input A, B
    Sum = A + B
    Output Sum
End''',
      sampleInput: '4 7',
      expectedOutput: 'If A = 4 and B = 7, the expected sum is 11.',
      explanation:
          'Before writing C++, we write the algorithm and pseudocode to verify that Input -> Process -> Output logic is clear.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: Translating the Addition Algorithm into C++',
        description: 'Shows the exact C++ translation of the booklet addition algorithm.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int A = 4;
    int B = 7;
    int Sum = A + B;
    cout << "A = " << A << ", B = " << B << endl;
    cout << "Expected Sum = " << Sum << endl;
    return 0;
}''',
        expectedOutput: '''A = 4, B = 7
Expected Sum = 11''',
        explanation:
            'Each step of the pseudocode (Input A, B -> Sum = A + B -> Output Sum) maps directly to C++ statements.',
      ),
      CodeExample(
        title: 'Example 3: Algorithm & C++ to Find Average of 3 Numbers',
        description: 'Plans and translates the calculation of the average of three marks.',
        code: '''#include <iostream>
using namespace std;

int main() {
    // Step 1: Input three numbers
    int m1 = 80, m2 = 90, m3 = 70;
    // Step 2: Process average
    int total = m1 + m2 + m3;
    int average = total / 3;
    // Step 3: Output result
    cout << "Total = " << total << endl;
    cout << "Average = " << average << endl;
    return 0;
}''',
        expectedOutput: '''Total = 240
Average = 80''',
        explanation:
            'Testing with known values (80, 90, 70) confirms our formula gives 240 / 3 = 80.',
      ),
      CodeExample(
        title: 'Example 4: Converting Celsius to Fahrenheit',
        description: 'Demonstrates Input -> Formula Process -> Output translation.',
        code: '''#include <iostream>
using namespace std;

int main() {
    double celsius = 25;
    double fahrenheit = (celsius * 9 / 5) + 32;
    cout << celsius << " C = " << fahrenheit << " F" << endl;
    return 0;
}''',
        expectedOutput: '25 C = 77 F',
        explanation:
            'When 25 C is tested in the formula (25 * 9 / 5) + 32, we get 77 F.',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Write an algorithm and pseudocode (and test in C++) to find the area of a rectangle.',
      hint: 'Input Length and Width, calculate Area = Length * Width, and display Area.',
      solutionCode: '''#include <iostream>
using namespace std;

// Algorithm:
// 1. Start
// 2. Input length and width
// 3. Area = length * width
// 4. Display Area
// 5. Stop

int main() {
    int length = 6;
    int width = 4;
    int area = length * width;
    cout << "Area of rectangle = " << area << endl;
    return 0;
}''',
      expectedOutput: 'Area of rectangle = 24',
    ),
    rememberTip: 'Plan first, then code. Testing the plan can save time later.',
    quiz: [
      McqQuestion(
        question: 'What is an algorithm?',
        options: [
          'A finite sequence of clear steps for solving a problem',
          'A type of computer monitor',
          'An infinite loop that never ends',
          'A syntax error in C++',
        ],
        correctIndex: 0,
        explanation:
            'An algorithm is a finite sequence of clear, understandable steps that finishes in a limited number of steps.',
      ),
      McqQuestion(
        question: 'What is pseudocode?',
        options: [
          'Machine binary code made of 0s and 1s',
          'A description of an algorithm in simple, code-like language focusing on logic',
          'A hardware circuit diagram',
          'A compiled .exe file',
        ],
        correctIndex: 1,
        explanation:
            'Pseudocode describes an algorithm in simple, code-like language without requiring strict C++ syntax.',
      ),
      McqQuestion(
        question: 'In a flowchart, which symbol is used for Start and Stop?',
        options: ['Rectangle', 'Diamond', 'Oval', 'Parallelogram'],
        correctIndex: 2,
        explanation: 'An oval symbol represents Start/Stop in a standard flowchart.',
      ),
      McqQuestion(
        question: 'In a flowchart, which symbol represents Input and Output?',
        options: ['Parallelogram', 'Oval', 'Diamond', 'Circle'],
        correctIndex: 0,
        explanation: 'A parallelogram is used for input and output operations in flowcharts.',
      ),
      McqQuestion(
        question: 'In a flowchart, what is a rectangle used for?',
        options: ['Decision making', 'Start/Stop', 'Processing / Calculations', 'Input/Output'],
        correctIndex: 2,
        explanation: 'A rectangle represents processing or calculation steps (such as Sum = A + B).',
      ),
      McqQuestion(
        question: 'Which flowchart symbol is used for a decision (true/false condition)?',
        options: ['Diamond', 'Rectangle', 'Oval', 'Arrow'],
        correctIndex: 0,
        explanation: 'A diamond symbol represents a decision point in a flowchart.',
      ),
      McqQuestion(
        question: 'When analyzing a problem before coding, what three parts should you identify?',
        options: [
          'Keyboard, Mouse, and Screen',
          'Input, Process, and Output',
          'Folders, Files, and Icons',
          'Font, Color, and Size',
        ],
        correctIndex: 1,
        explanation: 'Identifying Input, Process, and Output prevents confusion during coding.',
      ),
      McqQuestion(
        question: 'If A = 4 and B = 7 in the algorithm Sum = A + B, what is the expected output?',
        options: ['28', '3', '11', '47'],
        correctIndex: 2,
        explanation: '4 + 7 = 11.',
      ),
      McqQuestion(
        question: 'Why should we test a designed algorithm with sample inputs before coding?',
        options: [
          'To check whether the logic produces the correct result and save time later',
          'Because C++ cannot add numbers',
          'To make the program run slower',
          'To avoid using variables',
        ],
        correctIndex: 0,
        explanation: 'Testing the plan with sample inputs catches logic mistakes early and saves time.',
      ),
      McqQuestion(
        question: 'What is the correct formula to calculate the area of a rectangle in pseudocode?',
        options: [
          'Area = Length + Width',
          'Area = Length * Width',
          'Area = Length - Width',
          'Area = Length / Width',
        ],
        correctIndex: 1,
        explanation: 'The area of a rectangle is Length multiplied by Width (Length * Width).',
      ),
    ],
  ),

  // ==================== WEEK 3 ====================
  WeekModule(
    weekNumber: 3,
    title: 'Algorithms into Programs',
    learningAim: 'Convert a step-by-step plan into a working C++ program.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'From logic to code',
        body:
            'An algorithm explains what steps to follow. A program expresses those steps in a programming language so the computer can execute them.',
      ),
      ConceptSection(
        number: 2,
        heading: 'Identify input, process, and output',
        body:
            'Input is the information supplied to a program. Process is the work done with that information. Output is the result shown to the user.',
      ),
      ConceptSection(
        number: 3,
        heading: 'Translate each step',
        body:
            'Input steps commonly use cin, calculations use assignment and operators, and output steps commonly use cout.',
      ),
      ConceptSection(
        number: 4,
        heading: 'Compile, run, and debug',
        body:
            'Compilation checks whether the code follows language rules. Running executes the program. Testing compares the actual output with the expected output; debugging fixes the cause of a problem.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: Convert an algorithm into C++',
      description: 'Reads two numbers using cin, calculates their sum, and displays the result.',
      code: '''#include <iostream>
using namespace std;

int main() {
    int a, b, sum;
    cout << "Enter two numbers: ";
    cin >> a >> b;
    sum = a + b;
    cout << "Sum = " << sum << endl;
    return 0;
}''',
      sampleInput: '4 7',
      expectedOutput: 'Enter two numbers: Sum = 11',
      explanation:
          'cin >> a >> b reads two integers from the user. sum = a + b performs the process, and cout displays Sum = 11.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: Perimeter of a Rectangle from User Input',
        description: 'Translates the perimeter formula 2 * (length + width) into C++.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int length, width, perimeter;
    cout << "Enter length and width: ";
    cin >> length >> width;
    perimeter = 2 * (length + width);
    cout << "Perimeter = " << perimeter << endl;
    return 0;
}''',
        sampleInput: '5 3',
        expectedOutput: 'Enter length and width: Perimeter = 16',
        explanation:
            'With input 5 and 3, the process computes 2 * (5 + 3) = 16.',
      ),
      CodeExample(
        title: 'Example 3: Swapping Two Numbers Using a Temporary Variable',
        description: 'Classic algorithm translation showing how to swap two variables.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int x = 10, y = 25, temp;
    cout << "Before swap: x = " << x << ", y = " << y << endl;
    temp = x;
    x = y;
    y = temp;
    cout << "After swap:  x = " << x << ", y = " << y << endl;
    return 0;
}''',
        expectedOutput: '''Before swap: x = 10, y = 25
After swap:  x = 25, y = 10''',
        explanation:
            'A third variable temp holds the original value of x so it is not lost when x = y is executed.',
      ),
      CodeExample(
        title: 'Example 4: Calculating Simple Interest',
        description: 'Translates Simple Interest = (P * R * T) / 100 into a working program.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int principal = 1000;
    int rate = 5;
    int time = 2;
    int interest = (principal * rate * time) / 100;
    cout << "Simple Interest = " << interest << endl;
    return 0;
}''',
        expectedOutput: 'Simple Interest = 100',
        explanation:
            'Input values (1000, 5, 2) are processed by the formula and displayed via cout.',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Turn the rectangle-area algorithm from Week 2 into a C++ program.',
      hint: 'Declare length, width, and area as int. Use cin >> length >> width; then area = length * width; and cout << area.',
      solutionCode: '''#include <iostream>
using namespace std;

int main() {
    int length, width, area;
    cout << "Enter length and width: ";
    cin >> length >> width;
    area = length * width;
    cout << "Area = " << area << endl;
    return 0;
}''',
      sampleInput: '8 5',
      expectedOutput: 'Enter length and width: Area = 40',
    ),
    rememberTip: 'Every algorithm step should have a clear equivalent in the program.',
    quiz: [
      McqQuestion(
        question: 'When translating an algorithm into C++, which statement is commonly used for input steps?',
        options: ['cout', 'cin', 'return', 'include'],
        correctIndex: 1,
        explanation: 'Input steps commonly use cin with the extraction operator >>.',
      ),
      McqQuestion(
        question: 'What does compilation check in a C++ program?',
        options: [
          'Whether the code follows the C++ language syntax rules',
          'Whether the computer battery is full',
          'Whether the user typed fast enough',
          'Whether the monitor brightness is high',
        ],
        correctIndex: 0,
        explanation: 'Compilation checks whether the source code follows the language rules.',
      ),
      McqQuestion(
        question: 'What is debugging?',
        options: [
          'Writing an algorithm on paper',
          'Finding and fixing the cause of a problem in a program',
          'Turning off the computer',
          'Installing a new keyboard',
        ],
        correctIndex: 1,
        explanation: 'Debugging means locating and fixing the cause of an error found during testing.',
      ),
      McqQuestion(
        question: 'In the statement sum = a + b;, what role does this step play?',
        options: ['Input', 'Process (Calculation)', 'Output', 'Header inclusion'],
        correctIndex: 1,
        explanation: 'Calculating sum = a + b is the Process step that works on the input data.',
      ),
      McqQuestion(
        question: 'Which operator is used with cin to take input from the user?',
        options: ['<<', '>>', '==', '&&'],
        correctIndex: 1,
        explanation: 'The extraction operator >> is used with cin (e.g., cin >> a >> b;).',
      ),
      McqQuestion(
        question: 'What is the output of the Week 3 booklet example when the user enters 4 and 7?',
        options: ['Sum = 47', 'Sum = 11', 'Sum = 28', 'Error'],
        correctIndex: 1,
        explanation: 'For input 4 and 7, sum = 4 + 7 = 11, so it displays Sum = 11.',
      ),
      McqQuestion(
        question: 'In int a, b, sum;, what are a, b, and sum?',
        options: ['Header files', 'Integer variables', 'Loops', 'Functions'],
        correctIndex: 1,
        explanation: 'They are integer (int) variables declared to store whole numbers.',
      ),
      McqQuestion(
        question: 'What does testing a program involve?',
        options: [
          'Comparing the actual output with the expected output for sample inputs',
          'Deleting the main() function',
          'Changing C++ into HTML',
          'Removing all semicolons',
        ],
        correctIndex: 0,
        explanation: 'Testing runs the program with sample inputs and compares actual output with expected output.',
      ),
      McqQuestion(
        question: 'Which statement correctly reads two variables length and width in one line?',
        options: [
          'cin << length << width;',
          'cin >> length >> width;',
          'cout >> length >> width;',
          'input(length, width);',
        ],
        correctIndex: 1,
        explanation: 'cin >> length >> width; chains the >> extraction operator to read two values.',
      ),
      McqQuestion(
        question: 'Every step in an algorithm should have what in the C++ program?',
        options: [
          'A clear equivalent statement or block in the program',
          'A separate computer',
          'At least ten loops',
          'A file stream',
        ],
        correctIndex: 0,
        explanation: 'Remember: Every algorithm step should have a clear equivalent in the program.',
      ),
    ],
  ),

  // ==================== WEEK 4 ====================
  WeekModule(
    weekNumber: 4,
    title: 'Programming Constructs, Data Types, Input and Output',
    learningAim: 'Learn the basic building blocks of C++ programs and the common data types.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'Sequence',
        body:
            'Sequence means statements run one after another in the order written. Most simple programs begin with a sequence of input, calculation, and output.',
      ),
      ConceptSection(
        number: 2,
        heading: 'Selection and repetition',
        body:
            'Selection chooses an action based on a condition. Repetition runs a block of statements more than once. These are covered in later weeks.',
      ),
      ConceptSection(
        number: 3,
        heading: 'Data types',
        body:
            'int stores whole numbers; float and double store decimal numbers; char stores one character; string stores text; bool stores true or false.',
      ),
      ConceptSection(
        number: 4,
        heading: 'Variables',
        body:
            'A variable is a named place for a value. Choose a meaningful name and give it a suitable type, such as int marks = 80;',
      ),
      ConceptSection(
        number: 5,
        heading: 'Input and output',
        body:
            'cin receives keyboard input. cout displays information on the screen. The insertion operator << sends output, while >> takes input.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: Input, calculate, and display',
      description: 'Reads a string name and integer age from the user and prints a sentence.',
      code: '''#include <iostream>
using namespace std;

int main() {
    string name;
    int age;
    cout << "Enter your name and age: ";
    cin >> name >> age;
    cout << name << " is " << age << " years old.";
    return 0;
}''',
      sampleInput: 'Ali 19',
      expectedOutput: 'Enter your name and age: Ali is 19 years old.',
      explanation:
          'string stores text ("Ali") and int stores whole numbers (19). cout chains << to combine variables and text.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: All Common C++ Data Types in Action',
        description: 'Demonstrates int, float, double, char, string, and bool variables.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int rollNo = 105;
    float gpa = 3.75;
    char grade = 'A';
    string course = "Programming";
    bool isEnrolled = true;

    cout << "Course: " << course << endl;
    cout << "Roll No: " << rollNo << endl;
    cout << "GPA: " << gpa << endl;
    cout << "Grade: " << grade << endl;
    cout << "Enrolled: " << isEnrolled << endl;
    return 0;
}''',
        expectedOutput: '''Course: Programming
Roll No: 105
GPA: 3.75
Grade: A
Enrolled: 1''',
        explanation:
            'Each variable uses the data type that matches its value. Note that in C++, bool true prints as 1 and false prints as 0.',
      ),
      CodeExample(
        title: 'Example 3: Calculating Total and Percentage with float',
        description: 'Uses float to store decimal numbers when calculating a percentage.',
        code: '''#include <iostream>
using namespace std;

int main() {
    float obtained = 425;
    float total = 500;
    float percentage = (obtained / total) * 100;
    cout << "Obtained Marks: " << obtained << endl;
    cout << "Percentage: " << percentage << "%" << endl;
    return 0;
}''',
        expectedOutput: '''Obtained Marks: 425
Percentage: 85%''',
        explanation:
            'Using float or double allows division to keep decimal precision instead of truncating to a whole number.',
      ),
      CodeExample(
        title: 'Example 4: Arithmetic Operators (+, -, *, /, %)',
        description: 'Shows addition, subtraction, multiplication, integer division, and remainder.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int a = 17, b = 5;
    cout << "Addition: " << a + b << endl;
    cout << "Subtraction: " << a - b << endl;
    cout << "Multiplication: " << a * b << endl;
    cout << "Division: " << a / b << endl;
    cout << "Remainder (Modulo): " << a % b << endl;
    return 0;
}''',
        expectedOutput: '''Addition: 22
Subtraction: 12
Multiplication: 85
Division: 3
Remainder (Modulo): 2''',
        explanation:
            'For int values 17 and 5, 17 / 5 gives 3 (whole part) and 17 % 5 gives 2 (the remainder).',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Ask the user for two whole numbers and display their product.',
      hint: 'Declare two int variables (e.g., num1, num2), read them with cin >> num1 >> num2;, multiply them with *, and display the result.',
      solutionCode: '''#include <iostream>
using namespace std;

int main() {
    int num1, num2, product;
    cout << "Enter two whole numbers: ";
    cin >> num1 >> num2;
    product = num1 * num2;
    cout << "Product = " << product << endl;
    return 0;
}''',
      sampleInput: '6 9',
      expectedOutput: 'Enter two whole numbers: Product = 54',
    ),
    rememberTip: 'Choose a data type that matches the kind of value you need to store.',
    quiz: [
      McqQuestion(
        question: 'Which C++ data type is used to store whole numbers (integers)?',
        options: ['float', 'int', 'char', 'string'],
        correctIndex: 1,
        explanation: 'int stores whole numbers without decimals, such as 80 or -5.',
      ),
      McqQuestion(
        question: 'Which data types are used to store decimal (floating-point) numbers in C++?',
        options: ['int and bool', 'char and string', 'float and double', 'void and main'],
        correctIndex: 2,
        explanation: 'float and double store numbers with decimal parts, such as 3.14 or 88.5.',
      ),
      McqQuestion(
        question: 'What does a char variable store?',
        options: [
          'A single character enclosed in single quotes, like \'A\'',
          'A whole paragraph of text',
          'Only large decimal numbers',
          'Multiple arrays',
        ],
        correctIndex: 0,
        explanation: 'char stores a single character, such as \'A\' or \'5\'.',
      ),
      McqQuestion(
        question: 'Which data type stores text such as "Ali" or "Computer Science"?',
        options: ['int', 'bool', 'string', 'char'],
        correctIndex: 2,
        explanation: 'string stores a sequence of characters (text).',
      ),
      McqQuestion(
        question: 'What values can a bool variable store?',
        options: ['true or false', 'Only negative numbers', 'Full names', 'Memory addresses'],
        correctIndex: 0,
        explanation: 'bool stores boolean truth values: true (1) or false (0).',
      ),
      McqQuestion(
        question: 'What is a variable in C++?',
        options: [
          'A named place in memory for storing a value',
          'A type of syntax error',
          'An operator that multiplies numbers',
          'A comment ignored by the compiler',
        ],
        correctIndex: 0,
        explanation: 'A variable is a named storage location that holds a value of a specific data type.',
      ),
      McqQuestion(
        question: 'Which operator is called the insertion operator (used with cout)?',
        options: ['>>', '<<', '==', '!='],
        correctIndex: 1,
        explanation: 'The << operator sends (inserts) output to cout.',
      ),
      McqQuestion(
        question: 'If the user inputs "Ali 19" to the Week 4 booklet program, what is the output?',
        options: [
          'Ali 19',
          'Ali is 19 years old.',
          'name is age years old.',
          '19 is Ali years old.',
        ],
        correctIndex: 1,
        explanation: 'cout << name << " is " << age << " years old."; prints "Ali is 19 years old."',
      ),
      McqQuestion(
        question: 'What is the result of the modulo expression 10 % 3 in C++?',
        options: ['3', '1', '0', '30'],
        correctIndex: 1,
        explanation: 'The % operator gives the remainder of integer division: 10 divided by 3 leaves a remainder of 1.',
      ),
      McqQuestion(
        question: 'Which declaration correctly creates an integer variable named marks initialized to 80?',
        options: [
          'marks int = 80;',
          'int marks = 80;',
          'string marks = 80;',
          'int 80 = marks;',
        ],
        correctIndex: 1,
        explanation: 'In C++, the data type comes first, followed by the variable name and initial value: int marks = 80;',
      ),
    ],
  ),

  // ==================== WEEK 5 ====================
  WeekModule(
    weekNumber: 5,
    title: 'Selection and Decision Making',
    learningAim: 'Make a program choose an action by checking conditions.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'if statement',
        body: 'An if statement runs its body only when its condition is true.',
      ),
      ConceptSection(
        number: 2,
        heading: 'if-else statement',
        body:
            'if-else provides two paths. One runs when the condition is true, and the other runs when it is false.',
      ),
      ConceptSection(
        number: 3,
        heading: 'else-if ladder',
        body:
            'An else-if ladder checks several conditions in order. The first true condition selects the branch.',
      ),
      ConceptSection(
        number: 4,
        heading: 'Nested if-else',
        body:
            'A nested if is an if statement inside another if or else block. It is useful when a second decision depends on the first.',
      ),
      ConceptSection(
        number: 5,
        heading: 'switch statement',
        body:
            'switch selects a case based on the value of an expression. Use break to prevent execution from continuing into the next case; default handles unmatched cases.',
      ),
      ConceptSection(
        number: 6,
        heading: 'Conditional operator',
        body:
            'The ?: operator is a short form for choosing between two expressions: condition ? value1 : value2.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: Pass or Fail',
      description: 'Uses an if-else statement to check if marks are at least 50.',
      code: '''#include <iostream>
using namespace std;

int main() {
    int marks = 60;
    if (marks >= 50)
        cout << "Passed";
    else
        cout << "Failed";
    return 0;
}''',
      expectedOutput: 'Passed',
      explanation:
          'Since marks is 60, the condition (marks >= 50) is true, so "Passed" is displayed and the else branch is skipped.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: Grade Calculator Using else-if Ladder',
        description: 'Checks multiple score ranges in order to assign a letter grade.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int marks = 82;
    if (marks >= 85)
        cout << "Grade: A";
    else if (marks >= 70)
        cout << "Grade: B";
    else if (marks >= 50)
        cout << "Grade: C";
    else
        cout << "Grade: F";
    return 0;
}''',
        expectedOutput: 'Grade: B',
        explanation:
            '82 is not >= 85, so it checks the next condition (marks >= 70), which is true, and prints Grade: B.',
      ),
      CodeExample(
        title: 'Example 3: Day of the Week Using switch Statement',
        description: 'Demonstrates switch, case, break, and default.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int day = 3;
    switch (day) {
        case 1:
            cout << "Monday";
            break;
        case 2:
            cout << "Tuesday";
            break;
        case 3:
            cout << "Wednesday";
            break;
        default:
            cout << "Other Day";
    }
    return 0;
}''',
        expectedOutput: 'Wednesday',
        explanation:
            'switch matches day == 3 with case 3, prints "Wednesday", and break exits the switch block.',
      ),
      CodeExample(
        title: 'Example 4: Conditional (Ternary) Operator ?:',
        description: 'Finds the larger of two numbers in a single concise expression.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int a = 15, b = 28;
    int maxVal = (a > b) ? a : b;
    cout << "Larger number is: " << maxVal << endl;
    return 0;
}''',
        expectedOutput: 'Larger number is: 28',
        explanation:
            'Since (a > b) is false (15 > 28 is false), the ?: operator selects the second value, b (28).',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Write an if-else program that checks whether a number is even or odd.',
      hint: 'A number is even if its remainder when divided by 2 is 0: (num % 2 == 0).',
      solutionCode: '''#include <iostream>
using namespace std;

int main() {
    int num;
    cout << "Enter a number: ";
    cin >> num;
    if (num % 2 == 0)
        cout << num << " is Even";
    else
        cout << num << " is Odd";
    return 0;
}''',
      sampleInput: '14',
      expectedOutput: 'Enter a number: 14 is Even',
    ),
    rememberTip: 'Use == to compare two values. A single = assigns a value.',
    quiz: [
      McqQuestion(
        question: 'When does the body of an if statement execute?',
        options: [
          'Only when its condition is true',
          'Only when its condition is false',
          'Always, regardless of the condition',
          'Never',
        ],
        correctIndex: 0,
        explanation: 'An if statement runs its body only when its condition evaluates to true.',
      ),
      McqQuestion(
        question: 'Which operator is used in C++ to compare if two values are equal?',
        options: ['=', '==', '!=', '=>'],
        correctIndex: 1,
        explanation: 'Use == to compare two values for equality. A single = assigns a value.',
      ),
      McqQuestion(
        question: 'What happens in an else-if ladder when the first true condition is found?',
        options: [
          'All remaining branches also run',
          'That branch runs and the rest of the ladder is skipped',
          'The program crashes',
          'Only the else block runs',
        ],
        correctIndex: 1,
        explanation: 'In an else-if ladder, the first true condition selects its branch and skips the rest.',
      ),
      McqQuestion(
        question: 'What is a nested if statement?',
        options: [
          'An if statement inside another if or else block',
          'An if statement without parentheses',
          'A loop that runs 10 times',
          'A function that returns nothing',
        ],
        correctIndex: 0,
        explanation: 'A nested if is an if statement placed inside another if or else block.',
      ),
      McqQuestion(
        question: 'In a switch statement, why is the break keyword used at the end of each case?',
        options: [
          'To restart the program',
          'To prevent execution from falling through into the next case',
          'To declare a new variable',
          'To print a new line',
        ],
        correctIndex: 1,
        explanation: 'break exits the switch block so execution does not continue into the next case.',
      ),
      McqQuestion(
        question: 'Which section of a switch statement handles values that do not match any case?',
        options: ['otherwise:', 'else:', 'default:', 'catch:'],
        correctIndex: 2,
        explanation: 'The default: label handles any unmatched cases in a switch statement.',
      ),
      McqQuestion(
        question: 'What is the syntax of the C++ conditional (ternary) operator?',
        options: [
          'condition ? value1 : value2',
          'condition : value1 ? value2',
          'if ? value1 else value2',
          'value1 ?? value2',
        ],
        correctIndex: 0,
        explanation: 'The conditional operator has the form: condition ? valueIfTrue : valueIfFalse.',
      ),
      McqQuestion(
        question: 'What will be printed if int x = 7; if (x % 2 == 0) cout << "Even"; else cout << "Odd";?',
        options: ['Even', 'Odd', 'EvenOdd', '7'],
        correctIndex: 1,
        explanation: '7 % 2 is 1 (not 0), so the condition is false and the else branch prints "Odd".',
      ),
      McqQuestion(
        question: 'What does the expression (x > 0 ? 1 : 0) evaluate to when x is 5?',
        options: ['5', '0', '1', '-1'],
        correctIndex: 2,
        explanation: 'Since 5 > 0 is true, the conditional expression returns the first choice, which is 1.',
      ),
      McqQuestion(
        question: 'Which logical operator requires BOTH conditions to be true?',
        options: ['||', '&&', '!', '=='],
        correctIndex: 1,
        explanation: '&& is the logical AND operator; it is true only when both conditions are true.',
      ),
    ],
  ),

  // ==================== WEEK 6 ====================
  WeekModule(
    weekNumber: 6,
    title: 'Repetition: while and for Loops',
    learningAim: 'Repeat instructions when a task must be performed several times.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'What is a loop?',
        body:
            'A loop repeats a block of code. Loops reduce repeated writing and are useful for counting, totals, and processing lists of values.',
      ),
      ConceptSection(
        number: 2,
        heading: 'while loop',
        body:
            'A while loop checks its condition before each repetition. If the condition is false at the beginning, its body may not run at all.',
      ),
      ConceptSection(
        number: 3,
        heading: 'for loop',
        body:
            'A for loop places initialization, condition, and update in one line. It is especially useful when the number of repetitions is known.',
      ),
      ConceptSection(
        number: 4,
        heading: 'Avoid infinite loops',
        body:
            'Make sure the loop condition can eventually become false. If the loop variable never changes, the loop may continue forever.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: Print numbers 1 to 5',
      description: 'Uses a for loop to print numbers from 1 to 5 separated by spaces.',
      code: '''#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 5; i++) {
        cout << i << " ";
    }
    return 0;
}''',
      expectedOutput: '1 2 3 4 5 ',
      explanation:
          'int i = 1 initializes the counter, i <= 5 checks the condition before each pass, and i++ increases i by 1 after each repetition.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: Sum of First 5 Natural Numbers Using for Loop',
        description: 'Accumulates the total 1 + 2 + 3 + 4 + 5 in a sum variable.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int sum = 0;
    for (int i = 1; i <= 5; i++) {
        sum += i;
    }
    cout << "Sum of 1 to 5 = " << sum << endl;
    return 0;
}''',
        expectedOutput: 'Sum of 1 to 5 = 15',
        explanation:
            'sum starts at 0 and adds i on each iteration: 1 + 2 + 3 + 4 + 5 = 15.',
      ),
      CodeExample(
        title: 'Example 3: Multiplication Table Using a for Loop',
        description: 'Prints the multiplication table of 5 from 1 to 5.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int n = 5;
    for (int i = 1; i <= 5; i++) {
        cout << n << " x " << i << " = " << n * i << endl;
    }
    return 0;
}''',
        expectedOutput: '''5 x 1 = 5
5 x 2 = 10
5 x 3 = 15
5 x 4 = 20
5 x 5 = 25''',
        explanation:
            'A for loop is ideal when we know the exact number of repetitions.',
      ),
      CodeExample(
        title: 'Example 4: Countdown Using a while Loop',
        description: 'Counts down from 5 to 1 using a while loop and i--.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int count = 5;
    while (count >= 1) {
        cout << count << " ";
        count--;
    }
    cout << "Blast off!" << endl;
    return 0;
}''',
        expectedOutput: '5 4 3 2 1 Blast off!',
        explanation:
            'count-- decreases the loop variable by 1 each time until count >= 1 becomes false.',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Use a while loop to print the numbers from 1 to 10.',
      hint: 'Start with int i = 1; then write while (i <= 10) { cout << i << " "; i++; }',
      solutionCode: '''#include <iostream>
using namespace std;

int main() {
    int i = 1;
    while (i <= 10) {
        cout << i << " ";
        i++;
    }
    return 0;
}''',
      expectedOutput: '1 2 3 4 5 6 7 8 9 10 ',
    ),
    rememberTip:
        'A loop needs a condition and a way for the program to make progress toward ending.',
    quiz: [
      McqQuestion(
        question: 'What is the main purpose of a loop in programming?',
        options: [
          'To repeat a block of code multiple times without writing it repeatedly',
          'To stop a program from compiling',
          'To declare header files',
          'To delete variables from memory',
        ],
        correctIndex: 0,
        explanation: 'Loops repeat a block of code and are useful for counting, totals, and lists.',
      ),
      McqQuestion(
        question: 'When does a while loop check its condition?',
        options: [
          'Only after the loop finishes completely',
          'Before each repetition (pre-test)',
          'Never',
          'Only on even numbers',
        ],
        correctIndex: 1,
        explanation: 'A while loop checks its condition before each repetition.',
      ),
      McqQuestion(
        question: 'If the condition of a while loop is false at the very beginning, how many times does its body run?',
        options: ['Zero times', 'One time', 'Infinite times', 'Ten times'],
        correctIndex: 0,
        explanation: 'Because while checks the condition before entering the body, it runs 0 times if initially false.',
      ),
      McqQuestion(
        question: 'Which three parts are placed in the header of a for loop?',
        options: [
          'Input, Output, Return',
          'Initialization, Condition, Update',
          'Start, Switch, Break',
          'Header, Main, Cout',
        ],
        correctIndex: 1,
        explanation: 'A for loop places initialization, condition, and update in one line: for (init; condition; update).',
      ),
      McqQuestion(
        question: 'When is a for loop especially useful?',
        options: [
          'When the number of repetitions is known in advance',
          'When we do not want any condition',
          'When declaring a struct',
          'When we only want to run code zero times',
        ],
        correctIndex: 0,
        explanation: 'A for loop is especially convenient when the exact number of repetitions is known.',
      ),
      McqQuestion(
        question: 'What causes an infinite loop?',
        options: [
          'Using cout inside a loop',
          'The loop condition never becomes false (for example, forgetting to update the loop variable)',
          'Naming the loop variable i',
          'Using return 0; in main()',
        ],
        correctIndex: 1,
        explanation: 'If the loop condition never becomes false, the loop continues forever (an infinite loop).',
      ),
      McqQuestion(
        question: 'What is the output of: for (int i = 1; i <= 5; i++) cout << i << " ";?',
        options: ['1 2 3 4', '1 2 3 4 5 ', '0 1 2 3 4 5', '5 4 3 2 1'],
        correctIndex: 1,
        explanation: 'i starts at 1 and prints 1, 2, 3, 4, 5 while i <= 5.',
      ),
      McqQuestion(
        question: 'What does i++ do at the end of each loop iteration?',
        options: [
          'Decreases i by 1',
          'Increases i by 1',
          'Multiplies i by 2',
          'Resets i to 0',
        ],
        correctIndex: 1,
        explanation: 'The ++ operator increments (increases) the variable by 1.',
      ),
      McqQuestion(
        question: 'How many times will for (int i = 0; i < 4; i++) execute its body?',
        options: ['3 times', '4 times', '5 times', '0 times'],
        correctIndex: 1,
        explanation: 'It runs for i = 0, 1, 2, and 3, which is 4 times total.',
      ),
      McqQuestion(
        question: 'To count backwards from 10 down to 1 in a for loop, which update expression should be used?',
        options: ['i++', 'i--', 'i == 1', 'i + 10'],
        correctIndex: 1,
        explanation: 'i-- decreases i by 1 on each step.',
      ),
    ],
  ),

  // ==================== WEEK 7 ====================
  WeekModule(
    weekNumber: 7,
    title: 'The do-while Loop',
    learningAim: 'Use a loop that runs at least once before checking its condition.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'How it works',
        body:
            'A do-while loop executes its body first and checks the condition afterward. Therefore, its body runs at least once.',
      ),
      ConceptSection(
        number: 2,
        heading: 'Syntax',
        body:
            'Write do, then the block in braces, then while (condition);. The semicolon after the while condition is required.',
      ),
      ConceptSection(
        number: 3,
        heading: 'When to use it',
        body:
            'It is useful for menus or prompts that should appear at least once, then repeat only if the user chooses to continue.',
      ),
      ConceptSection(
        number: 4,
        heading: 'Compare with while',
        body:
            'while checks before the body and may run zero times. do-while checks after the body and runs at least once.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: Count from 1 to 3',
      description: 'Uses a do-while loop to print numbers 1, 2, and 3.',
      code: '''#include <iostream>
using namespace std;

int main() {
    int i = 1;
    do {
        cout << i << " ";
        i++;
    } while (i <= 3);
    return 0;
}''',
      expectedOutput: '1 2 3 ',
      explanation:
          'The do block runs first, printing i and incrementing it, and then checks while (i <= 3);.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: Runs Once Even When Condition is False!',
        description: 'Proves that do-while executes its body at least once even if the condition is initially false.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int x = 100;
    do {
        cout << "Body ran with x = " << x << endl;
    } while (x < 10);
    return 0;
}''',
        expectedOutput: 'Body ran with x = 100',
        explanation:
            'Even though x < 10 is false (100 < 10 is false), the body still runs once because the condition is checked at the end.',
      ),
      CodeExample(
        title: 'Example 3: Interactive Menu Simulation with do-while',
        description: 'Displays a menu at least once and exits when choice is 0.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int choice = 0;
    do {
        cout << "--- STUDENT MENU ---" << endl;
        cout << "1. View Marks" << endl;
        cout << "0. Exit" << endl;
        cout << "Selected choice: " << choice << endl;
    } while (choice != 0);
    return 0;
}''',
        expectedOutput: '''--- STUDENT MENU ---
1. View Marks
0. Exit
Selected choice: 0''',
        explanation:
            'Menus always need to be shown to the user at least once, making do-while the best choice.',
      ),
      CodeExample(
        title: 'Example 4: Printing Even Numbers 2 to 8 with do-while',
        description: 'Steps by 2 using i += 2 inside a do-while loop.',
        code: '''#include <iostream>
using namespace std;

int main() {
    int num = 2;
    do {
        cout << num << " ";
        num += 2;
    } while (num <= 8);
    return 0;
}''',
        expectedOutput: '2 4 6 8 ',
        explanation:
            'num starts at 2 and increases by 2 on each pass until num <= 8 becomes false.',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Write a do-while loop that displays a short menu at least once.',
      hint: 'Place cout menu lines inside do { ... } while (choice != 0); and do not forget the semicolon at the end!',
      solutionCode: '''#include <iostream>
using namespace std;

int main() {
    int choice = 0;
    do {
        cout << "=== Calculator Menu ===" << endl;
        cout << "1. Add Numbers" << endl;
        cout << "2. Subtract Numbers" << endl;
        cout << "0. Quit" << endl;
    } while (choice != 0);
    return 0;
}''',
      expectedOutput: '''=== Calculator Menu ===
1. Add Numbers
2. Subtract Numbers
0. Quit''',
    ),
    rememberTip: 'Do not forget the semicolon after while (condition);',
    quiz: [
      McqQuestion(
        question: 'What is the minimum number of times a do-while loop body will execute?',
        options: ['Zero times', 'At least one time', 'Two times', 'Ten times'],
        correctIndex: 1,
        explanation: 'A do-while loop executes its body first and checks the condition afterward, so it always runs at least once.',
      ),
      McqQuestion(
        question: 'When does a do-while loop check its condition?',
        options: [
          'Before executing the loop body',
          'After executing the loop body',
          'Before main() starts',
          'It never checks a condition',
        ],
        correctIndex: 1,
        explanation: 'do-while is a post-test loop: it checks the condition after each execution of the body.',
      ),
      McqQuestion(
        question: 'What punctuation mark is required immediately after while (condition) in a do-while loop?',
        options: ['A colon (:)', 'A semicolon (;)', 'A comma (,)', 'Nothing'],
        correctIndex: 1,
        explanation: 'Remember: Do not forget the semicolon after while (condition); in a do-while loop.',
      ),
      McqQuestion(
        question: 'For which scenario is a do-while loop most suitable?',
        options: [
          'Displaying a menu or prompt that must appear at least once',
          'Declaring header files',
          'Preventing code from ever running',
          'Defining a structure',
        ],
        correctIndex: 0,
        explanation: 'do-while is ideal for menus or user prompts that should appear at least once.',
      ),
      McqQuestion(
        question: 'How does a while loop differ from a do-while loop?',
        options: [
          'while checks the condition before the body and may run zero times; do-while checks after and runs at least once',
          'while cannot use numbers',
          'do-while cannot use cout',
          'There is no difference at all',
        ],
        correctIndex: 0,
        explanation: 'while is pre-test (0 or more times) whereas do-while is post-test (1 or more times).',
      ),
      McqQuestion(
        question: 'What is the output of the Week 7 booklet example (int i = 1; do { cout << i << " "; i++; } while (i <= 3);)?',
        options: ['1 2 ', '1 2 3 ', '1 2 3 4 ', '0 1 2 3 '],
        correctIndex: 1,
        explanation: 'It prints 1, 2, and 3, then i becomes 4, making i <= 3 false.',
      ),
      McqQuestion(
        question: 'What will int i = 5; do { cout << i; i++; } while (i < 3); output?',
        options: ['Nothing', '5', '3', '5 6 7'],
        correctIndex: 1,
        explanation: 'The body runs once first, printing 5, and then checks i < 3 (6 < 3 is false) and stops.',
      ),
      McqQuestion(
        question: 'Which keyword starts a do-while loop?',
        options: ['repeat', 'loop', 'do', 'start'],
        correctIndex: 2,
        explanation: 'A do-while loop begins with the keyword do.',
      ),
      McqQuestion(
        question: 'What happens if you forget to update the loop variable inside a do-while loop when the condition is true?',
        options: [
          'The loop becomes an infinite loop',
          'The loop runs zero times',
          'The compiler automatically adds i++',
          'It converts into a switch statement',
        ],
        correctIndex: 0,
        explanation: 'Just like other loops, if the condition stays true forever, it causes an infinite loop.',
      ),
      McqQuestion(
        question: 'Which of the following has valid C++ syntax?',
        options: [
          'do { cout << "Hi"; } while (x < 5);',
          'do (x < 5) { cout << "Hi"; }',
          'while { cout << "Hi"; } do (x < 5);',
          'do { cout << "Hi"; } (x < 5)',
        ],
        correctIndex: 0,
        explanation: 'The correct syntax is do { ... } while (condition);.',
      ),
    ],
  ),

  // ==================== WEEK 8 ====================
  WeekModule(
    weekNumber: 8,
    title: 'break and continue Statements',
    learningAim: 'Control the flow of loops using break and continue.',
    sections: [
      ConceptSection(
        number: 1,
        heading: 'break',
        body:
            'break immediately exits the nearest loop or switch statement. The program continues with the statement after that loop or switch.',
      ),
      ConceptSection(
        number: 2,
        heading: 'continue',
        body:
            'continue skips the remaining statements in the current loop repetition and moves to the next repetition.',
      ),
      ConceptSection(
        number: 3,
        heading: 'Choosing between them',
        body:
            'Use break when the loop should stop completely. Use continue when the loop should keep running but skip one iteration.',
      ),
      ConceptSection(
        number: 4,
        heading: 'Careful use',
        body:
            'These statements can make control flow harder to follow if overused. Use clear conditions and meaningful variable names.',
      ),
    ],
    pdfExample: CodeExample(
      title: 'Booklet Example: Skip number 3',
      description: 'Uses continue to skip printing 3 while looping from 1 to 5.',
      code: '''#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 5; i++) {
        if (i == 3)
            continue;
        cout << i << " ";
    }
    return 0;
}''',
      expectedOutput: '1 2 4 5 ',
      explanation:
          'When i is 3, continue skips cout << i << " "; for that iteration only and continues with i = 4 and 5.',
      isFromPdf: true,
    ),
    extraExamples: [
      CodeExample(
        title: 'Example 2: Stopping a Loop Early with break',
        description: 'Stops the loop completely as soon as i reaches 4.',
        code: '''#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 10; i++) {
        if (i == 4)
            break;
        cout << i << " ";
    }
    cout << "Loop stopped!" << endl;
    return 0;
}''',
        expectedOutput: '1 2 3 Loop stopped!',
        explanation:
            'When i == 4 is true, break exits the for loop immediately, so only 1 2 3 are printed.',
      ),
      CodeExample(
        title: 'Example 3: Skipping Odd Numbers Using continue',
        description: 'Prints only even numbers between 1 and 8 by skipping odd ones.',
        code: '''#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 8; i++) {
        if (i % 2 != 0)
            continue;
        cout << i << " ";
    }
    return 0;
}''',
        expectedOutput: '2 4 6 8 ',
        explanation:
            'Whenever i is odd (i % 2 != 0), continue jumps to the next iteration without printing.',
      ),
      CodeExample(
        title: 'Example 4: Searching for a Target Value with break',
        description: 'Stops searching once the target number 7 is found.',
        code: '''#include <iostream>
using namespace std;

int main() {
    for (int num = 1; num <= 10; num++) {
        if (num == 7) {
            cout << "Found target 7! Stopping search." << endl;
            break;
        }
        cout << "Checking " << num << endl;
    }
    return 0;
}''',
        expectedOutput: '''Checking 1
Checking 2
Checking 3
Checking 4
Checking 5
Checking 6
Found target 7! Stopping search.''',
        explanation:
            'Once 7 is found, there is no need to check 8, 9, or 10—break exits the loop immediately.',
      ),
    ],
    practiceTask: PracticeTask(
      prompt: 'Print numbers from 1 to 10 but stop the loop when the number reaches 6.',
      hint: 'Inside a for loop from 1 to 10, check if (i == 6) break; before cout << i << " ";',
      solutionCode: '''#include <iostream>
using namespace std;

int main() {
    for (int i = 1; i <= 10; i++) {
        if (i == 6)
            break;
        cout << i << " ";
    }
    return 0;
}''',
      expectedOutput: '1 2 3 4 5 ',
    ),
    rememberTip: 'break exits the loop; continue skips only the current repetition.',
    quiz: [
      McqQuestion(
        question: 'What does the break statement do inside a loop?',
        options: [
          'Skips only the current iteration and continues the loop',
          'Immediately exits the nearest loop or switch statement',
          'Restarts the loop from the beginning',
          'Prints an error message',
        ],
        correctIndex: 1,
        explanation: 'break immediately terminates the nearest enclosing loop or switch statement.',
      ),
      McqQuestion(
        question: 'What does the continue statement do inside a loop?',
        options: [
          'Exits the entire program',
          'Skips the remaining statements in the current repetition and moves to the next repetition',
          'Stops the loop permanently',
          'Deletes the loop variable',
        ],
        correctIndex: 1,
        explanation: 'continue skips the rest of the current iteration and proceeds to the next loop iteration.',
      ),
      McqQuestion(
        question: 'What is the output of the Week 8 booklet example (for i = 1..5, if (i == 3) continue; cout << i << " ";)?',
        options: ['1 2 ', '1 2 4 5 ', '1 2 3 4 5 ', '3 '],
        correctIndex: 1,
        explanation: 'Only iteration i == 3 is skipped, so 1 2 4 5 are displayed.',
      ),
      McqQuestion(
        question: 'What would the output be if continue were replaced by break in the Week 8 booklet example (when i == 3)?',
        options: ['1 2 ', '1 2 4 5 ', '3 4 5 ', '1 2 3 '],
        correctIndex: 0,
        explanation: 'With break when i == 3, the loop stops completely after printing 1 and 2.',
      ),
      McqQuestion(
        question: 'When should you choose break instead of continue?',
        options: [
          'When the loop should stop completely',
          'When you want to skip just one value and keep looping',
          'When declaring a variable',
          'When writing #include <iostream>',
        ],
        correctIndex: 0,
        explanation: 'Use break when the loop should terminate completely.',
      ),
      McqQuestion(
        question: 'When should you choose continue instead of break?',
        options: [
          'When exiting a switch statement',
          'When the loop should keep running but skip the current iteration',
          'When ending main()',
          'When stopping a loop forever',
        ],
        correctIndex: 1,
        explanation: 'Use continue when you want to skip one iteration and continue looping.',
      ),
      McqQuestion(
        question: 'Besides loops, in which other C++ control structure is break commonly used?',
        options: ['switch statement', 'struct definition', 'cout statement', '#include directive'],
        correctIndex: 0,
        explanation: 'break is used in both loops and switch statements.',
      ),
      McqQuestion(
        question: 'Why should break and continue be used carefully?',
        options: [
          'Because they can make control flow harder to follow if overused',
          'Because they are not valid C++ keywords',
          'Because they delete files',
          'Because they only work with float variables',
        ],
        correctIndex: 0,
        explanation: 'Overusing jump statements can make code harder to read; use clear conditions.',
      ),
      McqQuestion(
        question: 'In a for loop, where does execution go immediately after a continue statement is executed?',
        options: [
          'To the loop update expression (e.g., i++) and next condition check',
          'To return 0; outside the loop',
          'To the line before the loop',
          'It crashes the program',
        ],
        correctIndex: 0,
        explanation: 'In a for loop, continue jumps to the update step (i++) and then re-tests the loop condition.',
      ),
      McqQuestion(
        question: 'What is printed by: for (int i = 1; i <= 10; i++) { if (i == 6) break; cout << i << " "; }?',
        options: ['1 2 3 4 5 ', '1 2 3 4 5 6 ', '6 7 8 9 10 ', '1 2 3 4 5 7 8 9 10 '],
        correctIndex: 0,
        explanation: 'The loop prints 1 2 3 4 5 and breaks as soon as i reaches 6.',
      ),
    ],
  ),
];
