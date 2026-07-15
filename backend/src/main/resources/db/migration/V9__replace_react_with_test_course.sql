-- ── Add Test course ───────────────────────────────────────────────────────────

INSERT INTO courses (title, description)
VALUES ('Test', 'A sample course used to verify that the quiz system works end-to-end.');

INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'Test Quiz', 'Test Section', '', 1, 'quiz', NULL
FROM courses WHERE title = 'Test';

INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, 'Which of the following options is the correct answer?', 'a', 1
FROM units u WHERE u.title = 'Test Quiz';

INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', '✅ CORRECT — This is option A and it is the right answer'),
    ('b', '❌ Wrong — This is option B and it is incorrect'),
    ('c', '❌ Wrong — This is option C and it is incorrect'),
    ('d', '❌ Wrong — This is option D and it is incorrect')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Test Quiz')
  AND qq.order_index = 1;
