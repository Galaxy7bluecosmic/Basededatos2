CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY,
    Nombre NVARCHAR(50),
    Stock INT
);

CREATE TABLE Ventas (
    IdVenta INT PRIMARY KEY IDENTITY,
    IdProducto INT,
    Cantidad INT,
    Fecha DATETIME,
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);

INSERT INTO Productos VALUES (1, 'Teclado mecánico', 10);
INSERT INTO Productos VALUES (2, 'Mouse gamer', 5);

BEGIN TRANSACTION;

BEGIN TRY
    -- Paso 1: Insertar la venta
    INSERT INTO Ventas (IdProducto, Cantidad, Fecha)
    VALUES (1, 2, GETDATE());

     -- Actualizar el stock
    UPDATE Productos
    SET Stock = Stock - 2
    WHERE IdProducto = 1;

    -- Verificación: si el stock quedó negativo, se fuerza un error
    IF (SELECT Stock FROM Productos WHERE IdProducto = 1) < 0
        THROW 50001, 'Stock insuficiente. No se puede realizar la venta.', 1;

    -- Si todo sale bien, confirmamos los cambios
    COMMIT TRANSACTION;
    PRINT 'Transacción completada exitosamente.';

END TRY
BEGIN CATCH
    -- Si ocurre un error, revertimos los cambios
    ROLLBACK TRANSACTION;
    PRINT ' Error en la transacción: ' + ERROR_MESSAGE();
END CATCH;

INSERT INTO Ventas (IdProducto, Cantidad, Fecha)
VALUES (1, 12, GETDATE());

SELECT * FROM Productos;
SELECT * FROM Ventas;
