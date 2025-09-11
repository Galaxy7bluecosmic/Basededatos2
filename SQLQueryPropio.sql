-- Tabla de Alumnos
CREATE TABLE Alumnos (
    AlumnoID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100),
    Apellido NVARCHAR(100)
);

-- Tabla de Profesores
CREATE TABLE Profesores (
    ProfesorID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100),
    Especialidad NVARCHAR(100)
);

-- Tabla de Cursos
CREATE TABLE Cursos (
    CursoID INT PRIMARY KEY IDENTITY,
    NombreCurso NVARCHAR(100)
);

-- Tabla de Inscripciones (relación Alumnos-Cursos)
CREATE TABLE Inscripciones (
    InscripcionID INT PRIMARY KEY IDENTITY,
    AlumnoID INT FOREIGN KEY REFERENCES Alumnos(AlumnoID),
    CursoID INT FOREIGN KEY REFERENCES Cursos(CursoID)
);

-- Tabla de Asignaciones (relación Profesores-Cursos)
CREATE TABLE Asignaciones (
    AsignacionID INT PRIMARY KEY IDENTITY,
    ProfesorID INT FOREIGN KEY REFERENCES Profesores(ProfesorID),
    CursoID INT FOREIGN KEY REFERENCES Cursos(CursoID)
);


INSERT INTO Cursos (NombreCurso) VALUES 
('POO'), 
('Algoritmos y estructuras de datos'), 
('Base de datos'), 
('Desarrollo web');


INSERT INTO Profesores (Nombre, Especialidad) VALUES 
('Ana Torres', 'POO'),
('Luis García', 'Algoritmos'),
('María López', 'Base de datos'),
('Carlos Ruiz', 'Desarrollo web');


INSERT INTO Alumnos (Nombre, Apellido) VALUES 
('Juan', 'Pérez'),
('Lucía', 'Ramírez'),
('Pedro', 'Gómez'),
('Sofía', 'Martínez');


INSERT INTO Inscripciones (AlumnoID, CursoID) VALUES 
(1, 1), (2, 1), -- Juan y Lucía en POO
(3, 2),         -- Pedro en Algoritmos
(4, 3),         -- Sofía en Base de datos
(1, 4);         -- Juan también en Desarrollo web

-- Asignaciones
INSERT INTO Asignaciones (ProfesorID, CursoID) VALUES 
(1, 1), -- Ana enseña POO
(2, 2), -- Luis enseña Algoritmos
(3, 3), -- María enseña Base de datos
(4, 4); -- Carlos enseña Desarrollo web

--tabla alumnos inscritos en cada curso
SELECT C.NombreCurso, A.Nombre + ' ' + A.Apellido AS Alumno
FROM Inscripciones I
JOIN Alumnos A ON I.AlumnoID = A.AlumnoID
JOIN Cursos C ON I.CursoID = C.CursoID;
--profesores que enseñan cada curso
SELECT C.NombreCurso, P.Nombre AS Profesor
FROM Asignaciones ASG
JOIN Profesores P ON ASG.ProfesorID = P.ProfesorID
JOIN Cursos C ON ASG.CursoID = C.CursoID;

--Cantidad de alumnos por cursos y profesores
SELECT 
    C.NombreCurso,
    P.Nombre AS Profesor,
    COUNT(I.AlumnoID) AS CantidadAlumnos
FROM Cursos C
JOIN Asignaciones ASG ON C.CursoID = ASG.CursoID
JOIN Profesores P ON ASG.ProfesorID = P.ProfesorID
LEFT JOIN Inscripciones I ON C.CursoID = I.CursoID
GROUP BY C.NombreCurso, P.Nombre;
