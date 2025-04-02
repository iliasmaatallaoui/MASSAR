-- Create students table
CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    massar_id TEXT NOT NULL UNIQUE,
    enrollment_date NUMERIC DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Create subjects table
CREATE TABLE IF NOT EXISTS subjects (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    code TEXT NOT NULL UNIQUE,
    coefficient NUMERIC NOT NULL
);

-- Create scores table
CREATE TABLE IF NOT EXISTS scores (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    score_value NUMERIC NOT NULL CHECK(score_value >= 0 AND score_value <= 20),
    semester INTEGER NOT NULL CHECK(semester IN (1, 2)),
    assessment_type TEXT NOT NULL,
    date_recorded NUMERIC DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY(subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Create absences table
CREATE TABLE IF NOT EXISTS absences (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject_id INTEGER NOT NULL,
    date NUMERIC NOT NULL,
    type TEXT NOT NULL CHECK(type IN ('Justified', 'Unjustified')),
    reason TEXT,
    timestamp NUMERIC DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY(subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Create indexes for optimization
CREATE INDEX idx_students_massar_id ON students(massar_id);
CREATE INDEX idx_students_last_name ON students(last_name);
CREATE INDEX idx_scores_lookup ON scores(student_id, subject_id);
CREATE INDEX idx_subjects_code ON subjects(code);