-- Crear tabla contactos
CREATE TABLE IF NOT EXISTS contactos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  ciudad VARCHAR(50) NOT NULL
);

-- Insertar 5 contactos de ejemplo
INSERT INTO contactos (nombre, telefono, ciudad) VALUES
  ('Juan Pérez', '555-1234', 'Buenos Aires'),
  ('María García', '555-5678', 'Córdoba'),
  ('Carlos López', '555-9012', 'Rosario'),
  ('Ana Martínez', '555-3456', 'Mendoza'),
  ('Pedro Rodríguez', '555-7890', 'Tucumán');