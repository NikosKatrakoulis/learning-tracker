CREATE SEQUENCE course_feedback_id_seq AS BIGINT;

CREATE TABLE course_feedback (
    id         BIGINT  PRIMARY KEY DEFAULT nextval('course_feedback_id_seq'),
    user_id    BIGINT  NOT NULL REFERENCES users(id)   ON DELETE CASCADE,
    course_id  BIGINT  NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    rating     INT     NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    UNIQUE (user_id, course_id)
);

ALTER SEQUENCE course_feedback_id_seq OWNED BY course_feedback.id;
