CREATE OR REPLACE FUNCTION transferir_arma_db(
    p_usuario_origen_id INTEGER,
    p_usuario_destino_id INTEGER,
    p_arma_id INTEGER,
    p_cantidad INTEGER
)
RETURNS VOID AS $$
BEGIN
    -- Verificar si el usuario tiene suficientes unidades
    IF (SELECT cantidad FROM inventarios WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id) >= p_cantidad THEN
        -- Si la cantidad a transferir es igual a la disponible, eliminar el registro
        IF (SELECT cantidad FROM inventarios WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id) = p_cantidad THEN
            DELETE FROM inventarios WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id;
        ELSE
            -- Restar la cantidad del inventario del usuario de origen
            UPDATE inventarios SET cantidad = cantidad - p_cantidad 
            WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id;
        END IF;

        -- Agregar o actualizar la cantidad en el inventario del usuario de destino
        IF EXISTS (SELECT 1 FROM inventarios WHERE usuario_id = p_usuario_destino_id AND arma_id = p_arma_id) THEN
            UPDATE inventarios SET cantidad = cantidad + p_cantidad 
            WHERE usuario_id = p_usuario_destino_id AND arma_id = p_arma_id;
        ELSE
            INSERT INTO inventarios (usuario_id, arma_id, cantidad) 
            VALUES (p_usuario_destino_id, p_arma_id, p_cantidad);
        END IF;

        -- Sumar 2000 al saldo del usuario de origen
        UPDATE Usuarios SET saldo = saldo + 2000 WHERE id = p_usuario_origen_id;
    ELSE
        -- Manejar el caso donde no hay suficientes unidades (e.g., lanzar una excepción)
        RAISE EXCEPTION 'No hay suficientes unidades disponibles para transferir';
    END IF;
END;
$$ LANGUAGE plpgsql;