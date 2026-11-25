USE TiendaLogistica;
GO 

-- CARGAR LAS CATEGORIAS
SELECT 
    * 
FROM 
    dbo.categorias; 
GO 

-- INSERT 
-- INSERT INTO tabla(column1, column2, columnN) VALUES (valor1, valor2, valorN)
INSERT INTO categorias(nombre_categoria, descripcion) 
VALUES ('Redes y Conectividad', 'Routes, switches y cableado');
GO

-- Insertar varios registros
INSERT INTO categorias(nombre_categoria, descripcion) 
VALUES 
    ('Armas', 'AK-47'), 
    ('Música', 'Guitarra Eléctrica');
GO

-- Actualizar Valores (con WHERE)
-- UPDATE 
UPDATE categorias 
SET 
    nombre_categoria = 'Armas de Juguete'
WHERE 
    categoria_id = 1003

-- ELiminar registros (WHERE) 
-- DELETE 
DELETE FROM dbo.categorias 
WHERE 
    categoria_id = 1004
GO

-- TRANSACCIONES 
-- TRANSACTION
BEGIN TRANSACTION -- Bloque seguro y aislado (Viste Previa) 
    UPDATE dbo.productos 
        SET precio_unitario = CAST(precio_unitario * 1.10 AS decimal(10,2))
        WHERE categoria_id = 1;

        -- REVISAR EL RESULT ANTES DE DECIDIR 
        SELECT 
            * 
        FROM    
            dbo.productos 
        WHERE 
            categoria_id = 1

-- ROLLBACK => Deshacer los cambios 
-- COMMIT => Aplicar cambios

-- Si te equivocaste o hubo error 
ROLLBACK TRANSACTION;

-- Confirmar cambios 
COMMIT TRANSACTION;
-- ============================================

-- ELIMINAR con TRANSACTION
BEGIN TRANSACTION; 

    DELETE FROM dbo.categorias 
    WHERE 
        categoria_id = 1004
    GO

    COMMIT TRANSACTION;
-- =====================================================

SELECT * FROM dbo.pedidos;

BEGIN TRANSACTION 
    UPDATE dbo.pedidos 
        SET estado = 'Completado'
        WHERE LOWER(estado) = 'enviado' AND total_pedido < 300 
-- Cancelar el cambio
ROLLBACK TRANSACTION;
-- =========================================================

-- Verifico mi tabla 
SELECT * FROM dbo.detalle_pedidos;

BEGIN TRANSACTION; 
GO
    UPDATE dbo.detalle_pedidos 
    SET precio_venta = CAST(precio_venta * 1.05 AS decimal(10, 2))
    WHERE 
        cantidad = 1 AND 
        precio_venta < 200 
    GO
ROLLBACK TRANSACTION;