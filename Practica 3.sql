CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY,
    Nombre NVARCHAR(50),
    Stock INT
);

CREATE TABLE VentasPendientes (
    IdVenta INT PRIMARY KEY,
    IdProducto INT,
    CantidadVendida INT,
    Procesado BIT DEFAULT 0
);
INSERT INTO Productos VALUES (1, 'Teclado', 20);
INSERT INTO Productos VALUES (2, 'Mouse', 30);
INSERT INTO Productos VALUES (3, 'Monitor', 10);

INSERT INTO VentasPendientes VALUES (1, 1, 5, 0);
INSERT INTO VentasPendientes VALUES (2, 2, 10, 0);
INSERT INTO VentasPendientes VALUES (3, 3, 15, 0); -- Esto provocará error por stock insuficiente
DECLARE @IdVenta INT, @IdProducto INT, @Cantidad INT;

DECLARE ventas_cursor CURSOR FOR
    SELECT IdVenta, IdProducto, CantidadVendida
    FROM VentasPendientes
    WHERE Procesado = 0;

OPEN ventas_cursor;

FETCH NEXT FROM ventas_cursor INTO @IdVenta, @IdProducto, @Cantidad;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar stock disponible
        IF (SELECT Stock FROM Productos WHERE IdProducto = @IdProducto) < @Cantidad
            THROW 51000, 'Stock insuficiente para realizar la venta.', 1;

        -- Descontar del stock
        UPDATE Productos
        SET Stock = Stock - @Cantidad
        WHERE IdProducto = @IdProducto;

        -- Marcar la venta como procesada
        UPDATE VentasPendientes
        SET Procesado = 1
        WHERE IdVenta = @IdVenta;

        COMMIT TRANSACTION;
        PRINT 'Venta procesada correctamente.';
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error en la venta ' + CAST(@IdVenta AS NVARCHAR(10)) + ': ' + ERROR_MESSAGE();
    END CATCH;

    FETCH NEXT FROM ventas_cursor INTO @IdVenta, @IdProducto, @Cantidad;
END

CLOSE ventas_cursor;
DEALLOCATE ventas_cursor;
CREATE TABLE Produccion (
    IdRegistro INT PRIMARY KEY,
    Maquina VARCHAR(50),
    Turno VARCHAR(20),          -- Ej: 'Mañana', 'Tarde', 'Noche'
    Fecha DATE,
    HoraInicio DATETIME,
    HoraFin DATETIME,
    UnidadesProducidas INT
);
