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
VALUES (1, 'Victor', 'ejemplo@gmail.com');

INSERT INTO Pedidos (id_Pedidos, id_Cli, Producto, Fecha)
VALUES (101, 1, 'Celular Xiaomi note 14', '2025-08-21');

INSERT INTO Pedidos (id_Pedidos, id_Cli, Producto, Fecha)
VALUES (102, 1, 'Laptop Lenovo', '2025-08-21');

