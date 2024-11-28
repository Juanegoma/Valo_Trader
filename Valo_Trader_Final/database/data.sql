-- datos de ejemplo 

-- Usuarios
INSERT INTO Usuarios (nombre_usuario, contrasena_hash, correo, nivel_usuario) VALUES
('valorant_user1', 'contrasena1', 'user1@game.com', 1),
('valorant_user2', 'contrasena2', 'user2@game.com', 1),
('valorant_user3', 'contrasena3', 'user3@game.com', 2),
('valorant_user4', 'contrasena4', 'user4@game.com', 2),
('valorant_user5', 'contrasena5', 'user5@game.com', 3),
('valorant_user6', 'contrasena6', 'user6@game.com', 3),
('valorant_user7', 'contrasena7', 'user7@game.com', 1),
('valorant_user8', 'contrasena8', 'user8@game.com', 2),
('valorant_user9', 'contrasena9', 'user9@game.com', 3),
('admin_user', 'contrasena_admin', 'admin@game.com', 3);

-- Armas
INSERT INTO Armas (nombre_arma, precio) VALUES
('Classic', 0.00),
('Shorty', 150.00),
('Frenzy', 450.00),
('Ghost', 500.00),
('Sheriff', 800.00),
('Stinger', 950.00),
('Spectre', 1600.00),
('Bulldog', 2100.00),
('Guardian', 2250.00),
('Vandal', 2900.00),
('Phantom', 2900.00);

-- Inventarios
INSERT INTO Inventarios (usuario_id, arma_id, cantidad) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(2, 4, 1),
(3, 5, 3),
(4, 6, 1),
(5, 7, 2),
(5, 8, 1),
(6, 9, 1),
(7, 10, 2),
(8, 11, 1),
(9, 1, 1),
(9, 2, 2),
(10, 3, 3);

-- Transacciones
INSERT INTO Transacciones (tipo_transaccion, usuario_id, arma_id, cantidad, detalles) VALUES
('transferencia', 1, 1, 1, 'Transferencia de 1 Vandal a usuario2'),
('reembolso', 2, 2, 1, 'Reembolso de 1 Phantom'),
('transferencia', 3, 4, 1, 'Transferencia de 1 Sheriff a usuario1'),
('devolucion', 1, 1, 1, 'Devolución de 1 Vandal'),
('reembolso', 2, 2, 2, 'Reembolso de 2 Phantom'),
('transferencia', 1, 3, 1, 'Transferencia de 1 Operator a usuario4');

-- Referidos
INSERT INTO Referidos (usuario_id, referido_id) VALUES
(1, 2),  -- Usuario 1 refirió a Usuario 2
(2, 3);  -- Usuario 2 refirió a Usuario 3