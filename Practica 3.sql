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




-- =====================================
CREATE TABLE Productos (
    IdProducto INT PRIMARY KEY,
    Nombre NVARCHAR(50),
    Stock INT
);

CREATE TABLE Ventas (
    IdVenta INT IDENTITY PRIMARY KEY,
    IdProducto INT,
    Cantidad INT,
    Fecha DATETIME,
    FOREIGN KEY (IdProducto) REFERENCES Productos(IdProducto)
);
INSERT INTO Productos VALUES (1, 'Teclado mecánico', 10);
INSERT INTO Productos VALUES (2, 'Mouse gamer', 3);
INSERT INTO Productos VALUES (3, 'Monitor 24"', 8);

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @IdProducto INT, @Cantidad INT, @StockActual INT;

    -- CURSOR: recorrerá una lista de productos con sus cantidades a vender
    DECLARE cursorVentas CURSOR FOR
    SELECT IdProducto, Cantidad
    FROM (VALUES
        (1, 2),   -- Producto 1: vender 2 unidades
        (2, 5),   -- Producto 2: vender 5 unidades (provocará error)
        (3, 1)    -- Producto 3: vender 1 unidad
    ) AS ListaVentas(IdProducto, Cantidad);

    OPEN cursorVentas;

    FETCH NEXT FROM cursorVentas INTO @IdProducto, @Cantidad;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Consultar stock actual
        SET @StockActual = (SELECT Stock FROM Productos WHERE IdProducto = @IdProducto);

        -- Verificar si hay suficiente stock
        IF @StockActual < @Cantidad
        BEGIN
            THROW 50005, 'Error: stock insuficiente para el producto.', 1;
        END

        -- Registrar la venta
        INSERT INTO Ventas (IdProducto, Cantidad, Fecha)
        VALUES (@IdProducto, @Cantidad, GETDATE());

        -- Actualizar el stock
        UPDATE Productos
        SET Stock = Stock - @Cantidad
        WHERE IdProducto = @IdProducto;

        PRINT 'Venta procesada para el producto ' + CAST(@IdProducto AS NVARCHAR);

        FETCH NEXT FROM cursorVentas INTO @IdProducto, @Cantidad;
    END;

    CLOSE cursorVentas;
    DEALLOCATE cursorVentas;

    COMMIT TRANSACTION;
    PRINT 'Todas las ventas se completaron exitosamente.';

END TRY
BEGIN CATCH
    -- Si ocurre un error, revertimos los cambios
    ROLLBACK TRANSACTION;
    CLOSE cursorVentas;
    DEALLOCATE cursorVentas;
    PRINT 'Error en la transacción: ' + ERROR_MESSAGE();
END CATCH;

--------------------------------------------------------------
CREATE TABLE Empleados (
    IdEmpleado INT PRIMARY KEY,
    Nombre NVARCHAR(50),
    Saldo DECIMAL(10,2)
);

CREATE TABLE Pagos (
    IdPago INT IDENTITY PRIMARY KEY,
    IdEmpleado INT,
    Monto DECIMAL(10,2),
    Fecha DATETIME,
    FOREIGN KEY (IdEmpleado) REFERENCES Empleados(IdEmpleado)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO Empleados VALUES (1, 'Ana Torres', 1500.00);
INSERT INTO Empleados VALUES (2, 'Luis Pérez', 800.00);
INSERT INTO Empleados VALUES (3, 'María Gómez', 2000.00);

-- =====================================
-- CURSOR CON TRANSACCIÓN Y THROW
-- =====================================
BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @IdEmpleado INT, @Monto DECIMAL(10,2), @SaldoActual DECIMAL(10,2);

    -- CURSOR: lista de pagos a realizar
    DECLARE cursorPagos CURSOR FOR
    SELECT IdEmpleado, Monto
    FROM (VALUES
        (1, 500.00),   -- Pago válido
        (2, 1000.00),  -- Error: saldo insuficiente
        (3, 200.00)    -- Este ya no se procesará por el error anterior
    ) AS ListaPagos(IdEmpleado, Monto);

    OPEN cursorPagos;

    FETCH NEXT FROM cursorPagos INTO @IdEmpleado, @Monto;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Consultar saldo actual del empleado
        SET @SaldoActual = (SELECT Saldo FROM Empleados WHERE IdEmpleado = @IdEmpleado);

        -- Validar si tiene suficiente saldo
        IF @SaldoActual < @Monto
        BEGIN
            THROW 60001, 'Error: saldo insuficiente para realizar el pago.', 1;
        END

        -- Registrar el pago
        INSERT INTO Pagos (IdEmpleado, Monto, Fecha)
        VALUES (@IdEmpleado, @Monto, GETDATE());

        -- Descontar del saldo
        UPDATE Empleados
        SET Saldo = Saldo - @Monto
        WHERE IdEmpleado = @IdEmpleado;

        PRINT 'Pago procesado correctamente para el empleado ' + CAST(@IdEmpleado AS NVARCHAR);

        FETCH NEXT FROM cursorPagos INTO @IdEmpleado, @Monto;
    END;

    CLOSE cursorPagos;
    DEALLOCATE cursorPagos;

    COMMIT TRANSACTION;
    PRINT ' Todos los pagos se realizaron correctamente.';

END TRY
BEGIN CATCH
    -- Si hay error, se revierte todo
    ROLLBACK TRANSACTION;
    CLOSE cursorPagos;
    DEALLOCATE cursorPagos;
    PRINT ' Error en el proceso: ' + ERROR_MESSAGE();
END CATCH;
SELECT * FROM Empleados;
SELECT * FROM Pagos;

-- =====================================
-- TABLAS DE EJEMPLO
-- =====================================
CREATE TABLE Libros (
    IdLibro INT PRIMARY KEY,
    Titulo NVARCHAR(100),
    Precio DECIMAL(10,2)
);

-- =====================================
-- DATOS DE PRUEBA
-- =====================================
INSERT INTO Libros VALUES (1, 'El Principito', 35.00);
INSERT INTO Libros VALUES (2, 'Cien años de soledad', 50.00);
INSERT INTO Libros VALUES (3, 'Don Quijote de la Mancha', 0.00); -- Error: precio no válido
INSERT INTO Libros VALUES (4, '1984', 42.50);

-- =====================================
-- CURSOR CON TRANSACCIÓN Y THROW
-- =====================================
BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @IdLibro INT, @Titulo NVARCHAR(100), @Precio DECIMAL(10,2);

    -- Cursor para recorrer los libros
    DECLARE cursorLibros CURSOR FOR
    SELECT IdLibro, Titulo, Precio FROM Libros;

    OPEN cursorLibros;

    FETCH NEXT FROM cursorLibros INTO @IdLibro, @Titulo, @Precio;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Validar que el precio sea válido
SELECT * FROM Libros;

CREATE TABLE Cuentas (
    IdCuenta INT PRIMARY KEY,
    Titular NVARCHAR(50),
    Saldo DECIMAL(10,2)
);

CREATE TABLE TransferenciasPendientes (
    IdTransferencia INT PRIMARY KEY,
    IdCuentaOrigen INT,
    IdCuentaDestino INT,
    Monto DECIMAL(10,2),
    Procesado BIT DEFAULT 0
);
INSERT INTO Cuentas VALUES (1, 'Carlos', 1000.00);
INSERT INTO Cuentas VALUES (2, 'Ana', 800.00);
INSERT INTO Cuentas VALUES (3, 'Luis', 500.00);

INSERT INTO TransferenciasPendientes VALUES (1, 1, 2, 200.00, 0);
INSERT INTO TransferenciasPendientes VALUES (2, 2, 3, 300.00, 0);
DECLARE @IdTransferencia INT, @Origen INT, @Destino INT, @Monto DECIMAL(10,2);

DECLARE transfer_cursor CURSOR FOR
    SELECT IdTransferencia, IdCuentaOrigen, IdCuentaDestino, Monto
    FROM TransferenciasPendientes
    WHERE Procesado = 0;

OPEN transfer_cursor;

FETCH NEXT FROM transfer_cursor INTO @IdTransferencia, @Origen, @Destino, @Monto;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Restar del origen
        UPDATE Cuentas
        SET Saldo = Saldo - @Monto
        WHERE IdCuenta = @Origen;

        -- Validar si tiene saldo suficiente
        IF (SELECT Saldo FROM Cuentas WHERE IdCuenta = @Origen) < 0
            THROW 51000, 'Saldo insuficiente en cuenta origen.', 1;

        -- Sumar al destino
        UPDATE Cuentas
        SET Saldo = Saldo + @Monto
        WHERE IdCuenta = @Destino;

        -- Marcar transferencia como procesada
        UPDATE TransferenciasPendientes
        SET Procesado = 1
        WHERE IdTransferencia = @IdTransferencia;

        COMMIT TRANSACTION;
        PRINT 'Transferencia procesada correctamente.';
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error en la transferencia: ' + ERROR_MESSAGE();
    END CATCH;

    FETCH NEXT FROM transfer_cursor INTO @IdTransferencia, @Origen, @Destino, @Monto;
END

CLOSE transfer_cursor;
DEALLOCATE transfer_cursor;
