-- BCrypt hashed passwords: 'admin' and 'password'
INSERT INTO users (username, password, role, full_name) VALUES 
('admin', '$2a$10$F7rgPYsTAetnmbLY3Qih2ejZ.k09o4fKpw7thQ6DFO77ZpByNWLIu', 'ADMIN', 'System Administrator');

INSERT INTO courses (title, description) VALUES
('Java Programming', 'Learn Java from scratch');

INSERT INTO units (course_id, title, section, content, order_index) VALUES
(1, 'Introduction to Java', 'Basics', 'Java history and setup', 1),
(1, 'Data Types', 'Basics', 'Variables and types', 2),
(1, 'Control Flow', 'Logic', 'If-else and loops', 3);
