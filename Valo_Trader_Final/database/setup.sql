-- Crear tablas en PostgreSQL
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre_usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    nivel_usuario INT DEFAULT 1 CHECK (nivel_usuario BETWEEN 1 AND 3),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    puntos_referidos INT DEFAULT 0,
    saldo NUMERIC(10, 2) DEFAULT 0
);

CREATE TABLE Armas (
    id SERIAL PRIMARY KEY,
    nombre_arma VARCHAR(50) UNIQUE NOT NULL,
    precio NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Inventarios (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES Usuarios(id) ON DELETE CASCADE,
    arma_id INT REFERENCES Armas(id) ON DELETE CASCADE,
    cantidad INT DEFAULT 1 CHECK (cantidad > 0),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Transacciones (
    id SERIAL PRIMARY KEY,
    tipo_transaccion VARCHAR(20) NOT NULL CHECK (tipo_transaccion IN ('transferencia', 'reembolso', 'devolucion')),
    usuario_id INT REFERENCES Usuarios(id) ON DELETE CASCADE,
    arma_id INT REFERENCES Armas(id) ON DELETE CASCADE,
    cantidad INT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    detalles TEXT 
);

CREATE TABLE Referidos (
    id SERIAL PRIMARY KEY,
    usuario_id INT REFERENCES Usuarios(id) ON DELETE CASCADE,
    referido_id INT REFERENCES Usuarios(id) ON DELETE CASCADE,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);