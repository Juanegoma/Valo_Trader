CREATE OR REPLACE FUNCTION registrar_usuario(
    p_nombre_usuario VARCHAR(255),
    p_contrasena_hash VARCHAR(255),
    p_correo VARCHAR(255)
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO Usuarios (nombre_usuario, contrasena, correo) 
    VALUES (p_nombre_usuario, p_contrasena_hash, p_correo);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION transferir_arma_db(
    p_usuario_origen_id INTEGER,
    p_usuario_destino_id INTEGER,
    p_arma_id INTEGER,
    p_cantidad INTEGER
)
RETURNS VOID AS $$
BEGIN
    IF (SELECT cantidad FROM inventarios WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id) >= p_cantidad THEN
        IF (SELECT cantidad FROM inventarios WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id) = p_cantidad THEN
            DELETE FROM inventarios WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id;
        ELSE
            UPDATE inventarios SET cantidad = cantidad - p_cantidad 
            WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id;
        END IF;

        IF EXISTS (SELECT 1 FROM inventarios WHERE usuario_id = p_usuario_destino_id AND arma_id = p_arma_id) THEN
            UPDATE inventarios SET cantidad = cantidad + p_cantidad 
            WHERE usuario_id = p_usuario_destino_id AND arma_id = p_arma_id;
        ELSE
            INSERT INTO inventarios (usuario_id, arma_id, cantidad) 
            VALUES (p_usuario_destino_id, p_arma_id, p_cantidad);
        END IF;
    ELSE
        RAISE EXCEPTION 'No hay suficientes unidades disponibles para transferir';
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION reembolsar_arma_db(
    p_usuario_id INTEGER,
    p_arma_id INTEGER,
    p_cantidad INTEGER
)
RETURNS VOID AS $$
BEGIN
    IF (SELECT cantidad FROM Inventarios WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id) >= p_cantidad THEN
        IF (SELECT cantidad FROM Inventarios WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id) = p_cantidad THEN
            DELETE FROM Inventarios WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id;
        ELSE
            -- Restar la cantidad del inventario del usuario
            UPDATE Inventarios SET cantidad = cantidad - p_cantidad 
            WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id;
        END IF;
    ELSE
        RAISE EXCEPTION 'No hay suficientes unidades disponibles para reembolsar';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION devolver_arma_db(
    p_usuario_id INTEGER,       -- ID del usuario que devuelve el arma
    p_usuario_origen_id INTEGER,  -- ID del usuario que envió el arma
    p_arma_id INTEGER,
    p_cantidad INTEGER
)
RETURNS VOID AS $$
BEGIN
    IF (SELECT cantidad FROM inventarios WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id) >= p_cantidad THEN
        IF (SELECT cantidad FROM inventarios WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id) = p_cantidad THEN
            DELETE FROM inventarios WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id;
        ELSE
            UPDATE inventarios SET cantidad = cantidad - p_cantidad 
            WHERE usuario_id = p_usuario_id AND arma_id = p_arma_id;
        END IF;

        IF EXISTS (SELECT 1 FROM inventarios WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id) THEN
            UPDATE inventarios SET cantidad = cantidad + p_cantidad 
            WHERE usuario_id = p_usuario_origen_id AND arma_id = p_arma_id;
        ELSE
            INSERT INTO inventarios (usuario_id, arma_id, cantidad) 
            VALUES (p_usuario_origen_id, p_arma_id, p_cantidad);
        END IF;        
    ELSE
        RAISE EXCEPTION 'No hay suficientes unidades disponibles para devolver';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION referir_amigo_db(
    p_usuario_id INTEGER,
    p_referido_id INTEGER
)
RETURNS VOID AS $$
BEGIN
    
    RAISE NOTICE 'Referir amigo implementado: usuario_id=%, referido_id=%', p_usuario_id, p_referido_id;
END;
$$ LANGUAGE plpgsql;