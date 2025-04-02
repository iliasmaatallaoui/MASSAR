-- Get a student's complete academic record
SELECT 
    students.first_name,
    students.last_name,
    subjects.name AS subject,
    scores.score_value,
    scores.semester,
    scores.assessment_type
FROM students
JOIN scores ON students.id = scores.student_id
JOIN subjects ON subjects.id = scores.subject_id
WHERE students.massar_id = ?
ORDER BY subjects.name, scores.semester, scores.date_recorded;

-- Calculate student's semester average by subject
SELECT 
    subjects.name,
    semester,
    ROUND(AVG(score_value), 2) as average
FROM scores
JOIN subjects ON subjects.id = scores.subject_id
WHERE student_id = ? AND semester = ?
GROUP BY subjects.id, semester;

-- Get student's attendance record for a specific subject
SELECT 
    date,
    type,
    reason
FROM absences
WHERE student_id = ? AND subject_id = ?
ORDER BY date DESC;

-- Calculate absence rate per subject
SELECT 
    s.name AS subject,
    COUNT(*) as total_absences,
    SUM(CASE WHEN a.type = 'Justified' THEN 1 ELSE 0 END) as justified,
    SUM(CASE WHEN a.type = 'Unjustified' THEN 1 ELSE 0 END) as unjustified
FROM absences a
JOIN subjects s ON s.id = a.subject_id
WHERE student_id = ?
GROUP BY subject_id;

-- Get students with low performance (score < 10) in any subject
SELECT DISTINCT
    st.massar_id,
    st.first_name,
    st.last_name,
    sub.name AS subject,
    sc.score_value
FROM students st
JOIN scores sc ON st.id = sc.student_id
JOIN subjects sub ON sub.id = sc.subject_id
WHERE sc.score_value < 10
ORDER BY st.last_name, sub.name;

-- Calculate overall semester average considering subject coefficients
SELECT 
    st.massar_id,
    st.first_name,
    st.last_name,
    sc.semester,
    ROUND(SUM(sc.score_value * sub.coefficient) / SUM(sub.coefficient), 2) as weighted_average
FROM students st
JOIN scores sc ON st.id = sc.student_id
JOIN subjects sub ON sub.id = sc.subject_id
WHERE sc.semester = ?
GROUP BY st.id, sc.semester
ORDER BY weighted_average DESC;

-- Find students with excessive absences (more than 3 unjustified)
SELECT 
    st.massar_id,
    st.first_name,
    st.last_name,
    sub.name AS subject,
    COUNT(*) as absence_count
FROM students st
JOIN absences a ON st.id = a.student_id
JOIN subjects sub ON sub.id = a.subject_id
WHERE a.type = 'Unjustified'
GROUP BY st.id, sub.id
HAVING absence_count > 3
ORDER BY absence_count DESC;

--Update a Student’s Score Value
UPDATE scores
SET score_value = ?
WHERE student_id = ? AND subject_id = ? AND semester = ? AND assessment_type = ?;


--Delete a Student’s Record
DELETE FROM students
WHERE id = ?;

-- Insert sample subjects
INSERT INTO subjects (name, code, coefficient) VALUES
('Mathematics', 'MATH101', 7),
('Physics', 'PHY101', 6),
('French', 'FRN101', 4),
('Arabic', 'ARB101', 4),
('History-Geography', 'HGE101', 2),
('Islamic Education', 'ISL101', 2);

-- Insert sample students
INSERT INTO students (first_name, last_name, massar_id) VALUES
('Mohammed', 'El Alami', 'S138567892'),
('Fatima', 'Benani', 'S138567893'),
('Yousef', 'Cherkaoui', 'S138567894'),
('Amina', 'Doukkali', 'S138567895');

-- Insert sample scores for semester 1
INSERT INTO scores (student_id, subject_id, score_value, semester, assessment_type) VALUES
(1, 1, 15.5, 1, 'Exam'),
(1, 2, 14.0, 1, 'Exam'),
(1, 3, 12.5, 1, 'Exam'),
(2, 1, 17.0, 1, 'Exam'),
(2, 2, 16.5, 1, 'Exam'),
(2, 3, 18.0, 1, 'Exam'),
(3, 1, 13.0, 1, 'Exam'),
(3, 2, 11.5, 1, 'Exam'),
(4, 1, 16.0, 1, 'Exam'),
(4, 2, 15.5, 1, 'Exam');

-- Insert continuous assessment scores
INSERT INTO scores (student_id, subject_id, score_value, semester, assessment_type) VALUES
(1, 1, 14.0, 1, 'Continuous Assessment'),
(1, 2, 13.5, 1, 'Continuous Assessment'),
(2, 1, 16.0, 1, 'Continuous Assessment'),
(2, 2, 15.5, 1, 'Continuous Assessment');

-- Insert sample absences
INSERT INTO absences (student_id, subject_id, date, type, reason) VALUES
(1, 1, '2025-02-15', 'Justified', 'Medical appointment'),
(2, 3, '2025-02-16', 'Unjustified', NULL),
(3, 2, '2025-02-15', 'Justified', 'Family emergency'),
(4, 1, '2025-02-17', 'Unjustified', NULL),
(1, 2, '2025-02-18', 'Justified', 'Medical appointment');