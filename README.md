
# MASSAR’s Database – CS50 Final Project  

## 📌 Overview  
This project is my **final submission for CS50’s Introduction to Databases with SQL**. Inspired by **MASSAR**, the official government education platform, this database system is designed to **track and manage student academic performance** efficiently.  

## 🎯 Features  
✅ **Student Information Management** – Store and update student records  
✅ **Subject Tracking** – Manage subject details and coefficients  
✅ **Score Recording** – Record and retrieve student scores across semesters  
✅ **Attendance Management** – Log and track student absences  
✅ **Performance Analysis** – Generate reports, calculate averages, and detect students with low grades  

## 🏗️ Database Schema  
The database consists of the following tables:  
- **students** – Stores student details, including a unique MASSAR ID  
- **subjects** – Contains subject names, codes, and coefficients  
- **scores** – Records student scores, assessment types, and semesters  
- **absences** – Logs attendance records with justification details  

### ⚙️ Relationships  
- A **student** can have multiple **scores** and **absences**  
- A **subject** is linked to multiple **scores** and **absences**  
- Foreign key constraints ensure data integrity  

## 🛠️ Installation & Usage  
### 🔹 Prerequisites  
Ensure you have **SQLite** installed on your system.  

### 🔹 Setup  
1. Clone this repository:  
   ```bash
   git clone https://github.com/yourusername/massar-database.git
   cd massar-database
   ```
2. Initialize the database using the provided schema:  
   ```bash
   sqlite3 massar.db < schema.sql
   ```
3. Run queries using SQLite shell:  
   ```bash
   sqlite3 massar.db
   ```

## 📊 Sample Queries  
**1. Get a student’s academic record:**  
```sql
SELECT students.first_name, students.last_name, subjects.name AS subject, 
       scores.score_value, scores.semester, scores.assessment_type
FROM students
JOIN scores ON students.id = scores.student_id
JOIN subjects ON subjects.id = scores.subject_id
WHERE students.massar_id = ?;
```

**2. Calculate a student’s semester average by subject:**  
```sql
SELECT subjects.name, semester, ROUND(AVG(score_value), 2) as average
FROM scores
JOIN subjects ON subjects.id = scores.subject_id
WHERE student_id = ? AND semester = ?
GROUP BY subjects.id, semester;
```

**3. Identify students with low performance (score < 10):**  
```sql
SELECT DISTINCT st.massar_id, st.first_name, st.last_name, sub.name AS subject, sc.score_value
FROM students st
JOIN scores sc ON st.id = sc.student_id
JOIN subjects sub ON sub.id = sc.subject_id
WHERE sc.score_value < 10;
```

## 🚀 Future Enhancements  
🔹 Implement score modification history tracking  
🔹 Support for weighted assessments within subjects  
🔹 Add custom grading scale support (beyond 0-20)  

## 📜 License  
This project is open-source and available under the **MIT License**.  

👤 **Ilias Maatallaoui** 
🔗 GitHub: [[GitHub profile](https://github.com/iliasmaatallaoui/)]  
