USE Digilians;
GO

-- ===================================================================================
-- DIGILIANS COMPREHENSIVE PRACTICE GRID (SIMPLE / INTERMEDIATE / ADVANCED)
-- ===================================================================================

-- ===================================================================================
-- TOPIC 1: SELECT, SELECT TOP, PERCENT, WITH TIES, DISTINCT
-- ===================================================================================

-- [Simple]
-- Q1: Write a query to fetch the EnglishName, Email, and Phone columns for all active trainees.
-- Write your code below:
SELECT 
	EnglishName, Email, Phone
FROM Trainees
WHERE IsActive = 1


-- [Intermediate]
-- Q2: Return a unique list of universities combined with their faculties (no duplicate pairs).
-- Write your code below:
SELECT DISTINCT 
	University, Faculty
FROM Trainees

-- [Advanced]
-- Q3: Retrieve the top 5 percent of trainees based on FinalExam scores. Use WITH TIES 
--     so that if multiple students tie for the lowest qualifying score, they are all included.
-- Write your code below:
SELECT TOP 5 PERCENT
	t.EnglishName,
	g.FinalExam
FROM Grades g
INNER JOIN Enrollments e
ON g.EnrollmentID = e.EnrollmentID
INNER JOIN Trainees t
ON t.TraineeID = e.TraineeID
ORDER BY g.FinalExam DESC

-- ===================================================================================
-- TOPIC 2: ORDER BY (ASC, DESC) & MULTI-LEVEL SORTING
-- ===================================================================================

-- [Simple]
-- Q4: List all courses ordered by their DurationHours from the shortest course to the longest.
-- Write your code below:
SELECT 
	CourseID,
	CourseName,
	DurationHours
FROM Courses
ORDER BY DurationHours ASC

-- [Intermediate]
-- Q5: List all trainees sorted by their AcademicYear in descending order, and then 
--     alphabetically by their EnglishName within each academic year.
-- Write your code below:
SELECT 
	AcademicYear, EnglishName
FROM Trainees
ORDER BY AcademicYear DESC, EnglishName ASC

-- [Advanced]
-- Q6: Write a query that sorts the Grades table so that trainees with missing (NULL) FinalExam 
--     scores appear at the very bottom, while the rest are sorted from highest to lowest score.
-- Write your code below:
SELECT *
FROM Grades
ORDER BY FinalExam ASC

-- ===================================================================================
-- TOPIC 3: WHERE FILTERS (LIKE, BETWEEN, IN, AND/OR, MATH OPERATORS, NULLS)
-- ===================================================================================

-- [Simple]
-- Q7: Find all trainees who are in their 3rd or 4th academic year and whose gender is 'M'.
-- Write your code below:
SELECT *
FROM Trainees
WHERE AcademicYear in (3, 4) and Gender = 'M'

-- [Intermediate]
-- Q8: Find all trainees whose EnglishName contains the sequence 'ahmed' anywhere in their name, 
--     AND their University is NOT recorded (is NULL).
-- Write your code below:
SELECT * 
FROM Trainees
WHERE EnglishName LIKE '%ahmed%' and University is NULL

-- [Advanced]
-- Q9: Select all grade rows where the combined score of (Assignment + Project) is greater than 
--     30, AND the MidExam score is strictly between 12 and 18. Ensure NULL values don't break the math.
-- Write your code below:
SELECT *
FROM Grades
WHERE (Assignment + Project > 30) and (MidExam BETWEEN 12 AND 18)


-- ===================================================================================
-- TOPIC 4: JOINS (INNER, LEFT, RIGHT, FULL OUTER, AND ANTI-JOINS)
-- ===================================================================================

-- [Simple]
-- Q10: Write an INNER JOIN to show each Course Offering's ID alongside its related Course Name 
--      and the Instructor's Name.
-- Write your code below:
SELECT 
	co.OfferingID, 
	c.CourseName,
	i.InstructorName
FROM CourseOfferings co
INNER JOIN Courses c
ON co.CourseID = c.CourseID
INNER JOIN Instructors i
ON co.InstructorID = i.InstructorID

-- [Intermediate]
-- Q11 (Left Anti-Join): Write a query to find all Trainees who have registered in the database 
--      but have NEVER enrolled in any course offering (no entry in the Enrollments table).
-- Write your code below:
SELECT
	t.TraineeID,
	t.EnglishName
FROM Trainees t
LEFT JOIN Enrollments e
ON t.TraineeID = e.TraineeID
WHERE e.TraineeID IS NULL

-- [Advanced]
-- Q12 (Full Complex Join): Write a FULL OUTER JOIN between Labs and Trainees. Display the LabCode 
--      and Trainee EnglishName. Filter the result to show only labs that have NO trainees assigned 
--      OR trainees who are somehow assigned to a non-existent LabID.
-- Write your code below:
SELECT 
    l.LabCode,
    t.EnglishName
FROM Trainees t
FULL OUTER JOIN Labs l
    ON t.LabID = l.LabID
WHERE t.TraineeID IS NULL
   OR l.LabID IS NULL;

-- ===================================================================================
-- TOPIC 5: AGGREGATIONS & GROUP BY & HAVING
-- ===================================================================================

-- [Simple]
-- Q13: Find the total number of sessions conducted across all course offerings, and find 
--      the earliest and latest session dates recorded.
-- Write your code below:

SELECT 
    COUNT(SessionID) AS Total_Sessions,
    MIN(SessionDate) AS Earliest_Session_Date,
    MAX(SessionDate) AS Latest_Session_Date
FROM Sessions;

-- [Intermediate]
-- Q14: Group the trainees by University and Gender. Display University, Gender, and the 
--      count of students. Exclude entries where the university name is NULL.
-- Write your code below:
SELECT 
	University,
	Gender,
	COUNT(TraineeID) as count_of_students
FROM Trainees
WHERE University is not null
GROUP BY University, Gender
ORDER BY University, Gender

-- [Advanced]
-- Q15: Calculate the average FinalExam mark for each Course Offering ID. Display only those 
--      Offerings where the average final exam score is greater than 30, and where there are 
--      at least 3 students tracked in that offering.
-- Write your code below:
SELECT
	co.OfferingID,
	AVG(g.FinalExam) as avg_final_exam
FROM Grades g
INNER JOIN Enrollments e
ON g.EnrollmentID = e.EnrollmentID
INNER JOIN CourseOfferings co
ON e.OfferingID = co.OfferingID
GROUP BY co.OfferingID
HAVING AVG(g.FinalExam) > 30 and COUNT(e.TraineeID) >= 3

-- ===================================================================================
-- TOPIC 6: SUBQUERIES (IN, NOT IN, MATH OPERATORS)
-- ===================================================================================

-- [Simple]
-- Q16: Using a subquery with IN, list all trainees who are assigned to labs located in 'A Building'.
-- Write your code below:
SELECT 
	EnglishName, LabID
FROM Trainees 
WHERE LabID IN (
				SELECT LabID FROM Labs WHERE Building LIKE '%A Building%' and LabID IS NOT NULL
				)

-- [Intermediate]
-- Q17: Write a query to display all trainees whose total grade score is higher than the overall 
--      average total score of the entire training center.
-- Write your code below:
SELECT 
	t.EnglishName,
	g.Total
FROM Trainees t
INNER JOIN Enrollments e
ON t.TraineeID = e.TraineeID
INNER JOIN Grades g
ON e.EnrollmentID = g.EnrollmentID
WHERE g.Total > (
					SELECT AVG(Total) from Grades
				)

-- [Advanced]
-- Q18 (Subquery Trap with NULLs): Find all trainees who have NOT recorded any attendance records yet. 
--      Use a NOT IN subquery safely, keeping in mind how NOT IN handles NULL values in SQL Server.
-- Write your code below:
SELECT
	TraineeID,
	EnglishName
FROM Trainees
WHERE TraineeID NOT IN (
						SELECT TraineeID FROM Attendance WHERE TraineeID IS NOT NULL
						)

-- ===================================================================================
-- TOPIC 7: VIEWS & COMMON TABLE EXPRESSIONS (CTEs)
-- ===================================================================================

-- [Simple]
-- Q19: Create a View named v_ActiveInstructors that exposes the names, emails, and 
--      specializations of instructors who are currently assigned to teach at least one course.
-- Write your code below:
CREATE VIEW v_ActiveInstructors AS 
SELECT DISTINCT 
	i.InstructorName,
	i.Email,
	i.Specialization,
	co.StartDate
FROM Instructors i
INNER JOIN CourseOfferings co
ON i.InstructorID = co.InstructorID

-- [Intermediate]
-- Q20: Write a query using a single CTE named TraineeAttendanceSummary that calculates the total 
--      number of 'Present', 'Absent', and 'Late' marks for every TraineeID. Select from the CTE.
-- Write your code below:
WITH TraineeAttendanceSummary AS (
SELECT 
	TraineeID,
	SUM(CASE WHEN Status = 'Present' THEN 1 ELSE 0 END) as Total_Present,
	SUM(CASE WHEN Status = 'Absent' THEN 1 ELSE 0 END) as Total_Absent,
	SUM(CASE WHEN Status = 'Late' THEN 1 ELSE 0 END) as Total_Late
FROM Attendance
GROUP BY TraineeID
)
SELECT
	t.TraineeID,
	t.EnglishName,
	a.Total_Present,
	a.Total_Late,
	a.Total_Absent
FROM TraineeAttendanceSummary a
INNER JOIN Trainees t 
ON a.TraineeID = t.TraineeID

-- [Advanced]
-- Q21 (Recursive/Multiple CTEs): Write a query using two separate, sequential CTEs. The first 
--      should compute total scores for all students. The second should calculate the average total 
--      score per university. Join them to show students who beat their own university's average.
-- Write your code below:
WITH StudentTotals AS(
SELECT 
	t.TraineeID,
	t.EnglishName,
	t.University,
	SUM(g.Total) as StudentTotalScore
FROM Trainees t
INNER JOIN Enrollments e
ON t.TraineeID = e.TraineeID
INNER JOIN Grades g
ON g.EnrollmentID = e.EnrollmentID
GROUP BY t.TraineeID, t.EnglishName, t.University
),
UniversityAverages AS(
SELECT 
	University,
	AVG(StudentTotalScore) as UniAverageScore
FROM StudentTotals
WHERE University IS NOT NULL
GROUP BY University
)
SELECT 
	st.TraineeID,
	st.EnglishName,
	st.University,
	st.StudentTotalScore,
	ua.UniAverageScore
FROM StudentTotals st
INNER JOIN UniversityAverages ua
ON st.University = ua.University
WHERE st.StudentTotalScore > ua.UniAverageScore
ORDER BY st.University, st.StudentTotalScore DESC

-- ===================================================================================
-- TOPIC 8: SET OPERATORS (UNION, INTERSECT, EXCEPT)
-- ===================================================================================

-- [Simple]
-- Q22: Use UNION to combine all unique EnglishNames of trainees and Names of instructors 
--      into a single output column called AllNames.
-- Write your code below:
SELECT 
	EnglishName as AllNames
FROM Trainees

UNION

SELECT
	InstructorName as AllNames
FROM Instructors

-- [Intermediate]
-- Q23: Use INTERSECT to find the IDs of all Trainees who both have an active entry in the 
--      Trainees table AND have been marked 'Present' at least once in the Attendance table.
-- Write your code below:
SELECT 
	TraineeID
FROM Trainees

INTERSECT 

SELECT DISTINCT
	TraineeID
FROM Attendance
WHERE Status = 'Present'
-- [Advanced]
-- Q24: Use EXCEPT to find a list of TraineeIDs who have recorded scores in the Grades table 
--      but have NEVER been marked for any session status in the Attendance table.
-- Write your code below:
SELECT 
	e.TraineeID
FROM Grades g
INNER JOIN Enrollments e
ON g.EnrollmentID = e.EnrollmentID

EXCEPT 

SELECT 
	TraineeID
FROM Attendance



-- ===================================================================================
-- TOPIC 9: WINDOW FUNCTIONS (AGGREGATIONS & RANKINGS)
-- ===================================================================================

-- [Simple]
-- Q25: Display each trainee's ID, LabID, and FinalExam score. Add a column showing the 
--      highest FinalExam score achieved inside that specific student's lab using MAX() OVER().
-- Write your code below:
SELECT 
	t.TraineeID,
	t.LabID,
	MAX(g.FinalExam) OVER(PARTITION BY LabID) as Max_Grad
FROM Grades g
INNER JOIN Enrollments e
ON g.EnrollmentID = e.EnrollmentID
INNER JOIN Trainees t
ON e.TraineeID = t.TraineeID

-- [Intermediate]
-- Q26: Provide a listing of all students alongside their MidExam marks. Use ROW_NUMBER(), 
--      RANK(), and DENSE_RANK() ordered by MidExam DESC. Observe how ties change the numbering.
-- Write your code below:
SELECT 
	t.TraineeID,
	g.MidExam,
	ROW_NUMBER() OVER(ORDER BY g.MidExam DESC) AS row_number_,
	RANK() OVER(ORDER BY g.MidExam DESC) as rank_,
	DENSE_RANK() OVER(ORDER BY g.MidExam DESC) as dense_rank_,
	NTILE(4) OVER(ORDER BY g.MidExam DESC) as ntile_
FROM Grades g
INNER JOIN Enrollments e
ON g.EnrollmentID = e.EnrollmentID
INNER JOIN Trainees t
ON e.TraineeID = t.TraineeID

-- [Advanced]
-- Q27: Within each Course Offering, use NTILE(3) to segment students into three performance 
--      brackets (Top Tier, Mid Tier, Bottom Tier) based on their computed Total score.
-- Write your code below:
SELECT 
    e.OfferingID,
    t.TraineeID,
    t.EnglishName,
    g.Total AS Student_Total,
    NTILE(3) OVER(PARTITION BY e.OfferingID ORDER BY g.Total DESC) AS Performance_Bracket
FROM Grades g
INNER JOIN Enrollments e ON g.EnrollmentID = e.EnrollmentID
INNER JOIN Trainees t ON e.TraineeID = t.TraineeID;


-- ===================================================================================
-- TOPIC 10: DATA CLEANING & CONDITIONAL LOGIC (CASE WHEN, COALESCE, ISNULL)
-- ===================================================================================

-- [Simple]
-- Q28: Display TraineeID and Faculty. If the Faculty value is NULL, display the string 
--      'Department Not Assigned' using the ISNULL function.
-- Write your code below:
SELECT 
	TraineeID,
	ISNULL(Faculty, 'Department Not Assigned')
FROM Trainees

-- [Intermediate]
-- Q29: Select the TraineeID, Phone, and Email. Use COALESCE to return the Phone number; 
--      if the Phone is missing, return the Email; if both are missing, return 'No Contact Info Available'.
-- Write your code below:
SELECT 
	TraineeID, Phone, 
	COALESCE(Email, Phone, 'No Contact Info Available') as Email
FROM Trainees

-- ===================================================================================
-- TOPIC 11: STORED PROCEDURES
-- ===================================================================================

-- [Simple]
-- Q30: Create a stored procedure named sp_GetAllCourses that returns all records from the 
--      Courses table with a duration greater than 20 hours.
-- Write your code below:

CREATE PROCEDURE sp_GetAllCourses
    @duration_hours INT = 20
AS
BEGIN
    SELECT *
    FROM Courses
    WHERE DurationHours > @duration_hours;
END;

EXEC sp_GetAllCourses;

-- EXEC sp_GetAllCourses @duration_hours = 30;

-- [Intermediate]
-- Q31: Create a stored procedure named sp_GetUniversityStats that takes an NVARCHAR input parameter 
--      named @UniName. The procedure should output the total count of students and their average 
--      FinalExam score for that specific university.
-- Write your code below:

CREATE PROCEDURE sp_GetUniversityStats
    @UniName NVARCHAR(50) = N'جامعة المنصورة'
AS
BEGIN
    SELECT
        t.University,
        COUNT(t.TraineeID) AS Total_Trainees,
        AVG(g.FinalExam) AS AVG_Final_Exam
    FROM Trainees t
    INNER JOIN Enrollments e
        ON t.TraineeID = e.TraineeID
    INNER JOIN Grades g
        ON e.EnrollmentID = g.EnrollmentID
    WHERE t.University = @UniName
    GROUP BY t.University;
END;

EXEC sp_GetUniversityStats;

EXEC sp_GetUniversityStats @UniName = N'جامعة القاهرة';