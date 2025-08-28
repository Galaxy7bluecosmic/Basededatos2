CREATE TABLE Clientees (
    id_Cli INT PRIMARY KEY,
    Nombre VARCHAR(100),
    Correo VARCHAR(100)
);

CREATE TABLE Pedidos (
    id_Pedidos INT PRIMARY KEY,
    id_Cli INT,
    Producto VARCHAR(100),
    Fecha DATE,
    FOREIGN KEY (id_Cli) REFERENCES Clientees(id_Cli)
);

INSERT INTO Clientees (id_Cli, Nombre, Correo)
VALUES
(1, 'Victor', 'ejemplo@gmail.com'),
(2,'Jose','Jose@gmail.com'),
(3,'Julio','JULIO@gmail.com');

INSERT INTO Pedidos (id_Pedidos, id_Cli, Producto, Fecha)
VALUES 
(101, 1, 'Celular Xiaomi note 14', '2025-08-21'),
(102, 1, 'Laptop Lenovo', '2025-08-21'),
(103,2, 'monitor redragon','2025-08-21'),
(104,3, 'monitor hp','2025-08-21');

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='Pedidos';

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='Clientees';

Select Nombre, correo from Clientees;

Select * from Clientees Order By Nombre ASC;

select 
C.Nombre,
C.Correo,
P.Producto,
P.Fecha
FROM Clientees C
INNER JOIN Pedidos P On C.id_Cli= P.id_Cli
ORDER BY C.Nombre ASC;

