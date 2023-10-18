USE modelo;

SHOW VARIABLES LIKE 'secure_file_priv';

-- Load data from instructors.txt into the instructor table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/instructors.txt'
INTO TABLE instructor
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;  -- To ignore the header line

-- Understand how MySQL would execute the following SELECT query
EXPLAIN 
SELECT Nombre, Apellido
FROM instructor
WHERE FechaIncorporacion > '2020-01-01';



/*
-----------------------------------
Section: Aggregate functions
Description: let you perform a calculation on multiple data and return a single value.
-----------------------------------
*/

-- COUNT
SELECT COUNT(*)
FROM alumno
INNER JOIN carrera
WHERE IDCarrera = 2;

-- SUM
-- Due we do not have a more representative and numeric column, we'll be using this just as example.
SELECT SUM(CedulaIdentidad)
FROM alumno
WHERE IDCohorte = 1235;

-- AVERAGE
SELECT AVG(TIMESTAMPDIFF(YEAR, a.FechaNacimiento, CURDATE())) as Avg_Age
FROM alumno a
JOIN cohorte co ON (a.IDCohorte = co.IDCohorte)
JOIN carrera ca ON (co.IDCarrera = ca.IDCarrera)
WHERE ca.Nombre = 'Full Stack Developer';

-- MAX
SELECT MAX(FechaIngreso)
FROM alumno;

-- MIN
SELECT MIN(FechaNacimiento)
FROM instructor;



/*
===================================
SECTION: Data Retrieval
Description: Queries to fetch data.
===================================
*/

-- Sort records by last name from A-Z
SELECT Nombre, Apellido, FechaIngreso
FROM alumno
ORDER BY Apellido ASC;

-- Sort records by entry date from newest to oldest and then by last name from A-Z.
SELECT Nombre, Apellido, FechaIngreso
FROM alumno
ORDER BY FechaIngreso DESC, Apellido ASC;

-- Returns the top 10.
SELECT Nombre, Apellido, FechaIngreso
FROM alumno
LIMIT 10;

-- Returns register 6 to 15.
SELECT Nombre, Apellido, FechaIngreso
FROM alumno
LIMIT 5,10;

-- List of cohorts with more than 50 students.
SELECT a.IDCohorte
FROM alumno a
JOIN cohorte co ON a.IDCohorte = co.IDCohorte
JOIN carrera ca ON co.IDCarrera = ca.IDCarrera
GROUP BY a.IDCohorte
HAVING COUNT(*) > 50;

-- Quantity of degree programs available
SELECT COUNT(IDCarrera) as Careers_quantity
FROM carrera;

-- Total number of students
SELECT DISTINCT COUNT(*) as Students_quantity
FROM alumno;

-- Number of students in each cohort
SELECT IDCohorte, COUNT(*) as Students_quantity
FROM alumno
GROUP BY IDCohorte;

-- List of students ordered by the most recent entrants, with first and last names in a single field
SELECT CONCAT(Nombre, ' ', Apellido) as Name_Surname, FechaIngreso
FROM alumno
ORDER BY FechaIngreso DESC;

-- First student who entered the institute
SELECT CONCAT(Nombre, ' ', Apellido) as Name_Surname, FechaIngreso
FROM alumno
ORDER BY FechaIngreso
LIMIT 1;

-- The date in which he/she entered (previous ex.)
SELECT DATE_FORMAT(FechaIngreso, '%d/%m/%Y') as EntryDate
FROM alumno
ORDER BY FechaIngreso
LIMIT 1;

-- Name and surname of the last student who entered the institute
SELECT CONCAT(Nombre, ' ', Apellido) as Name_Surname, FechaIngreso
FROM alumno
ORDER BY FechaIngreso DESC
LIMIT 1;

-- Number of students that entered the institute per year
SELECT YEAR(FechaIngreso) AS EntryYear, COUNT(*) AS Students_quantity
FROM alumno
GROUP BY EntryYear
ORDER BY 1;

-- Number of students that entered the institute per week
SELECT YEAR(FechaIngreso) AS Año, WEEKOFYEAR(FechaIngreso) as Semana, COUNT(*) as Students_quantity
FROM alumno
GROUP BY Año, Semana
ORDER BY 1,2;

-- Years in which more than 20 students enrolled
SELECT YEAR(FechaIngreso) AS EntryYear, COUNT(*) AS Students_quantity
FROM alumno
GROUP BY EntryYear
HAVING Students_quantity > 20
ORDER BY 2;

-- Age of the instructors
SELECT CONCAT(Nombre, ' ', Apellido) AS Name_Surname,
TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) AS Age,
DATE_ADD(FechaNacimiento, INTERVAL TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) YEAR) AS Verification,
FechaNacimiento
FROM instructor
ORDER BY 1;

-- Age of every student
SELECT IDAlumno, CONCAT(Nombre, ' ', Apellido) AS Name_Surname,
TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) AS Age,
DATE_ADD(FechaNacimiento, INTERVAL TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) YEAR) AS Verification,
FechaNacimiento
FROM alumno
ORDER BY 3 DESC;

-- Age update (intentional)
UPDATE alumno
SET FechaNacimiento = '2002-01-02'
WHERE IDAlumno = 127;

-- Average age
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()))) AS AverageAge
FROM alumno;

-- Average age per cohort
SELECT IDCohorte, ROUND(AVG(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()))) AS AverageAge
FROM alumno
GROUP BY IDCohorte;

-- List of students who exceed the average age
SELECT IDAlumno, CONCAT(Nombre, ' ', Apellido) AS Name_Surname,
TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) AS Age
FROM alumno
WHERE TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()) >
	(SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, FechaNacimiento, CURDATE()))) AS AverageAge
	FROM alumno)
ORDER BY 3;

-- Replaces or inserts instructor data based on unique CedulaIdentidad
REPLACE INTO instructor (CedulaIdentidad, Nombre, Apellido)
VALUES (25456879, 'Antonio', 'UpdatedLastName');

-- Fetch all students from cohort 1243
SELECT *
FROM alumno
WHERE IDCohorte = 1243;

-- Fetch distinct instructors associated with 'Full Stack' career
SELECT DISTINCT i.IDInstructor, i.Nombre, i.Apellido
FROM instructor i
JOIN cohorte c ON (c.IDInstructor = i.IDInstructor)
JOIN carrera ca ON (c.IDCarrera = ca.IDCarrera)
WHERE ca.Nombre LIKE '%Full Stack%';

-- Fetch all students from cohort 1235
SELECT *
FROM alumno
WHERE IDCohorte=1235;

-- Fetch students from cohort 1235 who were ingressed in the year 2019
SELECT *
FROM alumno
WHERE IDCohorte=1235 AND YEAR(FechaIngreso) = 2019;

-- Fetch student names, birthdate, and associated career name
SELECT a.Nombre, a.Apellido, a.FechaNacimiento, ca.Nombre AS Nombre_Carrera
FROM alumno a
JOIN cohorte c ON (a.IDCohorte = c.IDCohorte)
JOIN carrera ca ON (c.IDCarrera = ca.IDCarrera);



/*
===================================
SECTION: JOIN Operations
Description: Demonstrating various types of JOIN operations and their usage.
===================================
*/

-- INNER JOIN: Fetch students and their associated career names
SELECT a.Nombre, a.Apellido, ca.Nombre AS Nombre_Carrera
FROM alumno a
INNER JOIN cohorte c ON a.IDCohorte = c.IDCohorte
INNER JOIN carrera ca ON c.IDCarrera = ca.IDCarrera;

-- LEFT JOIN: Fetch all students and their associated career names, even if they don't belong to a cohort
SELECT a.Nombre, a.Apellido, ca.Nombre AS Nombre_Carrera
FROM alumno a
LEFT JOIN cohorte c ON a.IDCohorte = c.IDCohorte
LEFT JOIN carrera ca ON c.IDCarrera = ca.IDCarrera;

-- RIGHT JOIN: Fetch all careers and any associated students
SELECT a.Nombre, a.Apellido, ca.Nombre AS Nombre_Carrera
FROM alumno a
RIGHT JOIN cohorte c ON a.IDCohorte = c.IDCohorte
RIGHT JOIN carrera ca ON c.IDCarrera = ca.IDCarrera;

-- FULL JOIN (simulated in MySQL): Fetch all students and careers, even if they don't have a direct association
(SELECT a.Nombre, a.Apellido, ca.Nombre AS Nombre_Carrera
FROM alumno a
LEFT JOIN cohorte c ON a.IDCohorte = c.IDCohorte
LEFT JOIN carrera ca ON c.IDCarrera = ca.IDCarrera)
UNION
(SELECT a.Nombre, a.Apellido, ca.Nombre AS Nombre_Carrera
FROM alumno a
RIGHT JOIN cohorte c ON a.IDCohorte = c.IDCohorte
RIGHT JOIN carrera ca ON c.IDCarrera = ca.IDCarrera);

-- CROSS JOIN: Fetch all combinations of students and careers
SELECT a.Nombre, a.Apellido, ca.Nombre AS Nombre_Carrera
FROM alumno a
CROSS JOIN carrera ca;