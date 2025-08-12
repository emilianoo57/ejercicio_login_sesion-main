-- ====================================
-- 🐉 BASE DE DATOS DRAGON BALL Z 🐉
-- ====================================

-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS dragonballz CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dragonballz;

-- ====================================
-- TABLA: usuarios (Guerreros Z)
-- ====================================
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    nombre_completo VARCHAR(100),
    nivel_poder INT DEFAULT 1000,
    raza ENUM('Saiyajin', 'Humano', 'Namekiano', 'Androide', 'Majin', 'Otro') DEFAULT 'Humano',
    planeta_origen VARCHAR(50) DEFAULT 'Tierra',
    tecnica_especial VARCHAR(100),
    transformacion VARCHAR(50),
    ki_actual INT DEFAULT 1000,
    ki_maximo INT DEFAULT 5000,
    estado ENUM('Activo', 'Entrenando', 'Descansando', 'En Batalla') DEFAULT 'Activo',
    experiencia INT DEFAULT 0,
    victorias INT DEFAULT 0,
    derrotas INT DEFAULT 0,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_conexion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ====================================
-- TABLA: tarjetas (Cartas de Guerreros)
-- ====================================
CREATE TABLE tarjetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    titulo VARCHAR(150),
    descripcion TEXT,
    imagen_url VARCHAR(255),
    nivel_poder INT DEFAULT 1000,
    raza VARCHAR(50),
    planeta_origen VARCHAR(50),
    tecnica_principal VARCHAR(100),
    transformaciones TEXT,
    ki_base INT DEFAULT 1000,
    fuerza INT DEFAULT 50,
    velocidad INT DEFAULT 50,
    resistencia INT DEFAULT 50,
    inteligencia INT DEFAULT 50,
    rareza ENUM('Común', 'Poco Común', 'Raro', 'Épico', 'Legendario', 'Mítico') DEFAULT 'Común',
    serie ENUM('Dragon Ball', 'Dragon Ball Z', 'Dragon Ball GT', 'Dragon Ball Super') DEFAULT 'Dragon Ball Z',
    saga VARCHAR(50),
    estado ENUM('Activo', 'Bloqueado', 'Especial') DEFAULT 'Activo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ====================================
-- TABLA: usuario_tarjetas (Colección de cartas por usuario)
-- ====================================
CREATE TABLE usuario_tarjetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tarjeta_id INT NOT NULL,
    fecha_obtencion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nivel_carta INT DEFAULT 1,
    experiencia_carta INT DEFAULT 0,
    favorita BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (tarjeta_id) REFERENCES tarjetas(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_card (usuario_id, tarjeta_id)
);

-- ====================================
-- INSERTAR USUARIOS DE EJEMPLO
-- ====================================
INSERT INTO usuarios (username, password, email, nombre_completo, nivel_poder, raza, planeta_origen, tecnica_especial, transformacion, ki_maximo, victorias, derrotas) VALUES
('goku', MD5('kamehameha123'), 'goku@dragonball.com', 'Son Goku', 9000, 'Saiyajin', 'Vegeta (criado en Tierra)', 'Kamehameha', 'Super Saiyajin Blue', 50000, 25, 5),
('vegeta', MD5('principe123'), 'vegeta@saiyajin.com', 'Vegeta', 8500, 'Saiyajin', 'Vegeta', 'Big Bang Attack', 'Super Saiyajin Blue Evolution', 48000, 22, 8),
('gohan', MD5('mystic123'), 'gohan@dragonball.com', 'Son Gohan', 7500, 'Saiyajin', 'Tierra', 'Masenko', 'Ultimate Gohan', 40000, 15, 3),
('piccolo', MD5('namek123'), 'piccolo@namek.com', 'Piccolo', 6000, 'Namekiano', 'Namek', 'Special Beam Cannon', 'Gigantificación', 25000, 18, 7),
('krillin', MD5('destructo123'), 'krillin@dragonball.com', 'Krillin', 3000, 'Humano', 'Tierra', 'Destructo Disc', 'Ninguna', 15000, 12, 10),
('yamcha', MD5('lobo123'), 'yamcha@dragonball.com', 'Yamcha', 2500, 'Humano', 'Tierra', 'Wolf Fang Fist', 'Ninguna', 12000, 8, 15);

-- ====================================
-- INSERTAR TARJETAS DE GUERREROS
-- ====================================
INSERT INTO tarjetas (nombre, titulo, descripcion, imagen_url, nivel_poder, raza, planeta_origen, tecnica_principal, transformaciones, ki_base, fuerza, velocidad, resistencia, inteligencia, rareza, serie, saga) VALUES
('Son Goku', '🥋 El Guerrero Saiyajin Legendario', 'El legendario Guerrero Saiyajin criado en la Tierra. Con su corazón puro y determinación inquebrantable, siempre busca superar sus límites y proteger a sus seres queridos.', 'https://via.placeholder.com/300x200/FF6B00/white?text=GOKU+🥋', 9000, 'Saiyajin', 'Vegeta', 'Kamehameha', 'Super Saiyajin, Super Saiyajin 2, Super Saiyajin 3, Super Saiyajin God, Super Saiyajin Blue, Ultra Instinto', 9000, 95, 90, 85, 75, 'Mítico', 'Dragon Ball Z', 'Saga de los Saiyajins'),

('Vegeta', '👑 El Príncipe de los Saiyajins', 'El Príncipe de los Saiyajins, orgulloso y poderoso. Su rivalidad con Goku lo ha llevado a alcanzar niveles de poder inimaginables en su búsqueda por ser el más fuerte.', 'https://via.placeholder.com/300x200/001F3F/white?text=VEGETA+👑', 8500, 'Saiyajin', 'Vegeta', 'Big Bang Attack', 'Super Saiyajin, Super Saiyajin 2, Super Saiyajin God, Super Saiyajin Blue, Super Saiyajin Blue Evolution', 8500, 90, 85, 90, 85, 'Mítico', 'Dragon Ball Z', 'Saga de los Saiyajins'),

('Son Gohan', '📚 El Guerrero Estudioso', 'Hijo de Goku, mitad Saiyajin y mitad humano. Posee un potencial oculto increíble que se desata cuando sus seres queridos están en peligro.', 'https://via.placeholder.com/300x200/7B68EE/white?text=GOHAN+📚', 7500, 'Saiyajin', 'Tierra', 'Masenko', 'Super Saiyajin, Super Saiyajin 2, Ultimate Gohan', 7500, 85, 80, 75, 95, 'Legendario', 'Dragon Ball Z', 'Saga de Cell'),

('Piccolo', '🧘 El Guerrero Namekiano', 'El guerrero Namekiano que pasó de ser enemigo a uno de los protectores más leales de la Tierra. Mentor de Gohan y estratega excepcional.', 'https://via.placeholder.com/300x200/FF1493/white?text=PICCOLO+🧘', 6000, 'Namekiano', 'Namek', 'Special Beam Cannon', 'Gigantificación, Fusión con Nail, Fusión con Kami', 6000, 80, 75, 90, 90, 'Épico', 'Dragon Ball Z', 'Saga de los Saiyajins'),

('Krillin', '⚡ El Humano Más Fuerte', 'El humano más fuerte de la Tierra y mejor amigo de Goku. A pesar de no ser Saiyajin, su valentía y técnicas especiales lo convierten en un guerrero formidable.', 'https://via.placeholder.com/300x200/FFD700/white?text=KRILLIN+⚡', 3000, 'Humano', 'Tierra', 'Destructo Disc', 'Ninguna', 3000, 60, 85, 70, 80, 'Raro', 'Dragon Ball Z', 'Saga de Freezer'),

('Yamcha', '🐺 El Guerrero del Desierto', 'Ex-bandido del desierto convertido en guerrero Z. Conocido por su técnica del Kamehameha del Lobo y su espíritu luchador inquebrantable.', 'https://via.placeholder.com/300x200/8B4513/white?text=YAMCHA+🐺', 2500, 'Humano', 'Tierra', 'Wolf Fang Fist', 'Ninguna', 2500, 65, 80, 60, 70, 'Poco Común', 'Dragon Ball Z', 'Saga de los Saiyajins'),

('Freezer', '❄️ El Emperador del Universo', 'El tirano galáctico que aterrorizó el universo durante décadas. Poderoso y despiadado, responsable de la destrucción del planeta Vegeta.', 'https://via.placeholder.com/300x200/9400D3/white?text=FREEZER+❄️', 12000, 'Frost Demon', 'Desconocido', 'Death Beam', 'Primera Forma, Segunda Forma, Tercera Forma, Forma Final, Golden Freezer', 12000, 95, 90, 85, 95, 'Mítico', 'Dragon Ball Z', 'Saga de Freezer'),

('Cell', '🧬 El Androide Perfecto', 'El bio-androide creado por el Dr. Gero que absorbió las células de los guerreros más poderosos. Busca alcanzar la perfección absoluta.', 'https://via.placeholder.com/300x200/32CD32/white?text=CELL+🧬', 10000, 'Bio-Androide', 'Tierra', 'Kamehameha Solar', 'Forma Imperfecta, Forma Semi-Perfecta, Forma Perfecta, Super Perfect Cell', 10000, 90, 85, 88, 90, 'Mítico', 'Dragon Ball Z', 'Saga de Cell'),

('Majin Buu', '🍭 El Demonio Rosa', 'Una antigua criatura mágica de poder inmenso. A pesar de su apariencia infantil, posee una fuerza destructiva capaz de eliminar planetas enteros.', 'https://via.placeholder.com/300x200/FF69B4/white?text=BUU+🍭', 11000, 'Majin', 'Desconocido', 'Human Extinction Attack', 'Fat Buu, Evil Buu, Super Buu, Kid Buu', 11000, 92, 70, 95, 60, 'Mítico', 'Dragon Ball Z', 'Saga de Majin Buu'),

('Trunks', '⚔️ El Guerrero del Futuro', 'Hijo de Vegeta y Bulma, viene del futuro para advertir sobre los androides. Valiente y determinado a proteger la Tierra.', 'https://via.placeholder.com/300x200/4169E1/white?text=TRUNKS+⚔️', 6500, 'Saiyajin', 'Tierra', 'Burning Attack', 'Super Saiyajin, Super Saiyajin 2, Super Saiyajin Rage', 6500, 85, 90, 80, 85, 'Legendario', 'Dragon Ball Z', 'Saga de los Androides'),

('Goten', '🎮 El Joven Saiyajin', 'Hijo menor de Goku, hermano de Gohan. A pesar de su corta edad, posee un talento natural extraordinario para las artes marciales.', 'https://via.placeholder.com/300x200/FFA500/white?text=GOTEN+🎮', 4000, 'Saiyajin', 'Tierra', 'Kamehameha', 'Super Saiyajin', 4000, 70, 85, 65, 75, 'Épico', 'Dragon Ball Z', 'Saga de Majin Buu'),

('Gotenks', '🤸 La Fusión Definitiva', 'La fusión entre Goten y Trunks mediante la Danza de la Fusión. Combina el poder de ambos jóvenes Saiyajins con una personalidad traviesa.', 'https://via.placeholder.com/300x200/FF4500/white?text=GOTENKS+🤸', 8000, 'Saiyajin', 'Tierra', 'Super Ghost Kamikaze Attack', 'Super Saiyajin, Super Saiyajin 3', 8000, 88, 95, 75, 70, 'Legendario', 'Dragon Ball Z', 'Saga de Majin Buu');

-- ====================================
-- ASIGNAR TARJETAS A USUARIOS
-- ====================================
-- Goku obtiene algunas cartas
INSERT INTO usuario_tarjetas (usuario_id, tarjeta_id, nivel_carta, experiencia_carta, favorita) VALUES
(1, 1, 5, 1000, TRUE),  -- Goku tiene su propia carta como favorita
(1, 2, 3, 500, FALSE),  -- Goku tiene la carta de Vegeta
(1, 3, 4, 750, FALSE),  -- Goku tiene la carta de Gohan
(1, 4, 2, 200, FALSE);  -- Goku tiene la carta de Piccolo

-- Vegeta obtiene algunas cartas
INSERT INTO usuario_tarjetas (usuario_id, tarjeta_id, nivel_carta, experiencia_carta, favorita) VALUES
(2, 2, 5, 1200, TRUE),  -- Vegeta tiene su propia carta como favorita
(2, 1, 4, 800, FALSE),  -- Vegeta tiene la carta de Goku
(2, 10, 3, 600, FALSE), -- Vegeta tiene la carta de Trunks
(2, 7, 2, 300, FALSE);  -- Vegeta tiene la carta de Freezer

-- Gohan obtiene algunas cartas
INSERT INTO usuario_tarjetas (usuario_id, tarjeta_id, nivel_carta, experiencia_carta, favorita) VALUES
(3, 3, 5, 900, TRUE),   -- Gohan tiene su propia carta como favorita
(3, 1, 3, 400, FALSE),  -- Gohan tiene la carta de Goku
(3, 4, 4, 700, FALSE),  -- Gohan tiene la carta de Piccolo
(3, 8, 2, 250, FALSE);  -- Gohan tiene la carta de Cell

-- ====================================
-- ÍNDICES PARA OPTIMIZACIÓN
-- ====================================
CREATE INDEX idx_usuarios_username ON usuarios(username);
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_usuarios_nivel_poder ON usuarios(nivel_poder);
CREATE INDEX idx_tarjetas_nombre ON tarjetas(nombre);
CREATE INDEX idx_tarjetas_rareza ON tarjetas(rareza);
CREATE INDEX idx_tarjetas_nivel_poder ON tarjetas(nivel_poder);
CREATE INDEX idx_usuario_tarjetas_usuario ON usuario_tarjetas(usuario_id);
CREATE INDEX idx_usuario_tarjetas_tarjeta ON usuario_tarjetas(tarjeta_id);



