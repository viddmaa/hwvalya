CREATE SCHEMA IF NOT EXISTS university;

CREATE TABLE IF NOT EXISTS university.students (
    student_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    admission_date DATE DEFAULT CURRENT_DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS university.courses (
    course.id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    credits INTEGER DEFAULT 3 NOT NULL
);

INSERT INTO university.students (name)
VALUES ('Valya Kholod')
ON CONFLICT DO NOTHING;

INSERT INTO university.courses (title)
VALUES ('WEB')
ON CONFLICT DO NOTHING;

SELECT * FROM university.students;
SELECT * FROM university.courses;