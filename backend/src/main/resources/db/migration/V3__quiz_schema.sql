ALTER TABLE units ADD COLUMN unit_type VARCHAR(10) NOT NULL DEFAULT 'lesson';
ALTER TABLE units ADD COLUMN pdf_path VARCHAR(255);

CREATE SEQUENCE quiz_questions_id_seq AS BIGINT;
CREATE SEQUENCE quiz_options_id_seq AS BIGINT;

CREATE TABLE quiz_questions
(
    id             BIGINT PRIMARY KEY DEFAULT nextval('quiz_questions_id_seq'),
    unit_id        BIGINT       NOT NULL REFERENCES units (id),
    question_text  TEXT         NOT NULL,
    correct_option VARCHAR(1)   NOT NULL,
    order_index    INT          NOT NULL
);

CREATE TABLE quiz_options
(
    id            BIGINT PRIMARY KEY DEFAULT nextval('quiz_options_id_seq'),
    question_id   BIGINT       NOT NULL REFERENCES quiz_questions (id),
    option_letter VARCHAR(1)   NOT NULL,
    option_text   TEXT         NOT NULL
);

ALTER SEQUENCE quiz_questions_id_seq OWNED BY quiz_questions.id;
ALTER SEQUENCE quiz_options_id_seq OWNED BY quiz_options.id;
