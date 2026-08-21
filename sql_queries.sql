-- Average Marks

SELECT AVG(Final_Marks)
FROM students;

-- Top Performing Students

SELECT *
FROM students
ORDER BY Final_Marks DESC;

-- Students with Low Attendance

SELECT *
FROM students
WHERE Attendance < 75;

-- Grade Distribution

SELECT Grade, COUNT(*)
FROM students
GROUP BY Grade;
