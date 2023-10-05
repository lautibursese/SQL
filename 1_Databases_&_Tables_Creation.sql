DROP DATABASE IF EXISTS Modelo;
CREATE DATABASE Modelo;
USE Modelo;

CREATE TABLE Carrera (
    IDCarrera INT NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the career',
    Nombre VARCHAR (50) NOT NULL COMMENT 'Name of the career',
    PRIMARY KEY(IDCarrera)
);

ALTER TABLE Carrera COMMENT = 'Table storing information about different careers';


CREATE TABLE Instructorr (
    IDInstructor INT NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the instructor',
    CedulaIdentidad VARCHAR(30) NOT NULL COMMENT 'Identification card number of the instructor',
    Nombre VARCHAR(40) NOT NULL COMMENT 'First name of the instructor',
    Apellido VARCHAR(40) NOT NULL COMMENT 'Last name of the instructor',
    FechaNacimiento DATE NOT NULL COMMENT 'Birthdate of the instructor',
    FechaIncorporacion DATE COMMENT 'Date when the instructor was incorporated',
    PRIMARY KEY(IDInstructor)
) COMMENT = 'Table storing information about instructors';

RENAME TABLE Instructorr TO Instructor;

CREATE TABLE Cohorte (
    IDCohorte INT NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the cohort',
    Codigo VARCHAR(30) NOT NULL COMMENT 'Code or identifier associated with the cohort',
    IDCarrera INT NOT NULL COMMENT 'Foreign key linking to the related career',
    IDInstructor INT NOT NULL COMMENT 'Foreign key linking to the associated instructor',
    FechaInicio DATE COMMENT 'Start date of the cohort',
    FechaFinalizacion DATE COMMENT 'End date of the cohort',
    PRIMARY KEY(IDCohorte),
    FOREIGN KEY(IDCarrera) REFERENCES Carrera(IDCarrera),
    FOREIGN KEY(IDInstructor) REFERENCES Instructor(IDInstructor)
) COMMENT = 'Table storing information about different cohorts';

CREATE TABLE Alumno (
    IDAlumno INT NOT NULL AUTO_INCREMENT COMMENT 'Unique identifier for the student',
    CedulaIdentidad VARCHAR(30) NOT NULL COMMENT 'Identification card number of the student',
    Nombre VARCHAR(40) NOT NULL COMMENT 'First name of the student',
    Apellido VARCHAR(40) NOT NULL COMMENT 'Last name of the student',
    FechaNacimiento DATE NOT NULL COMMENT 'Birthdate of the student',
    FechaIngreso DATE COMMENT 'Date when the student was admitted',
    IDCohorte INT COMMENT 'Foreign key linking to the related cohort',
    PRIMARY KEY(IDAlumno),
    FOREIGN KEY(IDCohorte) REFERENCES Cohorte(IDCohorte)
) COMMENT = 'Table storing information about students';

/*
  The TRUNCATE TABLE command is used below to clear all records from the Alumno table.
  In the current context, the Alumno table is empty (i.e., it contains no records). 
  Therefore, executing TRUNCATE TABLE will not remove any data but serves as a demonstration 
  and ensures that the table is empty before subsequent operations, such as data insertion,
  are performed. Additionally, if the table uses an AUTO_INCREMENT column, TRUNCATE TABLE 
  will reset its counter to the initial value.
  Exercise caution when using this command in different contexts to prevent unintentional data loss.
*/
TRUNCATE TABLE Alumno;
