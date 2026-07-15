CREATE SEQUENCE users_id_seq AS BIGINT;
CREATE SEQUENCE courses_id_seq AS BIGINT;
CREATE SEQUENCE units_id_seq AS BIGINT;
CREATE SEQUENCE user_unit_progress_id_seq AS BIGINT;
CREATE SEQUENCE user_courses_id_seq AS BIGINT;

CREATE TABLE users
(
    id        BIGINT PRIMARY KEY DEFAULT nextval('users_id_seq'),
    username  VARCHAR(50)  NOT NULL UNIQUE,
    password  VARCHAR(100) NOT NULL,
    role      VARCHAR(20)  NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

CREATE TABLE courses
(
    id          BIGINT PRIMARY KEY DEFAULT nextval('courses_id_seq'),
    title       VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE units
(
    id          BIGINT PRIMARY KEY DEFAULT nextval('units_id_seq'),
    course_id   BIGINT       NOT NULL REFERENCES courses (id),
    title       VARCHAR(100) NOT NULL,
    content     TEXT,
    order_index INT          NOT NULL,
    section     VARCHAR(100)
);

CREATE TABLE user_unit_progress
(
    id              BIGINT PRIMARY KEY DEFAULT nextval('user_unit_progress_id_seq'),
    user_id         BIGINT NOT NULL REFERENCES users (id),
    unit_id         BIGINT NOT NULL REFERENCES units (id),
    completed       BOOLEAN            DEFAULT FALSE,
    completion_date TIMESTAMP,
    UNIQUE (user_id, unit_id)
);

CREATE TABLE user_courses
(
    id            BIGINT PRIMARY KEY DEFAULT nextval('user_courses_id_seq'),
    user_id       BIGINT NOT NULL REFERENCES users (id),
    course_id     BIGINT NOT NULL REFERENCES courses (id),
    assigned_date TIMESTAMP          DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, course_id)
);

ALTER SEQUENCE users_id_seq OWNED BY users.id;
ALTER SEQUENCE courses_id_seq OWNED BY courses.id;
ALTER SEQUENCE units_id_seq OWNED BY units.id;
ALTER SEQUENCE user_unit_progress_id_seq OWNED BY user_unit_progress.id;
ALTER SEQUENCE user_courses_id_seq OWNED BY user_courses.id;