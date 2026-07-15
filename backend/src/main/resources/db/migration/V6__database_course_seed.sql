-- V6__database_course_seed.sql
-- Seed data for "Database Systems" course with 4 chapters

-- Insert course
INSERT INTO courses (title, description) VALUES ('Database Systems', 'Learn DB Systems');

-- ============================================================
-- UNITS
-- ============================================================

-- Chapter 1: Introduction to Databases
INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'Introduction to Databases', 'Chapter 1', '', 1, 'lesson', 'database/1. Introduction to Databases.pdf'
FROM courses WHERE title = 'Database Systems';

INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'Chapter 1 Quiz: Introduction to Databases', 'Chapter 1', '', 2, 'quiz', NULL
FROM courses WHERE title = 'Database Systems';

-- Chapter 2: Database Environment
INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'Database Environment', 'Chapter 2', '', 3, 'lesson', 'database/2. Database Environment.pdf'
FROM courses WHERE title = 'Database Systems';

INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'Chapter 2 Quiz: Database Environment', 'Chapter 2', '', 4, 'quiz', NULL
FROM courses WHERE title = 'Database Systems';

-- Chapter 3: The Relational Model
INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'The Relational Model', 'Chapter 3', '', 5, 'lesson', 'database/3. The Relational Model.pdf'
FROM courses WHERE title = 'Database Systems';

INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'Chapter 3 Quiz: The Relational Model', 'Chapter 3', '', 6, 'quiz', NULL
FROM courses WHERE title = 'Database Systems';

-- Chapter 4: SQL Data Manipulation
INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'SQL: Data Manipulation', 'Chapter 4', '', 7, 'lesson', 'database/4. SQL_ Data Manipulation.pdf'
FROM courses WHERE title = 'Database Systems';

INSERT INTO units (course_id, title, section, content, order_index, unit_type, pdf_path)
SELECT id, 'Chapter 4 Quiz: SQL Data Manipulation', 'Chapter 4', '', 8, 'quiz', NULL
FROM courses WHERE title = 'Database Systems';

-- ============================================================
-- CHAPTER 1 QUIZ QUESTIONS (20 questions)
-- ============================================================

INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('Which of the following best represents four government sectors that commonly use database systems?', 'b', 1),
    ('Which of the following correctly defines data in the context of database systems?', 'b', 2),
    ('Which of the following best defines a database?', 'c', 3),
    ('Which of the following best describes a Database Management System (DBMS)?', 'c', 4),
    ('What is a database application program?', 'b', 5),
    ('What does data independence mean in the context of a database system?', 'c', 6),
    ('In the context of database management, what does security refer to?', 'b', 7),
    ('What does integrity mean in the context of a database system?', 'c', 8),
    ('What are views in the context of a database management system?', 'c', 9),
    ('Which of the following best describes the role of a DBMS in the database approach, and why is knowledge of DBMS important for database administrators?', 'b', 10),
    ('Which of the following best contrasts the database approach with the file-based approach?', 'c', 11),
    ('Which of the following correctly identifies the five components of the DBMS environment?', 'a', 12),
    ('Which of the following correctly describes the role of a Data Administrator (DA)?', 'b', 13),
    ('Which of the following best describes the role of a Database Administrator (DBA)?', 'c', 14),
    ('Which of the following correctly describes the role of a Logical Database Designer?', 'b', 15),
    ('Which of the following best describes the role of a Physical Database Designer?', 'c', 16),
    ('Which of the following best describes the role of an Application Developer in the database environment?', 'b', 17),
    ('Which of the following best characterises the role of end users in the database environment?', 'b', 18),
    ('Which of the following correctly describes the three generations of DBMSs in chronological order?', 'b', 19),
    ('Why are views an important aspect of database management systems?', 'b', 20)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 1 Quiz: Introduction to Databases';

-- ============================================================
-- CHAPTER 1 QUIZ OPTIONS
-- ============================================================

-- Q1
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Agriculture, entertainment, fashion, and tourism'),
    ('b', 'Healthcare, taxation, law enforcement, and education'),
    ('c', 'Mining, architecture, journalism, and retail'),
    ('d', 'Hospitality, cosmetics, sports, and advertising')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 1;

-- Q2
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Data refers to processed information that has already been interpreted and presented to the end user in a meaningful format'),
    ('b', 'Data refers to raw, unprocessed facts and figures that are recorded and stored, from which meaningful information can be derived'),
    ('c', 'Data refers exclusively to numerical values stored in spreadsheet files'),
    ('d', 'Data refers to the software tools used to organise and retrieve stored records')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 2;

-- Q3
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A single file stored on disk that contains rows and columns of numerical values'),
    ('b', 'A collection of application programs used to process and display information to end users'),
    ('c', 'A shared, integrated, and structured collection of logically related data, organised to meet the information needs of an organisation'),
    ('d', 'A programming language used to define and manipulate structured data')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 3;

-- Q4
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A hardware device specifically designed to accelerate the reading and writing of data to disk'),
    ('b', 'A set of manual procedures followed by database administrators to maintain data integrity'),
    ('c', 'A software system that enables users to define, create, maintain, and control access to a database'),
    ('d', 'An application program that generates reports from raw data files without requiring a structured database')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 4;

-- Q5
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The core software engine responsible for storing and indexing data on physical storage devices'),
    ('b', 'A program that interacts with the database by issuing requests to the DBMS in order to retrieve, insert, update, or delete data on behalf of end users'),
    ('c', 'A utility tool built into the operating system that backs up database files automatically'),
    ('d', 'A program that replaces the DBMS entirely by directly accessing raw data files on disk')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 5;

-- Q6
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The ability of a database to operate without requiring any human administration or maintenance'),
    ('b', 'The capacity to store data on independent physical devices so that no single point of failure can cause data loss'),
    ('c', 'The separation of data descriptions from the application programs that use the data, so that changes to the data structure do not require changes to those programs'),
    ('d', 'The enforcement of rules that prevent unauthorised users from accessing or modifying stored data')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 6;

-- Q7
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The process of making regular backup copies of the database to protect against hardware failure'),
    ('b', 'The protection of the database against unauthorised access, misuse, or malicious modification through the enforcement of access controls and authentication mechanisms'),
    ('c', 'The guarantee that data stored in the database remains accurate, consistent, and free from corruption'),
    ('d', 'The encryption of all data transmitted between the database server and client application programs')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 7;

-- Q8
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The restriction of database access to a limited number of authorised administrators only'),
    ('b', 'The ability of the database to replicate its data across multiple physical servers simultaneously'),
    ('c', 'The assurance that the data stored in the database is accurate, consistent, and satisfies defined rules and constraints at all times'),
    ('d', 'The process of merging data from multiple separate databases into a single unified repository')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 8;

-- Q9
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Graphical user interfaces that allow end users to interact with the database using visual forms and menus'),
    ('b', 'Physical copies of tables stored on disk to improve query performance'),
    ('c', 'Virtual or logical representations of data derived from one or more base tables, presenting a customised subset of the database to specific users without altering the underlying stored data'),
    ('d', 'Reports automatically generated by the DBMS and exported to spreadsheet files')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 9;

-- Q10
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A DBMS simply stores data in flat files; knowledge of it is only necessary for software developers, not database administrators'),
    ('b', 'A DBMS acts as an intermediary between the physical database and the users or application programs, managing data definition, storage, retrieval, and control; database administrators must understand it thoroughly in order to design efficient structures, maintain performance, enforce security, and ensure data integrity'),
    ('c', 'A DBMS is important only during the initial setup of a database; once established, no further knowledge of its internal workings is required'),
    ('d', 'A DBMS replaces the need for a database administrator entirely by automating all data management tasks')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 10;

-- Q11
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The file-based approach centralises data and eliminates redundancy, while the database approach stores separate files for each application, leading to data duplication'),
    ('b', 'Both approaches are functionally identical; the database approach simply uses more modern file formats'),
    ('c', 'In the file-based approach, each application maintains its own separate data files, leading to data redundancy, inconsistency, and limited data sharing; the database approach centralises data in a shared repository managed by a DBMS, reducing redundancy and supporting data independence, integrity, and controlled access'),
    ('d', 'The database approach is only suitable for small organisations, while the file-based approach scales better for large enterprise systems')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 11;

-- Q12
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Hardware, software, data, procedures, and people'),
    ('b', 'Servers, clients, networks, applications, and backups'),
    ('c', 'Tables, queries, forms, reports, and macros'),
    ('d', 'Input devices, output devices, storage, memory, and processors')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 12;

-- Q13
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The DA is responsible for the physical storage structures and performance tuning of the database at a technical level'),
    ('b', 'The DA is a managerial role responsible for the overall policy, planning, and governance of an organisation''s data resources, including standards and data ownership decisions'),
    ('c', 'The DA writes and maintains the application programs that interact with the database on behalf of end users'),
    ('d', 'The DA designs the logical schema of the database by identifying entities, attributes, and relationships')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 13;

-- Q14
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The DBA defines the organisation''s overall data strategy and sets policies for data ownership and standards across the enterprise'),
    ('b', 'The DBA writes business application programs that retrieve and update data on behalf of end users'),
    ('c', 'The DBA is responsible for the technical implementation, maintenance, performance monitoring, backup, recovery, and security of the physical database system'),
    ('d', 'The DBA designs the conceptual data model by identifying the entities and relationships relevant to the business')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 14;

-- Q15
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The logical database designer translates the conceptual data model into physical storage structures optimised for the specific DBMS being used'),
    ('b', 'The logical database designer identifies and defines the entities, attributes, and relationships that represent the organisation''s data requirements, producing a conceptual or logical data model independent of any specific DBMS'),
    ('c', 'The logical database designer writes SQL queries and stored procedures to support business application programs'),
    ('d', 'The logical database designer monitors database performance and adjusts indexing strategies to improve query execution times')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 15;

-- Q16
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The physical database designer gathers business requirements and produces an abstract model of the data independent of any technology'),
    ('b', 'The physical database designer writes and tests the application programs that interact with the database on behalf of end users'),
    ('c', 'The physical database designer translates the logical data model into a physical implementation suited to a specific DBMS, making decisions about storage structures, indexing, access paths, and performance optimisation'),
    ('d', 'The physical database designer is responsible for enforcing data governance policies and resolving data ownership disputes across the organisation')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 16;

-- Q17
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The application developer designs the physical storage structures and indexing strategies used by the DBMS'),
    ('b', 'The application developer writes, tests, and maintains the programs that allow end users to interact with the database, typically using the DBMS interface or a programming language to issue data manipulation requests'),
    ('c', 'The application developer monitors network traffic between the database server and client machines to detect performance bottlenecks'),
    ('d', 'The application developer is responsible for defining the organisation''s data policies and ensuring compliance with data protection legislation')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 17;

-- Q18
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'End users design and maintain the underlying database schema and are responsible for its long-term structural integrity'),
    ('b', 'End users are the individuals who interact with the database through application programs or query interfaces to retrieve, insert, update, or delete data in support of their day-to-day business activities'),
    ('c', 'End users write stored procedures and triggers that automate data processing tasks within the DBMS'),
    ('d', 'End users are responsible for physical backups and the recovery of the database following system failures')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 18;

-- Q19
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Relational systems, object-oriented systems, and flat-file systems'),
    ('b', 'Hierarchical and network systems (first generation), relational systems (second generation), and object-relational or object-oriented systems (third generation)'),
    ('c', 'Spreadsheet systems, SQL systems, and NoSQL systems'),
    ('d', 'Manual filing systems, electronic filing systems, and cloud-based filing systems')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 19;

-- Q20
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Views physically duplicate data into separate tables, improving read performance for frequently executed queries'),
    ('b', 'Views are important because they provide customised, user-specific representations of the data without altering the underlying tables; they simplify complex queries, enhance security by restricting access to sensitive data, and support data independence by shielding users from changes to the underlying schema'),
    ('c', 'Views are important because they allow the database administrator to permanently delete records from multiple tables simultaneously through a single operation'),
    ('d', 'Views replace the need for access control mechanisms by ensuring that all users see exactly the same representation of the data at all times')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 1 Quiz: Introduction to Databases')
  AND qq.order_index = 20;

-- ============================================================
-- CHAPTER 2 QUIZ QUESTIONS (14 questions)
-- ============================================================

INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('Which of the following best explains the concept of a database schema and correctly identifies the three types of schema?', 'c', 1),
    ('What are data sublanguages, and why are they important?', 'b', 2),
    ('What is a data model, and which of the following correctly identifies and describes the main types?', 'c', 3),
    ('Which of the following best describes the function and importance of conceptual modelling?', 'b', 4),
    ('Which of the following best describes the types of facility expected in a multi-user DBMS?', 'b', 5),
    ('Which of the following facilities described for a multi-user DBMS would most likely be unnecessary in a standalone PC DBMS, and why?', 'b', 6),
    ('Which of the following best describes the function and importance of the system catalog in a DBMS?', 'b', 7),
    ('Which of the following correctly distinguishes between DDL and DML, and identifies typical operations in each?', 'b', 8),
    ('What is the key difference between a procedural DML and a nonprocedural DML?', 'b', 9),
    ('Which of the following correctly names four object-based data models?', 'b', 10),
    ('Which of the following correctly names three record-based data models and identifies their main differences?', 'b', 11),
    ('What is a transaction in the context of a database system, and which of the following is the best example of one?', 'c', 12),
    ('What is concurrency control, and why does a DBMS need a concurrency control facility?', 'b', 13),
    ('Which of the following correctly defines database integrity and explains how it differs from database security?', 'c', 14)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 2 Quiz: Database Environment';

-- ============================================================
-- CHAPTER 2 QUIZ OPTIONS
-- ============================================================

-- Q1
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A schema is a physical storage file; the three types are primary, secondary, and tertiary schemas'),
    ('b', 'A schema is a visual diagram of the database tables; the three types are entity, relationship, and attribute schemas'),
    ('c', 'A schema is a description or blueprint of the structure of a database; the three types are the external schema (individual user views), the conceptual schema (the logical structure of the entire database), and the internal schema (the physical storage structure)'),
    ('d', 'A schema is a collection of SQL queries; the three types are selection, insertion, and deletion schemas')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 1;

-- Q2
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Data sublanguages are programming languages such as Java or Python that are used exclusively to build database application programs'),
    ('b', 'Data sublanguages are specialised languages embedded within or used alongside a host programming language to allow users and programs to interact with a database; they are important because they provide standardised, structured mechanisms for defining, manipulating, and controlling data independently of the application logic'),
    ('c', 'Data sublanguages are natural language interfaces that allow end users to query a database using plain English sentences without any formal syntax'),
    ('d', 'Data sublanguages are scripting tools used solely by database administrators to automate backup and recovery procedures')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 2;

-- Q3
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A data model is a physical blueprint of how data is stored on disk; the main types are sequential, indexed, and hashed models'),
    ('b', 'A data model is a collection of SQL statements used to create and populate database tables; the main types are procedural, nonprocedural, and hybrid models'),
    ('c', 'A data model is an abstract representation of the data structures, relationships, and constraints used to organise data; the main types include object-based models (e.g. entity-relationship, object-oriented), record-based models (e.g. relational, hierarchical, network), and physical models'),
    ('d', 'A data model is a graphical tool used exclusively during the testing phase of a database project; the main types are black-box, white-box, and grey-box models')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 3;

-- Q4
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Conceptual modelling defines the physical storage structures and indexing strategies used by the DBMS to store data efficiently on disk'),
    ('b', 'Conceptual modelling produces a high-level, implementation-independent representation of an organisation''s data requirements, capturing entities, attributes, and relationships without concern for how the data will be physically stored; it is important because it provides a clear communication tool between stakeholders and designers and serves as the foundation for all subsequent database design stages'),
    ('c', 'Conceptual modelling is concerned exclusively with defining the SQL statements needed to create the tables of a relational database'),
    ('d', 'Conceptual modelling is a testing technique used to verify that a completed database behaves correctly under real-world operating conditions')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 4;

-- Q5
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A multi-user DBMS need only provide data storage and basic retrieval facilities, since performance and security are handled by the operating system'),
    ('b', 'A multi-user DBMS is expected to provide facilities for data storage and retrieval, concurrency control, transaction management, access control and security, data integrity enforcement, backup and recovery, a data dictionary or system catalog, and query processing and optimisation'),
    ('c', 'A multi-user DBMS is expected to provide only a graphical user interface and a report generation tool, as all other functions are managed by application programs'),
    ('d', 'A multi-user DBMS requires only user authentication and data encryption facilities, since these are the primary concerns in a shared environment')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 5;

-- Q6
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Data storage and retrieval facilities would be unnecessary in a standalone PC DBMS because a single user does not need to store data persistently'),
    ('b', 'Concurrency control and distributed transaction management facilities would largely be unnecessary in a standalone PC DBMS, since only one user accesses the database at a time, eliminating the risk of conflicting simultaneous transactions'),
    ('c', 'Backup and recovery facilities would be unnecessary in a standalone PC DBMS because data loss is not a concern for individual users'),
    ('d', 'Query processing and optimisation facilities would be unnecessary in a standalone PC DBMS because single-user queries are always simple and fast')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 6;

-- Q7
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The system catalog is a physical storage area on disk where all user data tables are permanently archived for backup purposes'),
    ('b', 'The system catalog, also known as the data dictionary, is a repository within the DBMS that stores metadata — information about the structure of the database itself, including definitions of tables, columns, data types, constraints, indexes, users, and access rights; it is important because the DBMS relies on it to manage, validate, and process all operations performed on the database'),
    ('c', 'The system catalog is a graphical interface that allows database administrators to browse and edit table contents without writing SQL'),
    ('d', 'The system catalog is an external document maintained by the data administrator that describes the organisation''s data policies and naming conventions')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 7;

-- Q8
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'DDL (Data Manipulation Language) is used to retrieve and update data, while DML (Data Definition Language) is used to create and drop tables; typical DDL operations include SELECT and UPDATE, while DML operations include CREATE and DROP'),
    ('b', 'DDL (Data Definition Language) is used to define and modify the structure of database objects such as tables, indexes, and schemas; typical operations include CREATE, ALTER, and DROP; DML (Data Manipulation Language) is used to work with the data stored within those structures; typical operations include SELECT, INSERT, UPDATE, and DELETE'),
    ('c', 'DDL and DML are two names for the same language; the distinction is only stylistic and has no practical significance in modern SQL'),
    ('d', 'DDL is used exclusively by end users to query data, while DML is used exclusively by database administrators to manage the physical storage of data')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 8;

-- Q9
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A procedural DML is used only for inserting and deleting data, while a nonprocedural DML is used only for retrieving data'),
    ('b', 'A procedural DML requires the user to specify both what data is needed and exactly how to navigate the database to retrieve it, step by step; a nonprocedural DML requires the user to specify only what data is needed, leaving the DBMS to determine the most efficient way to retrieve it'),
    ('c', 'A procedural DML can only be used by database administrators, while a nonprocedural DML is designed for use by untrained end users exclusively'),
    ('d', 'A procedural DML produces faster query results because it gives the DBMS explicit instructions, while a nonprocedural DML is slower because it relies on the DBMS to determine the access strategy')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 9;

-- Q10
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Relational model, hierarchical model, network model, and flat-file model'),
    ('b', 'Entity-Relationship model, object-oriented model, object-relational model, and semantic data model'),
    ('c', 'Sequential model, indexed model, hashed model, and clustered model'),
    ('d', 'Spreadsheet model, document model, key-value model, and columnar model')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 10;

-- Q11
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The sequential, indexed, and hashed models — they differ in how records are physically ordered on disk'),
    ('b', 'The relational, hierarchical, and network models — the relational model organises data into tables with relationships expressed through keys; the hierarchical model organises data as a tree structure with parent-child relationships; the network model extends the hierarchical model by allowing a child record to have more than one parent, forming a graph structure'),
    ('c', 'The document, key-value, and columnar models — they differ in the format used to store individual data records'),
    ('d', 'The flat-file, spreadsheet, and XML models — they differ in the file format used to represent structured data')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 11;

-- Q12
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A transaction is a single SQL SELECT statement used to retrieve data from one table; an example is retrieving a list of all customers from the customer table'),
    ('b', 'A transaction is an action performed by a database administrator to restructure the schema of the database; an example is adding a new column to an existing table'),
    ('c', 'A transaction is a logical unit of work consisting of one or more database operations that must all succeed or all fail together in order to preserve data integrity; an example is a bank transfer in which a debit from one account and a credit to another must both be completed or both be rolled back'),
    ('d', 'A transaction is an automated backup procedure triggered by the DBMS at regular intervals to protect against data loss')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 12;

-- Q13
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Concurrency control is the process of compressing data to allow more records to be stored simultaneously on a single disk'),
    ('b', 'Concurrency control is the mechanism by which a DBMS manages simultaneous access to the database by multiple users or processes, ensuring that concurrent transactions do not interfere with one another in ways that could lead to inconsistent or incorrect data; without it, problems such as lost updates, dirty reads, and uncommitted data could compromise data integrity'),
    ('c', 'Concurrency control is a security feature that limits the number of users who can be logged into the DBMS at any given time'),
    ('d', 'Concurrency control is a performance optimisation technique that caches frequently accessed data in memory to reduce disk access times for multiple simultaneous users')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 13;

-- Q14
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Database integrity and database security are identical concepts; both refer to the protection of data from unauthorised access and modification'),
    ('b', 'Database integrity refers to the physical protection of the hardware on which the database is stored; database security refers to the logical protection of the data itself'),
    ('c', 'Database integrity refers to the accuracy, consistency, and validity of the data stored in the database, enforced through constraints and rules that prevent invalid data from being entered or maintained; database security refers to the protection of the database from unauthorised access, modification, or disclosure through mechanisms such as access controls and authentication — integrity ensures the data is correct, while security ensures the data is protected'),
    ('d', 'Database integrity refers to the availability of the database to authorised users at all times; database security refers to the encryption of data during transmission between the client and the server')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 2 Quiz: Database Environment')
  AND qq.order_index = 14;

-- ============================================================
-- CHAPTER 3 QUIZ QUESTIONS (12 questions)
-- ============================================================

INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('Which of the following correctly defines a relation in the context of the relational data model?', 'b', 1),
    ('Which of the following correctly defines an attribute in the context of the relational data model?', 'c', 2),
    ('Which of the following best defines a domain in the context of the relational data model?', 'b', 3),
    ('Which of the following correctly defines a tuple in the context of the relational data model?', 'c', 4),
    ('Which of the following correctly distinguishes between intension and extension in a relational database?', 'b', 5),
    ('Which of the following correctly defines degree and cardinality in the context of a relation?', 'b', 6),
    ('Which of the following best describes the relationship between mathematical relations and relations in the relational data model?', 'b', 7),
    ('Which of the following best defines a normalised relation and explains why constraints are important in a relational database?', 'b', 8),
    ('Which of the following correctly describes the properties of a relation in the relational data model?', 'b', 9),
    ('Which of the following correctly distinguishes between candidate keys and a primary key, defines a foreign key, and explains how foreign keys relate to candidate keys?', 'c', 10),
    ('Which of the following correctly defines the two principal integrity rules of the relational model and explains why enforcing them is desirable?', 'b', 11),
    ('Which of the following best defines views and explains why they are important in the database approach?', 'c', 12)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 3 Quiz: The Relational Model';

-- ============================================================
-- CHAPTER 3 QUIZ OPTIONS
-- ============================================================

-- Q1
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A relation is a visual diagram that shows how two or more database tables are connected through foreign keys'),
    ('b', 'A relation is a two-dimensional table consisting of rows and columns, where each row represents a unique instance of an entity and each column represents an attribute of that entity'),
    ('c', 'A relation is a SQL query that joins two or more tables together to produce a combined result set'),
    ('d', 'A relation is a constraint that enforces referential integrity between two tables in a database')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 1;

-- Q2
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'An attribute is a row in a relation that represents a single, complete record or instance of the entity being modelled'),
    ('b', 'An attribute is a constraint that uniquely identifies each row within a relation'),
    ('c', 'An attribute is a named column in a relation that represents a specific property or characteristic of the entity being described'),
    ('d', 'An attribute is the total number of rows currently stored in a relation at any given point in time')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 2;

-- Q3
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A domain is the physical storage location on disk where a relation''s data is permanently saved'),
    ('b', 'A domain is the set of all logically possible and valid values that an attribute may hold, defining the type and range of data permissible for that attribute'),
    ('c', 'A domain is the collection of all relations that together make up a complete database schema'),
    ('d', 'A domain is the unique identifier assigned to each tuple in a relation to distinguish it from all other tuples')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 3;

-- Q4
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A tuple is a named column in a relation that holds a specific category of data for every record in the table'),
    ('b', 'A tuple is the complete set of attribute definitions that describe the structure of a relation'),
    ('c', 'A tuple is a single row in a relation, representing one complete instance or occurrence of the entity described by that relation'),
    ('d', 'A tuple is a mathematical function that maps each attribute of a relation to its corresponding domain')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 4;

-- Q5
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Intension refers to the actual data currently stored in a relation at a specific point in time; extension refers to the structural definition of the relation including its attribute names and constraints'),
    ('b', 'Intension refers to the structural definition or schema of a relation — its attribute names, domains, and constraints — which remains relatively stable over time; extension refers to the actual data values stored in the relation at a particular moment, which changes frequently as data is inserted, updated, or deleted'),
    ('c', 'Intension and extension are two alternative terms for the degree and cardinality of a relation respectively'),
    ('d', 'Intension refers to the foreign key constraints defined on a relation; extension refers to the primary key constraints that enforce uniqueness')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 5;

-- Q6
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Degree refers to the number of tuples currently stored in a relation; cardinality refers to the number of attributes defined in a relation'),
    ('b', 'Degree refers to the number of attributes (columns) defined in a relation; cardinality refers to the number of tuples (rows) currently present in that relation'),
    ('c', 'Degree refers to the complexity of the SQL query used to retrieve data from a relation; cardinality refers to the number of foreign keys defined within the relation'),
    ('d', 'Degree and cardinality are interchangeable terms that both describe the total size of a relation in terms of its stored data')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 6;

-- Q7
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The relational data model borrows the term relation from mathematics only as a naming convention; there is no deeper conceptual connection between the two'),
    ('b', 'In mathematics, a relation is a subset of the Cartesian product of two or more sets; similarly, a relation in the relational data model is a table whose rows represent a subset of all possible combinations of values drawn from the domains of its attributes, making the database relation a practical application of the mathematical concept'),
    ('c', 'Mathematical relations are ordered sequences of values, whereas database relations are unordered sets; this fundamental difference means the two concepts are incompatible'),
    ('d', 'Mathematical relations always involve exactly two sets, whereas database relations can have any number of attributes, making them entirely distinct from their mathematical counterpart')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 7;

-- Q8
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A normalised relation is one that has been physically optimised for fast disk access; constraints are important because they speed up query execution by limiting the number of rows the DBMS must examine'),
    ('b', 'A normalised relation is one in which each attribute contains only atomic, single-valued entries with no repeating groups, ensuring a clean and consistent table structure; constraints are important because they enforce rules that maintain the accuracy, consistency, and integrity of the data, preventing invalid or contradictory information from being stored in the database'),
    ('c', 'A normalised relation is one that contains no foreign keys; constraints are important because they prevent users from deleting records that are still referenced by other tables'),
    ('d', 'A normalised relation is one that has been backed up and verified for completeness; constraints are important because they restrict the number of users who can access the relation simultaneously')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 8;

-- Q9
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A relation may contain duplicate tuples; the order of both rows and columns is significant and must be preserved; and cell values may contain multiple values or nested structures'),
    ('b', 'Every tuple in a relation must be unique; the order of tuples and attributes is insignificant; each cell must contain exactly one atomic value; and each attribute must have a distinct name with values drawn from a single domain'),
    ('c', 'A relation must be ordered alphabetically by its primary key; duplicate attribute names are permitted provided they belong to different domains; and cell values may contain null or multiple values interchangeably'),
    ('d', 'A relation must contain at least one foreign key; attribute names may be duplicated within the same relation; and the order of columns is fixed and must match the order in which they were originally defined')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 9;

-- Q10
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'A candidate key is the single chosen key used to uniquely identify tuples; a primary key is any attribute that could theoretically serve as a unique identifier; a foreign key is an attribute with no null values'),
    ('b', 'Candidate keys are all attributes within a relation; the primary key is selected from among the foreign keys; a foreign key always references the degree of another relation'),
    ('c', 'A candidate key is any attribute or minimal set of attributes that can uniquely identify every tuple in a relation; a primary key is the specific candidate key chosen by the designer to serve as the official unique identifier; a foreign key is an attribute in one relation whose values correspond to the values of a candidate key in another relation, thereby establishing a link between the two'),
    ('d', 'Candidate keys and primary keys are identical; a foreign key is any attribute that contains null values and therefore cannot serve as a primary key in its own relation')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 10;

-- Q11
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The two rules are domain integrity, which ensures attribute values fall within their defined domain, and referential integrity, which ensures that foreign key values always correspond to existing primary key values'),
    ('b', 'The two rules are entity integrity, which states that no attribute of a primary key may hold a null value since every tuple must be uniquely and fully identifiable, and referential integrity, which states that a foreign key value must either match an existing primary key value in the referenced relation or be null; enforcing these rules is desirable because entity integrity guarantees that every record can be uniquely identified, while referential integrity ensures that relationships between tables remain consistent and that no record references a non-existent entity'),
    ('c', 'The two rules are uniqueness integrity, which states that all values in every column must be unique, and null integrity, which states that no attribute in any relation may hold a null value under any circumstances'),
    ('d', 'The two rules are structural integrity, which defines how tables must be physically organised on disk, and operational integrity, which governs how SQL statements may be written to access and update data')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 11;

-- Q12
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Views are physical copies of tables stored separately on disk to improve read performance; they are important because they reduce the workload on the primary storage device'),
    ('b', 'Views are permanent tables created by merging two or more existing tables into a single combined structure; they are important because they eliminate the need for joins in subsequent queries'),
    ('c', 'Views are virtual tables derived from one or more base tables through a stored query definition; they present a customised subset or combination of data to specific users without storing the data redundantly; they are important because they simplify complex queries, enforce security by restricting access to sensitive columns or rows, support data independence by shielding users from changes to the underlying schema, and allow different users to see the same data presented in different ways'),
    ('d', 'Views are graphical diagrams generated by the DBMS to help database administrators visualise the structure and relationships of the tables in a database')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 3 Quiz: The Relational Model')
  AND qq.order_index = 12;

-- ============================================================
-- CHAPTER 4 QUIZ QUESTIONS (6 questions)
-- ============================================================

INSERT INTO quiz_questions (unit_id, question_text, correct_option, order_index)
SELECT u.id, v.q, v.ans, v.ord
FROM units u
CROSS JOIN (VALUES
    ('Which of the following correctly describes the four basic SQL DML statements and their use?', 'b', 1),
    ('Which of the following best explains the importance and application of the WHERE clause in UPDATE and DELETE statements?', 'b', 2),
    ('Which of the following correctly explains the function of each clause in the SELECT statement and the restrictions imposed on them?', 'b', 3),
    ('Which of the following correctly describes the restrictions on aggregate functions in a SELECT statement and explains how nulls affect them?', 'b', 4),
    ('Which of the following correctly explains how results from two SQL queries can be combined, and differentiates between INTERSECT and EXCEPT?', 'b', 5),
    ('Which of the following correctly differentiates between the three types of subqueries and explains why understanding the nature of a subquery result is important before writing an SQL statement?', 'b', 6)
) AS v(q, ans, ord)
WHERE u.title = 'Chapter 4 Quiz: SQL Data Manipulation';

-- ============================================================
-- CHAPTER 4 QUIZ OPTIONS
-- ============================================================

-- Q1
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'CREATE, ALTER, DROP, and TRUNCATE — used to define and modify the structure of database objects'),
    ('b', 'SELECT, INSERT, UPDATE, and DELETE — used respectively to retrieve data from one or more tables, add new rows to a table, modify existing rows in a table, and remove rows from a table'),
    ('c', 'GRANT, REVOKE, COMMIT, and ROLLBACK — used to manage user permissions and control transaction boundaries'),
    ('d', 'JOIN, UNION, INTERSECT, and EXCEPT — used to combine the results of multiple queries into a single result set')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: SQL Data Manipulation')
  AND qq.order_index = 1;

-- Q2
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The WHERE clause in UPDATE and DELETE statements is optional and only improves performance by reducing the number of rows the DBMS must scan'),
    ('b', 'The WHERE clause specifies which rows should be affected by the UPDATE or DELETE operation; without it, the statement applies to every row in the table, which can lead to unintended and potentially catastrophic loss or corruption of data; it is therefore critically important to always include a precise WHERE clause to target only the intended rows'),
    ('c', 'The WHERE clause in UPDATE statements defines the new values to be assigned to the specified columns, while in DELETE statements it identifies the table from which rows should be removed'),
    ('d', 'The WHERE clause is required only in DELETE statements; in UPDATE statements it is ignored by the DBMS and has no effect on which rows are modified')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: SQL Data Manipulation')
  AND qq.order_index = 2;

-- Q3
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'SELECT specifies the table to query; FROM filters the rows; WHERE names the columns to retrieve; GROUP BY sorts the results; HAVING limits the number of rows returned; ORDER BY groups rows by a common value'),
    ('b', 'SELECT identifies the columns to be retrieved; FROM specifies the table or tables from which data is drawn; WHERE filters individual rows based on a condition before grouping; GROUP BY organises rows sharing a common value into summary groups; HAVING filters those groups based on a condition applied to aggregate values; ORDER BY sorts the final result set; restrictions include that WHERE cannot reference aggregate functions, HAVING can only be used with GROUP BY, and columns in SELECT that are not aggregated must appear in the GROUP BY clause'),
    ('c', 'SELECT and FROM are the only mandatory clauses; all other clauses are entirely interchangeable and may appear in any order without affecting the result; no restrictions apply to the use of aggregate functions in any clause'),
    ('d', 'WHERE and HAVING perform identical filtering functions and may be used interchangeably; GROUP BY is only permitted when ORDER BY is also present; SELECT may reference columns from tables not listed in the FROM clause')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: SQL Data Manipulation')
  AND qq.order_index = 3;

-- Q4
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Aggregate functions may appear anywhere in a SELECT statement without restriction; null values are treated as zero by all aggregate functions, so they do not affect the result'),
    ('b', 'Aggregate functions such as COUNT, SUM, AVG, MIN, and MAX cannot be used in the WHERE clause; when aggregate functions are used in the SELECT clause alongside non-aggregated columns, those columns must appear in the GROUP BY clause; with the exception of COUNT(*), all aggregate functions ignore null values in their calculations, which means nulls do not contribute to sums or averages and may cause AVG to produce results that differ from what would be expected if nulls were treated as zero'),
    ('c', 'Aggregate functions may be freely used in the WHERE clause but are prohibited from appearing in the HAVING clause; null values cause aggregate functions to return null for the entire column'),
    ('d', 'Aggregate functions can only be applied to columns of numeric data type; they treat null values identically to zero and always include them in their calculations regardless of the function used')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: SQL Data Manipulation')
  AND qq.order_index = 4;

-- Q5
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'Results from two queries can be combined using JOIN; INTERSECT returns all rows from both queries including duplicates, while EXCEPT returns only the rows that appear in the first query but not in the second'),
    ('b', 'Results from two SQL queries can be combined using set operators such as UNION, INTERSECT, and EXCEPT, provided both queries return the same number of columns with compatible data types; UNION returns all distinct rows from either query; INTERSECT returns only the rows that appear in the results of both queries; EXCEPT returns only the rows that appear in the first query but not in the second query, effectively subtracting the second result set from the first'),
    ('c', 'Results from two queries can only be combined using subqueries; INTERSECT and EXCEPT are not standard SQL commands and are only available in specific proprietary database systems'),
    ('d', 'INTERSECT combines all rows from both queries and removes duplicates, behaving identically to UNION; EXCEPT combines both result sets and retains only the duplicate rows, behaving identically to INTERSECT')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: SQL Data Manipulation')
  AND qq.order_index = 5;

-- Q6
INSERT INTO quiz_options (question_id, option_letter, option_text)
SELECT qq.id, o.letter, o.text
FROM quiz_questions qq
CROSS JOIN (VALUES
    ('a', 'The three types of subquery are inner, outer, and cross subqueries; they differ only in their position within the SQL statement and have no effect on the logic or syntax required in the enclosing query'),
    ('b', 'The three types of subquery are scalar subqueries (return a single value, used with = or <), row subqueries (return a single row with multiple columns), and table subqueries (return multiple rows and columns, used with IN, EXISTS, ANY, or ALL); understanding the nature of the result is critical because using the wrong comparison operator for the type of result produced will cause a runtime error or logically incorrect results'),
    ('c', 'The three types of subquery are correlated, uncorrelated, and nested subqueries; correlated subqueries always return a single value, uncorrelated subqueries always return a table, and nested subqueries always return a single row; the type of result has no bearing on which comparison operators may be used'),
    ('d', 'The three types of subquery are SELECT subqueries, FROM subqueries, and WHERE subqueries; all three types always return a single scalar value regardless of how they are written, so the choice of comparison operator is always the same')
) AS o(letter, text)
WHERE qq.unit_id = (SELECT id FROM units WHERE title = 'Chapter 4 Quiz: SQL Data Manipulation')
  AND qq.order_index = 6;
