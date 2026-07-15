-- Insert JavaScript course
INSERT INTO courses (title, description) VALUES
('JavaScript', 'A beginner-friendly course covering JavaScript fundamentals, from getting started to core language essentials.');

-- ══════════════════════════════════════════════════════════════════
-- UNITS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT c.id, v.title, v.section, '', v.ord, v.type, v.pdf
FROM courses c
CROSS JOIN (VALUES
    ('Getting Started with JavaScript',                     'Chapter 1', 1, 'lesson', 'javaScript/1. Getting Started with JavaScript.pdf'),
    ('Chapter 1 Quiz: Getting Started with JavaScript',    'Chapter 1', 2, 'quiz',   NULL),
    ('JavaScript Essentials',                               'Chapter 2', 3, 'lesson', 'javaScript/2. Chapter 2 JavaScript Essentials.pdf'),
    ('Chapter 2 Quiz: JavaScript Essentials',              'Chapter 2', 4, 'quiz',   NULL)
) AS v(title, section, ord, type, pdf)
WHERE c.title = 'JavaScript';

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 1 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('What is the correct HTML syntax to add an external JavaScript file to a web page?', 'b', 1),
    ('Can you run JavaScript directly in a browser by opening a file with a .js extension?', 'b', 2),
    ('How do you write a multiple-line comment in JavaScript?', 'b', 3),
    ('What is the best way to temporarily remove a line of code from running, while keeping it in the file for later use during debugging?', 'b', 4)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 1 Quiz: Getting Started with JavaScript';

-- Ch1 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '<script href="script.js"></script>'),
    ('b', '<script src="script.js"></script>'),
    ('c', '<javascript file="script.js"></javascript>'),
    ('d', '<link rel="javascript" src="script.js">')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Getting Started with JavaScript') AND qq.order_index = 1;

-- Ch1 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Yes, browsers can execute .js files directly when opened on their own, just like opening an HTML file'),
    ('b', 'No, a .js file cannot be run on its own in a browser; it must be linked to or embedded within an HTML document using a script tag in order for the browser to execute it'),
    ('c', 'Yes, but only if the file is renamed to use a .html extension first'),
    ('d', 'No, JavaScript files can only be executed using a separate command-line tool such as Node.js, never within a browser')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Getting Started with JavaScript') AND qq.order_index = 2;

-- Ch1 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'By starting each line with //'),
    ('b', 'By enclosing the comment text between /* and */'),
    ('c', 'By enclosing the comment text between <!-- and -->'),
    ('d', 'By enclosing the comment text between # and #')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Getting Started with JavaScript') AND qq.order_index = 3;

-- Ch1 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Permanently delete the line of code and rewrite it manually later if it is needed again'),
    ('b', 'Comment out the line using // or /* */, so the code remains in the file but is ignored by the JavaScript engine'),
    ('c', 'Move the line of code to a completely separate, unused file until it is needed again'),
    ('d', 'Rename the variable inside that line so the browser skips it during execution')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Getting Started with JavaScript') AND qq.order_index = 4;

-- ══════════════════════════════════════════════════════════════════
-- CHAPTER 2 QUIZ QUESTIONS
-- ══════════════════════════════════════════════════════════════════
INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('What data type is the result of: const c = "5";', 'b', 1),
    ('What data type is the result of: const c = 91;', 'a', 2),
    ('Which is generally considered better practice: assigning undefined explicitly (line 1) or assigning null (line 2) to indicate no value?', 'b', 3),
    ('What is the console output for: let a = "Hello"; a = "world"; console.log(a);', 'b', 4),
    ('What will be logged for: let a = "world"; let b = `Hello $${a}!`; console.log(b);', 'b', 5),
    ('What is the value of a after: let a = "Hello"; a = prompt("world"); console.log(a);', 'c', 6),
    ('What is the value of b in: let a = 5; let b = 70; let c = "5"; b++; console.log(b);', 'b', 7),
    ('What is the value of result in: let result = 3 + 4 * 2 / 8;', 'b', 8),
    ('Given: let firstNum=5; let secondNum=10; firstNum++; secondNum--; let total=++firstNum+secondNum; then let total2=500+100/5+total--; what are total and total2?', 'b', 9),
    ('What is logged for: const a=5; const b=10; console.log(a>0 && b>0); console.log(a==5 && b==4); console.log(true||false); console.log(a==3||b==10); console.log(a==3||b==7);', 'b', 10)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 2 Quiz: JavaScript Essentials';

-- Ch2 Q1 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Number'),
    ('b', 'String'),
    ('c', 'Boolean'),
    ('d', 'Undefined')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 1;

-- Ch2 Q2 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Number'),
    ('b', 'String'),
    ('c', 'Boolean'),
    ('d', 'Object')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 2;

-- Ch2 Q3 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Line 1 is better, because undefined should always be assigned explicitly by the programmer'),
    ('b', 'Line 2 is better, because null is an explicit assignment chosen deliberately by the programmer to indicate no value, whereas undefined is normally left for JavaScript to assign automatically to variables that have not yet been given a value'),
    ('c', 'Both lines are equally acceptable and there is no meaningful difference between them'),
    ('d', 'Line 1 is better, because undefined uses less memory than null')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 3;

-- Ch2 Q4 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Hello'),
    ('b', 'world'),
    ('c', 'Helloworld'),
    ('d', 'undefined')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 4;

-- Ch2 Q5 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Hello $${a}!'),
    ('b', 'Hello world!'),
    ('c', 'Hello a!'),
    ('d', 'undefined')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 5;

-- Ch2 Q6 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The value will always be "Hello", since prompt does not affect the variable'),
    ('b', 'The value will always be "world", since that is the text passed into prompt'),
    ('c', 'The value will be whatever the user types into the prompt dialog box, since prompt displays a message and returns the user input as a string'),
    ('d', 'The value will be undefined, since prompt cannot be assigned to a variable')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 6;

-- Ch2 Q7 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '70'),
    ('b', '71'),
    ('c', '75'),
    ('d', '"71"')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 7;

-- Ch2 Q8 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '1.75'),
    ('b', '4'),
    ('c', '2'),
    ('d', '0.875')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 8;

-- Ch2 Q9 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'total = 15, total2 = 535'),
    ('b', 'total = 16, total2 = 536'),
    ('c', 'total = 16, total2 = 535'),
    ('d', 'total = 15, total2 = 536')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 9;

-- Ch2 Q10 options
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'true, true, true, true, false'),
    ('b', 'true, false, true, true, false'),
    ('c', 'false, false, true, true, true'),
    ('d', 'true, false, false, true, true')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: JavaScript Essentials') AND qq.order_index = 10;
