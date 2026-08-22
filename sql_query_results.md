# SQL Query Results (run against student_performance.db)

## 8.2.1 Overall summary statistics

```sql
SELECT
            MIN(Overall_Percentage) AS Min_Percentage,
            MAX(Overall_Percentage) AS Max_Percentage,
            ROUND(AVG(Overall_Percentage),2) AS Avg_Percentage,
            ROUND(AVG(Attendance_Percentage),2) AS Avg_Attendance,
            ROUND(AVG(Study_Hours_per_Day),2) AS Avg_Study_Hours
        FROM students;
```

|   Min_Percentage |   Max_Percentage |   Avg_Percentage |   Avg_Attendance |   Avg_Study_Hours |
|-----------------:|-----------------:|-----------------:|-----------------:|------------------:|
|              3.3 |             89.4 |            42.31 |            71.89 |              3.19 |

## 8.2.2 Attendance-band vs performance

```sql
SELECT
            CASE WHEN Attendance_Percentage < 75 THEN 'Below 75%' ELSE '75% and Above' END AS Attendance_Band,
            ROUND(AVG(Overall_Percentage),2) AS Avg_Percentage,
            COUNT(*) AS Num_Students
        FROM students
        GROUP BY Attendance_Band;
```

| Attendance_Band   |   Avg_Percentage |   Num_Students |
|:------------------|-----------------:|---------------:|
| 75% and Above     |             54.6 |            185 |
| Below 75%         |             34.6 |            295 |

## 8.2.3 Study-hour band vs performance

```sql
SELECT
            CASE
                WHEN Study_Hours_per_Day < 2 THEN '<2 hrs'
                WHEN Study_Hours_per_Day < 4 THEN '2-4 hrs'
                WHEN Study_Hours_per_Day < 6 THEN '4-6 hrs'
                ELSE '6+ hrs'
            END AS Study_Band,
            ROUND(AVG(Overall_Percentage),2) AS Avg_Percentage,
            COUNT(*) AS Num_Students
        FROM students
        GROUP BY Study_Band
        ORDER BY Avg_Percentage;
```

| Study_Band   |   Avg_Percentage |   Num_Students |
|:-------------|-----------------:|---------------:|
| <2 hrs       |            26.95 |            110 |
| 2-4 hrs      |            41.19 |            223 |
| 4-6 hrs      |            53.94 |            125 |
| 6+ hrs       |            64.36 |             22 |

## 8.3.1 Department-wise average performance

```sql
SELECT Department,
            ROUND(AVG(Overall_Percentage),2) AS Avg_Percentage,
            ROUND(AVG(Attendance_Percentage),2) AS Avg_Attendance,
            COUNT(*) AS Num_Students
        FROM students
        GROUP BY Department
        ORDER BY Avg_Percentage DESC;
```

| Department   |   Avg_Percentage |   Avg_Attendance |   Num_Students |
|:-------------|-----------------:|-----------------:|---------------:|
| ISE          |            45.23 |            73.26 |             91 |
| ECE          |            44.08 |            71.81 |             84 |
| CIVIL        |            41.54 |            71.01 |             49 |
| CSE          |            41.15 |            71.64 |            155 |
| AIML         |            40.36 |            71.51 |            101 |

## 8.3.2 Semester-wise average performance

```sql
SELECT Semester,
            ROUND(AVG(Overall_Percentage),2) AS Avg_Percentage,
            COUNT(*) AS Num_Students
        FROM students
        GROUP BY Semester
        ORDER BY Semester;
```

|   Semester |   Avg_Percentage |   Num_Students |
|-----------:|-----------------:|---------------:|
|          3 |            43.5  |            117 |
|          4 |            42.45 |            123 |
|          5 |            42.01 |            115 |
|          6 |            41.34 |            125 |

## 8.3.3 Grade distribution

```sql
SELECT Grade, COUNT(*) AS Num_Students,
            ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM students),2) AS Percentage
        FROM students
        GROUP BY Grade
        ORDER BY Num_Students DESC;
```

| Grade   |   Num_Students |   Percentage |
|:--------|---------------:|-------------:|
| F       |            219 |        45.63 |
| C       |            103 |        21.46 |
| B       |             82 |        17.08 |
| B+      |             44 |         9.17 |
| A       |             22 |         4.58 |
| A+      |             10 |         2.08 |

## 8.3.4 Overall pass/fail percentage

```sql
SELECT Pass_Fail, COUNT(*) AS Num_Students,
            ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM students),2) AS Percentage
        FROM students
        GROUP BY Pass_Fail;
```

| Pass_Fail   |   Num_Students |   Percentage |
|:------------|---------------:|-------------:|
| Fail        |            219 |        45.63 |
| Pass        |            261 |        54.38 |

## 8.3.5 Department-wise pass percentage

```sql
SELECT Department,
            ROUND(100.0*SUM(CASE WHEN Pass_Fail='Pass' THEN 1 ELSE 0 END)/COUNT(*),2) AS Pass_Percentage,
            COUNT(*) AS Num_Students
        FROM students
        GROUP BY Department
        ORDER BY Pass_Percentage DESC;
```

| Department   |   Pass_Percentage |   Num_Students |
|:-------------|------------------:|---------------:|
| ISE          |             63.74 |             91 |
| ECE          |             57.14 |             84 |
| CIVIL        |             57.14 |             49 |
| CSE          |             52.9  |            155 |
| AIML         |             44.55 |            101 |

## 8.4.1 Top 10 performing students

```sql
SELECT Student_ID, Department, Overall_Percentage, Grade
        FROM students
        ORDER BY Overall_Percentage DESC
        LIMIT 10;
```

| Student_ID   | Department   |   Overall_Percentage | Grade   |
|:-------------|:-------------|---------------------:|:--------|
| STU1381      | CIVIL        |                 89.4 | A+      |
| STU1369      | CSE          |                 88.9 | A+      |
| STU1345      | AIML         |                 88.8 | A+      |
| STU1161      | ECE          |                 87.7 | A+      |
| STU1284      | AIML         |                 86.9 | A+      |
| STU1433      | ECE          |                 86.9 | A+      |
| STU1053      | ISE          |                 85.4 | A+      |
| STU1388      | ECE          |                 82.3 | A+      |
| STU1107      | ISE          |                 81.5 | A+      |
| STU1061      | ECE          |                 81.5 | A+      |

## 8.4.2 At-risk students (Overall % below 45)

```sql
SELECT Student_ID, Department, Attendance_Percentage, Overall_Percentage, Grade
        FROM students
        WHERE Overall_Percentage < 45
        ORDER BY Overall_Percentage ASC
        LIMIT 10;
```

| Student_ID   | Department   |   Attendance_Percentage |   Overall_Percentage | Grade   |
|:-------------|:-------------|------------------------:|---------------------:|:--------|
| STU1431      | AIML         |                    39.4 |                  3.3 | F       |
| STU1454      | ECE          |                    44.3 |                  3.3 | F       |
| STU1238      | CSE          |                    42.9 |                  3.3 | F       |
| STU1275      | CSE          |                    64.3 |                  3.6 | F       |
| STU1423      | ECE          |                    51.5 |                  5.7 | F       |
| STU1002      | CSE          |                    68.9 |                  5.9 | F       |
| STU1197      | CIVIL        |                    61.1 |                  6.2 | F       |
| STU1017      | AIML         |                    58.4 |                  6.5 | F       |
| STU1449      | CSE          |                    62.2 |                  6.5 | F       |
| STU1144      | ISE          |                    49.1 |                  7.3 | F       |

