-- Replace dummy Java units with real chapter lesson + quiz structure
DELETE FROM user_unit_progress WHERE unit_id IN (SELECT id FROM units WHERE course_id = 1);
DELETE FROM units WHERE course_id = 1;

INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path) VALUES
(1, 'Chapter 1: Introduction',                 'Introduction',           '', 1,  'lesson', 'java/1. Introduction.pdf'),
(1, 'Chapter 1 Quiz: Introduction',            'Introduction',           '', 2,  'quiz',   NULL),
(1, 'Chapter 2: Data and Expressions',         'Data and Expressions',   '', 3,  'lesson', 'java/2. Data and Expressions.pdf'),
(1, 'Chapter 2 Quiz: Data and Expressions',    'Data and Expressions',   '', 4,  'quiz',   NULL),
(1, 'Chapter 3: Conditionals and Loops',       'Conditionals and Loops', '', 5,  'lesson', 'java/3. Conditionals and Loops.pdf'),
(1, 'Chapter 3 Quiz: Conditionals and Loops',  'Conditionals and Loops', '', 6,  'quiz',   NULL),
(1, 'Chapter 4: Writing Classes',              'Writing Classes',        '', 7,  'lesson', 'java/4. Writing Classes.pdf'),
(1, 'Chapter 4 Quiz: Writing Classes',         'Writing Classes',        '', 8,  'quiz',   NULL),
(1, 'Chapter 5: Inheritance',                  'Inheritance',            '', 9,  'lesson', 'java/5. Inheritance.pdf'),
(1, 'Chapter 5 Quiz: Inheritance',             'Inheritance',            '', 10, 'quiz',   NULL),
(1, 'Chapter 6: Polymorphism',                 'Polymorphism',           '', 11, 'lesson', 'java/6. Polymorphism.pdf'),
(1, 'Chapter 6 Quiz: Polymorphism',            'Polymorphism',           '', 12, 'quiz',   NULL);

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 1 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('Which of the following best describes the relationship between hardware and software?', 'b', 1),
    ('Which statement best describes the relationship between a high-level language and machine language?', 'c', 2),
    ('What is Java bytecode?', 'c', 3),
    ('Which of the following correctly describes white space in Java?', 'b', 4),
    ('Which of the following are NOT valid Java identifiers?', 'b', 5),
    ('What do syntax and semantics mean in the context of a programming language?', 'b', 6),
    ('Which of the following lists the four basic activities involved in a software development process?', 'c', 7),
    ('Which of the following are the primary concepts that support object-oriented programming?', 'c', 8)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 1 Quiz: Introduction';

-- Ch1 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Hardware refers to the programs that run on a computer, while software refers to the physical components'),
    ('b', 'Hardware refers to the physical components of a computer system, while software refers to the programs and instructions that run on it'),
    ('c', 'Hardware and software are interchangeable terms for the same concept'),
    ('d', 'Software controls the manufacturing of hardware components')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 1;

-- Ch1 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'High-level languages are directly executed by the CPU without any translation'),
    ('b', 'Machine language is easier for humans to read and write than high-level languages'),
    ('c', 'A high-level language must be translated into machine language before a computer can execute it'),
    ('d', 'High-level languages and machine language are syntactically identical')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 2;

-- Ch1 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The original Java source code written by the developer'),
    ('b', 'A binary format specific to Windows operating systems only'),
    ('c', 'An intermediate representation produced by the Java compiler that is executed by the Java Virtual Machine (JVM)'),
    ('d', 'The machine language generated directly by the CPU when running Java programs')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 3;

-- Ch1 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'White space includes spaces, tabs, and newlines; it directly affects how a program executes'),
    ('b', 'White space includes spaces, tabs, and newlines; it is ignored by the compiler but improves program readability'),
    ('c', 'White space refers only to blank lines between methods and affects compilation speed'),
    ('d', 'White space must be removed before a Java program can be compiled successfully')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 4;

-- Ch1 Q5 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'RESULT and result'),
    ('b', '12345 and black&white'),
    ('c', 'x12345y and answer_7'),
    ('d', 'answer_7 and result')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 5;

-- Ch1 Q6 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Syntax defines the meaning of statements; semantics defines the grammatical rules'),
    ('b', 'Syntax refers to the grammatical rules of the language; semantics refers to the meaning of those statements'),
    ('c', 'Syntax and semantics both refer to how a program is formatted and indented'),
    ('d', 'Syntax describes runtime behavior; semantics describes compile-time rules')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 6;

-- Ch1 Q7 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Designing, coding, marketing, and deploying'),
    ('b', 'Planning, hiring, testing, and releasing'),
    ('c', 'Establishing requirements, creating a design, implementing the design, and testing'),
    ('d', 'Compiling, linking, executing, and debugging')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 7;

-- Ch1 Q8 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Compilation, interpretation, linking, and loading'),
    ('b', 'Variables, loops, conditionals, and methods'),
    ('c', 'Encapsulation, inheritance, and polymorphism'),
    ('d', 'Abstraction, recursion, iteration, and synchronization')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction') AND qq.order_index = 8;

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 2 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('Which of the following best describes primitive data and how it differs from objects?', 'b', 1),
    ('Which of the following is a string literal in Java?', 'c', 2),
    ('What is the difference between System.out.print and System.out.println?', 'c', 3),
    ('What is a parameter in the context of a Java method?', 'b', 4),
    ('Which of the following best describes an escape sequence?', 'b', 5),
    ('What is a variable declaration in Java?', 'b', 6),
    ('How many values can be stored in an integer variable at one time?', 'c', 7),
    ('What are the four integer data types in Java, and what primarily distinguishes them from one another?', 'b', 8),
    ('What is a character set in Java?', 'c', 9),
    ('What is operator precedence?', 'b', 10),
    ('What is the result of 19 % 5 in a Java expression?', 'b', 11),
    ('What is the result of 13 / 4 in a Java expression?', 'c', 12),
    ('If diameter currently holds the value 5, what is its value after executing diameter = diameter * 4;?', 'd', 13),
    ('If weight currently holds the value 100, what is its value after executing weight -= 17;?', 'd', 14),
    ('Why are widening conversions considered safer than narrowing conversions?', 'b', 15)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 2 Quiz: Data and Expressions';

-- Ch2 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Primitive data types are defined by the programmer, while objects are predefined by Java'),
    ('b', 'Primitive data represents simple, single values (such as integers or characters) and is not an object, while objects are instances of classes that can contain both data and methods'),
    ('c', 'Primitive data and objects are identical in Java; the terms are interchangeable'),
    ('d', 'Primitive data can only store text, while objects store numerical values')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 1;

-- Ch2 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A variable that holds a sequence of characters'),
    ('b', 'A method that prints text to the console'),
    ('c', 'A fixed sequence of characters enclosed in double quotation marks, such as "Hello, World!"'),
    ('d', 'A character enclosed in single quotation marks, such as ''A''')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 2;

-- Ch2 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'print outputs text in uppercase; println outputs text in lowercase'),
    ('b', 'print outputs the text and then moves to a new line; println keeps the cursor on the same line'),
    ('c', 'print outputs the text and leaves the cursor on the same line; println outputs the text and then moves the cursor to a new line'),
    ('d', 'There is no difference; both methods behave identically')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 3;

-- Ch2 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A value that is returned by a method after execution'),
    ('b', 'A piece of data passed into a method to be used during its execution'),
    ('c', 'A variable declared inside a method that cannot be accessed from outside'),
    ('d', 'A keyword used to define a new class in Java')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 4;

-- Ch2 Q5 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A special keyword used to exit a loop prematurely'),
    ('b', 'A combination of characters beginning with a backslash that represents a special character, such as \n for newline, \t for tab, or \" for a double quotation mark'),
    ('c', 'A sequence of characters used to declare a new variable in Java'),
    ('d', 'A method call that terminates program execution immediately')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 5;

-- Ch2 Q6 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A statement that assigns a final, unchangeable value to an identifier'),
    ('b', 'A statement that specifies a variable''s data type and name, and optionally assigns it an initial value'),
    ('c', 'A statement that calls a method and stores its return value'),
    ('d', 'A comment that documents the purpose of a variable in the source code')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 6;

-- Ch2 Q7 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'As many as the available memory allows'),
    ('b', 'Two — one current value and one previous value'),
    ('c', 'Exactly one value at any given time'),
    ('d', 'Up to ten values, depending on the declared type')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 7;

-- Ch2 Q8 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'int, float, double, and long — they differ in the type of values they store'),
    ('b', 'byte, short, int, and long — they differ in the amount of memory they occupy and therefore the range of values they can hold'),
    ('c', 'byte, int, char, and double — they differ in precision and memory usage'),
    ('d', 'short, int, long, and float — they differ only in naming convention')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 8;

-- Ch2 Q9 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A collection of string literals defined within a single class'),
    ('b', 'A predefined list of reserved keywords used by the Java compiler'),
    ('c', 'An ordered list of characters, each mapped to a specific numeric value, used by a programming language to represent text'),
    ('d', 'A set of special characters that cannot be used in Java identifiers')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 9;

-- Ch2 Q10 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The order in which variables are declared within a Java program'),
    ('b', 'A rule that determines which operator is evaluated first when multiple operators appear in a single expression'),
    ('c', 'The priority given to method calls over arithmetic operations during compilation'),
    ('d', 'A mechanism that allows operators to be overloaded in Java')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 10;

-- Ch2 Q11 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '3'),
    ('b', '4'),
    ('c', '1'),
    ('d', '0')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 11;

-- Ch2 Q12 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '3.25'),
    ('b', '4'),
    ('c', '3'),
    ('d', '1')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 12;

-- Ch2 Q13 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '5'),
    ('b', '9'),
    ('c', '54'),
    ('d', '20')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 13;

-- Ch2 Q14 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '117'),
    ('b', '17'),
    ('c', '100'),
    ('d', '83')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 14;

-- Ch2 Q15 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Widening conversions always improve performance, while narrowing conversions slow down execution'),
    ('b', 'Widening conversions move a value to a larger data type, so no data is lost; narrowing conversions move a value to a smaller data type, which risks losing information or precision'),
    ('c', 'Widening conversions are performed manually by the programmer, making them more deliberate and therefore safer'),
    ('d', 'Narrowing conversions are unsafe because they change the data type from numeric to text')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Data and Expressions') AND qq.order_index = 15;

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 3 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('What is meant by the flow of control through a program?', 'b', 1),
    ('What type of conditions are conditionals and loops based on?', 'c', 2),
    ('Which of the following correctly identifies the equality operators and relational operators in Java?', 'b', 3),
    ('What is a truth table?', 'c', 4),
    ('Why must we be careful when comparing floating-point values for equality?', 'c', 5),
    ('How do we correctly compare two strings for equality in Java?', 'b', 6),
    ('What is a nested if statement? What is a nested loop?', 'b', 7),
    ('How do block statements assist in the construction of conditionals and loops?', 'c', 8),
    ('What happens if a case in a switch statement does not end with a break statement?', 'c', 9),
    ('What is an infinite loop, and what specifically causes it?', 'b', 10),
    ('Which of the following best compares and contrasts a while loop and a do loop?', 'b', 11),
    ('When would we prefer a for loop over a while loop?', 'c', 12)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 3 Quiz: Conditionals and Loops';

-- Ch3 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The speed at which a program is compiled and executed by the JVM'),
    ('b', 'The order in which statements are executed during the runtime of a program'),
    ('c', 'The process by which Java allocates memory to variables at runtime'),
    ('d', 'The mechanism by which methods return values to the calling code')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 1;

-- Ch3 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Integer expressions that evaluate to any numeric value'),
    ('b', 'String comparisons that match exact character sequences'),
    ('c', 'Boolean expressions that evaluate to either true or false'),
    ('d', 'Floating-point expressions that evaluate to a value between 0.0 and 1.0')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 2;

-- Ch3 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Equality operators: =, !=; Relational operators: <, >, <=, >='),
    ('b', 'Equality operators: ==, !=; Relational operators: <, >, <=, >='),
    ('c', 'Equality operators: ==, =; Relational operators: !=, <>, <=, >='),
    ('d', 'Equality operators: equals(), !=; Relational operators: <, >, <>, >=')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 3;

-- Ch3 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A table that lists all reserved keywords and their corresponding boolean values in Java'),
    ('b', 'A debugging tool used to trace the value of variables during program execution'),
    ('c', 'A table that systematically shows the result of a logical expression for every possible combination of its operand values'),
    ('d', 'A chart that maps every possible input to its expected program output for testing purposes')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 4;

-- Ch3 Q5 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The == operator is not defined for float and double types in Java'),
    ('b', 'Floating-point values are stored as strings internally, making direct comparison unreliable'),
    ('c', 'Floating-point arithmetic can introduce small rounding errors, meaning two values that are mathematically equal may differ slightly in their stored representation'),
    ('d', 'The JVM automatically rounds all floating-point values to the nearest integer before comparison')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 5;

-- Ch3 Q6 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Using the == operator, which compares the content of both strings'),
    ('b', 'Using the equals() method, which compares the actual character content of the two strings'),
    ('c', 'Using the > relational operator, which evaluates alphabetical ordering'),
    ('d', 'Using the compare() method inherited from the Object class')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 6;

-- Ch3 Q7 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A nested if statement is one that contains a switch; a nested loop is a loop that contains an if statement'),
    ('b', 'A nested if statement is an if statement placed inside another if statement; a nested loop is a loop placed entirely inside another loop'),
    ('c', 'A nested if statement uses two conditions joined by &&; a nested loop runs twice as fast as a standard loop'),
    ('d', 'Both terms refer to the same concept: a control structure repeated more than once in a program')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 7;

-- Ch3 Q8 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'They improve execution performance by grouping statements into a single bytecode instruction'),
    ('b', 'They allow the programmer to declare variables that are accessible throughout the entire program'),
    ('c', 'They allow multiple statements to be grouped together using curly braces {} and treated as a single unit, enabling conditionals and loops to control more than one statement at a time'),
    ('d', 'They prevent the compiler from executing certain statements during the testing phase')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 8;

-- Ch3 Q9 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The program throws a SwitchException at runtime'),
    ('b', 'The compiler produces an error and refuses to compile the program'),
    ('c', 'Execution falls through to the next case and continues running its statements regardless of whether that case''s value matches'),
    ('d', 'The switch statement terminates immediately and execution resumes after the closing brace')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 9;

-- Ch3 Q10 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A loop that executes exactly one million times due to an excessively large counter value'),
    ('b', 'A loop whose termination condition never becomes false, causing it to repeat indefinitely; typically caused by a condition that is never updated or can never be met'),
    ('c', 'A loop that is nested so deeply that the JVM runs out of memory and crashes'),
    ('d', 'A loop that is declared without an initialisation statement, causing unpredictable behaviour')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 10;

-- Ch3 Q11 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A while loop executes its body at least twice; a do loop executes its body at least once'),
    ('b', 'A while loop checks its condition before each iteration, so its body may never execute; a do loop checks its condition after each iteration, guaranteeing its body executes at least once'),
    ('c', 'A while loop is used for counting; a do loop is used for searching through data'),
    ('d', 'There is no practical difference; they always produce identical results regardless of the initial condition')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 11;

-- Ch3 Q12 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'When the loop body must execute at least once, regardless of the initial condition'),
    ('b', 'When the number of iterations is unknown and depends entirely on user input'),
    ('c', 'When the loop involves a well-defined counter or iterator, and the initialisation, condition, and update are all known in advance'),
    ('d', 'When the loop contains a switch statement inside its body')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: Conditionals and Loops') AND qq.order_index = 12;

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 4 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('What is an attribute in the context of object-oriented programming?', 'b', 1),
    ('What is an operation in the context of object-oriented programming?', 'c', 2),
    ('What is the difference between an object and a class?', 'b', 3),
    ('What is the scope of a variable?', 'c', 4),
    ('What are UML diagrams designed to do?', 'b', 5),
    ('What does it mean for objects to be self-governing?', 'c', 6),
    ('What is a modifier in Java?', 'b', 7),
    ('Why might a constant be given public visibility?', 'c', 8),
    ('Which of the following correctly describes all four visibility combinations?', 'b', 9),
    ('What is the interface to an object?', 'c', 10),
    ('Why is a method invoked through a particular object, and what is the exception to that rule?', 'b', 11),
    ('What does it mean for a method to return a value?', 'c', 12),
    ('What does the return statement do?', 'b', 13),
    ('Is a return statement always required in a Java method?', 'b', 14),
    ('What is the difference between an actual parameter and a formal parameter?', 'c', 15),
    ('What are constructors used for, and how are they defined?', 'b', 16),
    ('What is the difference between a static variable and an instance variable?', 'b', 17),
    ('What kinds of variables can the main method reference, and why?', 'c', 18),
    ('How would you describe a dependency relationship between two classes?', 'c', 19),
    ('How are overloaded methods distinguished from one another in Java?', 'b', 20),
    ('What is method decomposition?', 'c', 21),
    ('How can a class have an association with itself?', 'b', 22),
    ('What is an aggregate object?', 'c', 23),
    ('What does the this reference refer to in Java?', 'c', 24),
    ('How are objects passed as parameters in Java?', 'b', 25),
    ('What is a defect test?', 'b', 26),
    ('What is a debugger?', 'c', 27)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 4 Quiz: Writing Classes';

-- Ch4 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A method that modifies the internal state of an object'),
    ('b', 'A characteristic or property of an object that holds data describing its current state'),
    ('c', 'A special keyword used to declare a new class in Java'),
    ('d', 'A relationship between two separate classes in a UML diagram')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 1;

-- Ch4 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A variable that stores the result of an arithmetic calculation'),
    ('b', 'A relationship between a class and its subclass'),
    ('c', 'A behaviour or action that an object can perform, typically implemented as a method'),
    ('d', 'A reserved keyword that controls the flow of execution in a loop')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 2;

-- Ch4 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A class is a specific instance created at runtime; an object is a blueprint defined at compile time'),
    ('b', 'A class is a blueprint or template that defines the structure and behaviour of objects; an object is a specific instance of that class created at runtime'),
    ('c', 'An object and a class are interchangeable terms referring to the same concept in Java'),
    ('d', 'A class can hold data, while an object can only define methods')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 3;

-- Ch4 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The data type assigned to a variable at the time of its declaration'),
    ('b', 'The maximum numeric value that a variable of a given type can store'),
    ('c', 'The region of a program within which a variable is declared, accessible, and meaningful'),
    ('d', 'The number of times a variable is referenced throughout the execution of a program')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 4;

-- Ch4 Q5 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Automatically generate Java source code from a visual representation of a program'),
    ('b', 'Visually model and document the structure, relationships, and behaviour of a software system'),
    ('c', 'Measure the performance and execution speed of an object-oriented program'),
    ('d', 'Replace written documentation by embedding descriptions directly into the compiled bytecode')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 5;

-- Ch4 Q6 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Objects can create other objects without any instruction from the programmer'),
    ('b', 'Objects run independently on separate threads and do not share memory with other objects'),
    ('c', 'An object is responsible for managing its own data; its internal state should only be modified through its own methods rather than being directly manipulated by external code'),
    ('d', 'Objects automatically release their memory when they are no longer referenced by the program')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 6;

-- Ch4 Q7 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A special operator used to change the value of a variable during arithmetic evaluation'),
    ('b', 'A keyword such as public, private, or static that specifies the accessibility or behaviour of a class, method, or variable'),
    ('c', 'A method that specifically changes the value of a private instance variable'),
    ('d', 'A statement that alters the flow of control within a conditional block')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 7;

-- Ch4 Q8 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Constants must always be declared public because Java does not permit private constants'),
    ('b', 'Making a constant public allows it to be modified by any class that needs to update its value'),
    ('c', 'A constant can safely be made public because its value cannot be changed; sharing it widely is therefore convenient without risking corruption of the object''s state'),
    ('d', 'Public constants execute faster than private constants because the JVM accesses them directly')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 8;

-- Ch4 Q9 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A public method is accessible only within its own class; a private method is accessible from anywhere; a public variable can be read but not modified externally; a private variable is accessible from anywhere in the program'),
    ('b', 'A public method is accessible from any class; a private method is accessible only within its own class; a public variable is accessible from any class; a private variable is accessible only within its own class'),
    ('c', 'A public method and a private method behave identically; visibility only affects variables, not methods'),
    ('d', 'A public variable is accessible only within its package; a private variable is accessible only within its own method')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 9;

-- Ch4 Q10 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The complete internal implementation of an object, including all private variables and methods'),
    ('b', 'The graphical representation of an object displayed to the end user on screen'),
    ('c', 'The set of public methods through which other objects interact with and invoke the services of that object'),
    ('d', 'The constructor of an object that initialises its state when it is first created')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 10;

-- Ch4 Q11 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Methods are always invoked through a class name; objects are never used to call methods directly'),
    ('b', 'A method is invoked through an object because it operates on that object''s specific data; the exception is a static method, which belongs to the class itself and can be called without an object instance'),
    ('c', 'A method is invoked through an object to improve performance; the exception occurs when the method returns void'),
    ('d', 'Methods must always be invoked through an object; there are no exceptions to this rule in Java')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 11;

-- Ch4 Q12 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The method prints a result to the console before terminating'),
    ('b', 'The method stores its result in a globally accessible variable for other methods to use'),
    ('c', 'Upon completing its execution, the method passes a value back to the code that called it, which can then use that value in a further expression or assignment'),
    ('d', 'The method creates a new object and assigns it to the variable used in the method call')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 12;

-- Ch4 Q13 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'It restarts the execution of the current method from the beginning'),
    ('b', 'It terminates the execution of the current method and optionally passes a value back to the caller'),
    ('c', 'It transfers control to the main method regardless of where in the program it appears'),
    ('d', 'It declares the data type of the value that a method is expected to produce')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 13;

-- Ch4 Q14 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Yes, every Java method must include at least one return statement'),
    ('b', 'No, a return statement is only required in methods declared with a non-void return type; methods declared as void do not require one, though they may include a bare return to exit early'),
    ('c', 'No, return statements are entirely optional and are only used as a stylistic choice'),
    ('d', 'Yes, but only in methods that are declared static')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 14;

-- Ch4 Q15 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'An actual parameter is declared in the method signature; a formal parameter is the value supplied when the method is called'),
    ('b', 'Formal parameters and actual parameters are identical; the two terms are used interchangeably in Java'),
    ('c', 'A formal parameter is the variable declared in the method signature that receives the value; an actual parameter is the specific value or variable supplied by the caller when the method is invoked'),
    ('d', 'An actual parameter must always be a literal value; a formal parameter must always be a variable')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 15;

-- Ch4 Q16 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Constructors are used to destroy an object when it is no longer needed; they are defined using the keyword destructor'),
    ('b', 'Constructors are used to initialise a newly created object''s state; they are defined with the same name as the class, no return type, and are invoked automatically when an object is created with new'),
    ('c', 'Constructors are used to copy the values of one object into another; they must always be declared private'),
    ('d', 'Constructors are standard methods used to modify an object''s attributes; they are distinguished by beginning with an uppercase letter')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 16;

-- Ch4 Q17 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A static variable is declared inside a method; an instance variable is declared inside a constructor'),
    ('b', 'A static variable belongs to the class itself and is shared across all instances of that class; an instance variable belongs to each individual object and holds a separate value for every instance'),
    ('c', 'A static variable can only store primitive values; an instance variable can store both primitive values and objects'),
    ('d', 'There is no practical difference; both types of variable behave identically at runtime')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 17;

-- Ch4 Q18 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The main method can reference any variable declared anywhere in the program because it is the entry point of execution'),
    ('b', 'The main method can only reference local variables declared within its own body'),
    ('c', 'Because main is a static method, it can only directly reference other static variables and locally declared variables; it cannot directly access instance variables without first creating an object'),
    ('d', 'The main method can reference private variables of any class because it has special compiler-level access')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 18;

-- Ch4 Q19 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'One class permanently contains an instance of the other class as one of its attributes'),
    ('b', 'Two classes share the same parent class and therefore inherit identical methods and variables'),
    ('c', 'One class relies on another class in order to perform some of its functionality, typically by using an object of that class as a parameter or local variable rather than storing it as an attribute'),
    ('d', 'Both classes implement the same interface and are therefore interchangeable at runtime')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 19;

-- Ch4 Q20 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Overloaded methods must have different return types, regardless of their parameter lists'),
    ('b', 'Overloaded methods are distinguished by their parameter lists — specifically by the number, order, or types of their parameters; the method name remains the same'),
    ('c', 'Overloaded methods must be declared in different classes; two methods in the same class cannot share a name'),
    ('d', 'Overloaded methods are distinguished solely by their visibility modifiers, such as public versus private')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 20;

-- Ch4 Q21 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The process of converting a method''s bytecode back into readable Java source code'),
    ('b', 'A debugging technique that removes faulty methods from a class one at a time'),
    ('c', 'The practice of breaking a complex problem or method down into smaller, simpler, and more manageable supporting methods, each responsible for a distinct subtask'),
    ('d', 'The automatic removal of unused methods by the Java compiler during optimisation')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 21;

-- Ch4 Q22 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A class associates with itself whenever it declares a static variable of a primitive type'),
    ('b', 'A class has an association with itself when one of its instance variables is of the same class type, meaning an object of that class holds a reference to another object of the same class'),
    ('c', 'A class automatically associates with itself whenever it implements an interface'),
    ('d', 'A self-association occurs when a class declares its constructor as private')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 22;

-- Ch4 Q23 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'An object that inherits all of its attributes and methods from a parent class'),
    ('b', 'An object that can only be created through a factory method rather than directly via a constructor'),
    ('c', 'An object that is composed of or contains references to other objects as part of its internal state, representing a "has-a" relationship'),
    ('d', 'An object that implements multiple interfaces simultaneously')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 23;

-- Ch4 Q24 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The parent class of the currently executing object'),
    ('b', 'The next object to be created by the constructor currently in execution'),
    ('c', 'The current object — the specific instance on which the method or constructor is being invoked'),
    ('d', 'The class definition itself, equivalent to using the class name directly')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 24;

-- Ch4 Q25 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Objects are passed by value, meaning a complete independent copy of the object is created and passed to the method'),
    ('b', 'Objects are passed by passing a copy of the reference to the object, meaning the method receives access to the same underlying object in memory, and changes to its state are reflected outside the method'),
    ('c', 'Objects cannot be passed as parameters in Java; only primitive values may be passed directly'),
    ('d', 'Objects are passed by reference, meaning the method receives the actual memory address and can reassign the original variable to point to a different object')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 25;

-- Ch4 Q26 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A test designed to measure the execution speed and memory usage of a program'),
    ('b', 'A test specifically designed to reveal errors, bugs, or incorrect behaviour in a program, with the deliberate goal of finding faults rather than demonstrating correct operation'),
    ('c', 'A test that verifies a program produces no compiler warnings or errors'),
    ('d', 'A formal process of comparing two versions of a program to determine which performs better')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 26;

-- Ch4 Q27 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A tool that automatically rewrites faulty code and replaces it with a corrected version'),
    ('b', 'A compiler extension that prevents programs with logical errors from being executed'),
    ('c', 'A software tool that allows a programmer to pause execution, step through code line by line, and inspect the values of variables in order to locate and diagnose errors'),
    ('d', 'A testing framework that automatically generates test cases based on a method''s signature')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: Writing Classes') AND qq.order_index = 27;

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 5 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('Which of the following best describes the relationship between a parent class and a child class?', 'b', 1),
    ('How does inheritance support software reuse?', 'b', 2),
    ('What relationship should every class derivation represent?', 'c', 3),
    ('What does the protected modifier accomplish in Java?', 'c', 4),
    ('Why is the super reference important to a child class?', 'b', 5),
    ('What is the difference between single inheritance and multiple inheritance?', 'b', 6),
    ('Why would a child class override one or more methods of its parent class?', 'c', 7),
    ('What is the significance of the Object class in Java?', 'b', 8),
    ('What is the role of an abstract class in Java?', 'b', 9),
    ('Are all members of a parent class inherited by its child class? Explain.', 'c', 10),
    ('How can the final modifier be used to restrict inheritance in Java?', 'b', 11)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 5 Quiz: Inheritance';

-- Ch5 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A parent class is created from a child class by removing unnecessary methods and variables'),
    ('b', 'A parent class defines general attributes and behaviours that are inherited by a child class, which extends the parent by adding more specific attributes, behaviours, or both'),
    ('c', 'A parent class and a child class are completely independent; they share a name but no code'),
    ('d', 'A child class must override every method defined in its parent class in order to function correctly')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 1;

-- Ch5 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Inheritance allows a child class to copy and paste code from a parent class directly into its own source file, avoiding the need for compilation'),
    ('b', 'Inheritance allows a child class to automatically acquire the attributes and methods of its parent class without rewriting or duplicating that code, enabling existing functionality to be extended and built upon rather than reimplemented from scratch'),
    ('c', 'Inheritance supports software reuse by forcing all classes in a hierarchy to share the same constructor implementation'),
    ('d', 'Inheritance eliminates the need for testing because reused code from a parent class is already guaranteed to be correct')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 2;

-- Ch5 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A "has-a" relationship, meaning the child class contains an instance of the parent class as one of its attributes'),
    ('b', 'A "uses-a" relationship, meaning the child class depends on the parent class to perform certain operations'),
    ('c', 'An "is-a" relationship, meaning every object of the child class is also legitimately an object of the parent class type'),
    ('d', 'A "creates-a" relationship, meaning the child class is responsible for instantiating objects of the parent class')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 3;

-- Ch5 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'It makes a member accessible only within the class in which it is declared, identical in behaviour to private'),
    ('b', 'It makes a member accessible from any class anywhere in the program, identical in behaviour to public'),
    ('c', 'It makes a member accessible within its own class, within any subclass of that class, and within any class in the same package, while still restricting access from unrelated classes outside the package'),
    ('d', 'It prevents a member from being overridden or modified by any subclass that inherits it')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 4;

-- Ch5 Q5 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The super reference allows a child class to create a new instance of its parent class without using the new keyword'),
    ('b', 'The super reference allows a child class to explicitly invoke a constructor or method of its parent class, which is especially important for ensuring the parent''s initialisation logic is executed when a child object is created'),
    ('c', 'The super reference is used to determine at runtime whether a given object belongs to a parent class or a child class'),
    ('d', 'The super reference grants a child class access to the private members of its parent class, bypassing normal visibility restrictions')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 5;

-- Ch5 Q6 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Single inheritance means a class can be extended by only one child class; multiple inheritance means a class can be extended by many child classes simultaneously'),
    ('b', 'Single inheritance allows a child class to extend exactly one parent class; multiple inheritance allows a child class to extend more than one parent class directly, inheriting from all of them'),
    ('c', 'Single inheritance is supported only by interfaces in Java; multiple inheritance is supported only by abstract classes'),
    ('d', 'Single inheritance and multiple inheritance are identical concepts; the terms differ only in the number of methods defined in the parent class')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 6;

-- Ch5 Q7 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'To completely remove inherited behaviour that the child class does not need, replacing it with an empty method body'),
    ('b', 'Because Java requires every inherited method to be overridden before the child class can be successfully compiled'),
    ('c', 'To provide a more specific or appropriate implementation of a method for the child class type, replacing the general behaviour defined in the parent with behaviour better suited to the child''s particular purpose'),
    ('d', 'To change the return type or visibility modifier of an inherited method without altering its implementation logic')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 7;

-- Ch5 Q8 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The Object class is an abstract class that must be explicitly extended by every user-defined class in a Java program'),
    ('b', 'The Object class is the root of the entire Java class hierarchy; every class in Java either directly or indirectly extends Object, meaning all Java objects share a common set of fundamental methods such as toString, equals, and hashCode'),
    ('c', 'The Object class serves as a utility class containing only static methods for performing common operations on primitive data types'),
    ('d', 'The Object class is significant because it is the only class in Java that can be instantiated without using the new keyword')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 8;

-- Ch5 Q9 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'An abstract class is a fully implemented class that serves as a template to be copied and modified by the programmer for each new use case'),
    ('b', 'An abstract class defines a common interface and may provide partial implementation for a group of related subclasses, while declaring one or more abstract methods that subclasses are required to implement; it cannot itself be instantiated'),
    ('c', 'An abstract class is one that has been deprecated and should no longer be used in new Java programs'),
    ('d', 'An abstract class is identical to an interface; the two terms are interchangeable in modern Java')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 9;

-- Ch5 Q10 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Yes, every member of a parent class — including private members, constructors, and static initialisers — is fully accessible and directly usable by the child class'),
    ('b', 'Yes, all members are inherited, but only public members can be overridden; private and protected members are inherited but remain fixed'),
    ('c', 'No, not all members are inherited in a fully accessible sense; private members of the parent class are not directly accessible within the child class, and constructors are not inherited at all, though they can be invoked via the super reference'),
    ('d', 'No, only public and static members are inherited; protected members are excluded from inheritance entirely')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 10;

-- Ch5 Q11 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A final variable prevents a child class from declaring any new variables with the same name'),
    ('b', 'A final class cannot be extended by any other class, and a final method cannot be overridden by any subclass, effectively preventing further modification of that class or method further down the inheritance hierarchy'),
    ('c', 'A final modifier on a class prevents it from implementing any interfaces, restricting it to class-based inheritance only'),
    ('d', 'A final method forces all subclasses to override it, ensuring each child class provides its own specific implementation')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 5 Quiz: Inheritance') AND qq.order_index = 11;

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 6 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('What is polymorphism in object-oriented programming?', 'b', 1),
    ('How does inheritance support polymorphism?', 'b', 2),
    ('How is method overriding related to polymorphism?', 'c', 3),
    ('Why is the StaffMember class in the Firm example declared as abstract?', 'b', 4),
    ('Why is the pay method declared in the StaffMember class even though it is abstract and has no body at that level?', 'b', 5),
    ('What is the difference between a class and an interface in Java?', 'a', 6),
    ('How do class hierarchies and interface hierarchies intersect in Java?', 'b', 7),
    ('Which of the following best describes the Comparable interface in Java?', 'b', 8),
    ('How can polymorphism be accomplished using interfaces in Java?', 'b', 9)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 6 Quiz: Polymorphism';

-- Ch6 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The ability of a class to inherit attributes and methods from multiple parent classes simultaneously'),
    ('b', 'The ability of a single reference type to refer to objects of different types and to invoke behaviour appropriate to the actual type of the object at runtime'),
    ('c', 'The process of hiding the internal implementation details of a class from external code'),
    ('d', 'The mechanism by which a class defines multiple constructors with different parameter lists')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 1;

-- Ch6 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Inheritance forces all subclasses to share exactly the same method implementations as the parent class, ensuring consistent behaviour'),
    ('b', 'Inheritance allows a subclass to be treated as an instance of its parent class, meaning a parent class reference can point to a subclass object and invoke overridden methods appropriate to the actual subclass type'),
    ('c', 'Inheritance prevents subclasses from overriding methods, which guarantees that polymorphism cannot introduce unexpected behaviour'),
    ('d', 'Inheritance supports polymorphism by allowing a class to implement multiple unrelated interfaces at the same time')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 2;

-- Ch6 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Overriding is unrelated to polymorphism; it is only used to improve the performance of inherited methods'),
    ('b', 'Overriding allows a subclass to replace a parent class method with a version that has a different name, enabling the program to select the correct method at compile time'),
    ('c', 'Overriding allows a subclass to provide its own specific implementation of a method defined in the parent class; polymorphism then ensures that the correct overridden version is called at runtime based on the actual type of the object, not the declared type of the reference'),
    ('d', 'Overriding and overloading are the same concept; both contribute equally to polymorphism in Java')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 3;

-- Ch6 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Because StaffMember needs to prevent any other class from inheriting from it'),
    ('b', 'Because StaffMember represents a general concept that should never be instantiated directly — no employee is simply a "staff member" without being a more specific type such as a volunteer or an employee; declaring it abstract enforces this constraint'),
    ('c', 'Because abstract classes execute faster than concrete classes and the Firm example is performance-critical'),
    ('d', 'Because Java requires any class that contains instance variables to be declared abstract')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 4;

-- Ch6 Q5 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Declaring it in StaffMember is a Java syntax requirement; abstract methods must always have a body in the class where they are first declared'),
    ('b', 'Declaring the abstract pay method in StaffMember establishes a common contract that all subclasses are required to fulfil; it also allows polymorphism to work correctly, since a StaffMember reference can invoke pay without knowing the specific subclass type at compile time'),
    ('c', 'The pay method is declared in StaffMember only to document its existence; it has no effect on subclass behaviour or polymorphism'),
    ('d', 'It is declared there so that the StaffMember class can provide a default payment amount that all subclasses automatically inherit without needing to override it')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 5;

-- Ch6 Q6 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A class can be instantiated and may contain both method implementations and instance variables; an interface defines a contract of abstract methods (and optionally constants) that implementing classes must fulfil, and cannot be instantiated directly'),
    ('b', 'A class and an interface are identical in structure; the only difference is that interfaces use a different keyword for declaration'),
    ('c', 'An interface may contain fully implemented methods and instance variables, while a class may only declare method signatures without implementations'),
    ('d', 'A class supports multiple inheritance by default, while an interface restricts a type to a single parent')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 6;

-- Ch6 Q7 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A class hierarchy and an interface hierarchy are entirely separate and can never interact within the same program'),
    ('b', 'A class can extend only one parent class within the class hierarchy, but it can implement multiple interfaces from one or more interface hierarchies simultaneously, allowing a single class to participate in both structures at once'),
    ('c', 'Interface hierarchies replace class hierarchies entirely in modern Java; classes no longer need to extend other classes when interfaces are available'),
    ('d', 'A class may implement only one interface, just as it may extend only one parent class, keeping both hierarchies strictly parallel')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 7;

-- Ch6 Q8 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The Comparable interface provides a set of mathematical methods for performing arithmetic comparisons between numeric objects'),
    ('b', 'The Comparable interface defines a single method, compareTo, which classes implement to establish a natural ordering between objects of that type, enabling them to be sorted and compared consistently'),
    ('c', 'The Comparable interface is used exclusively by the Java Collections Framework and cannot be implemented by user-defined classes'),
    ('d', 'The Comparable interface provides two methods, equals and hashCode, which together define how objects are compared for equality')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 8;

-- Ch6 Q9 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Polymorphism through interfaces is not possible; it can only be achieved through class inheritance'),
    ('b', 'An interface reference can point to any object of a class that implements that interface; the correct version of the method is then selected at runtime based on the actual type of the object, enabling polymorphic behaviour across classes that may not share a common parent class'),
    ('c', 'Polymorphism through interfaces requires all implementing classes to belong to the same class hierarchy'),
    ('d', 'An interface achieves polymorphism by providing a default implementation of every method that all implementing classes automatically inherit and execute identically')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 6 Quiz: Polymorphism') AND qq.order_index = 9;
