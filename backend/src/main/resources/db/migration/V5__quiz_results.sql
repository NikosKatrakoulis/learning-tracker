CREATE SEQUENCE quiz_results_id_seq AS BIGINT;

CREATE TABLE quiz_results (
    id           BIGINT       PRIMARY KEY DEFAULT nextval('quiz_results_id_seq'),
    user_id      BIGINT       NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    unit_id      BIGINT       NOT NULL REFERENCES units(id) ON DELETE CASCADE,
    score        INT          NOT NULL,
    total        INT          NOT NULL,
    percentage   INT          NOT NULL,
    grade        VARCHAR(20)  NOT NULL,
    attempted_at TIMESTAMP    NOT NULL DEFAULT NOW()
);

ALTER SEQUENCE quiz_results_id_seq OWNED BY quiz_results.id;
