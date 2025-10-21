-- config/mysql/init.sql
USE produccion;

-- Crear tablas de ejemplo
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS transacciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    tipo ENUM('deposito', 'retiro', 'transferencia') NOT NULL,
    descripcion VARCHAR(255),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    INDEX idx_usuario (usuario_id),
    INDEX idx_fecha (fecha),
    INDEX idx_tipo (tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    operacion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    usuario VARCHAR(50) NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos_anteriores JSON,
    datos_nuevos JSON,
    INDEX idx_tabla (tabla),
    INDEX idx_fecha (fecha)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar datos de prueba
INSERT INTO usuarios (username, email, password_hash, status) VALUES
    ('admin', 'admin@example.com', SHA2('admin123', 256), 'active'),
    ('user1', 'user1@example.com', SHA2('user123', 256), 'active'),
    ('user2', 'user2@example.com', SHA2('user123', 256), 'active'),
    ('testuser', 'test@example.com', SHA2('test123', 256), 'inactive');

INSERT INTO transacciones (usuario_id, monto, tipo, descripcion) VALUES
    (1, 1000.00, 'deposito', 'Depsito inicial'),
    (2, 500.50, 'deposito', 'Depsito mensual'),
    (1, 200.00, 'retiro', 'Retiro ATM'),
    (2, 150.00, 'transferencia', 'Pago de servicios'),
    (3, 750.00, 'deposito', 'Salario');

-- Permisos
GRANT SELECT, INSERT, UPDATE, DELETE ON produccion.* TO 'app_user'@'%';
FLUSH PRIVILEGES;

-- Mostrar configuracin
SELECT 'MySQL inicializado correctamente' AS status;
SHOW DATABASES;
