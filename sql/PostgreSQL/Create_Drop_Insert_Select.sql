CREATE TABLE users (
	id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(150) UNIQUE NOT NULL, 
	age INTEGER CHECK (age >= 0), 
	registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ELIMINAR UNA TABLA 
DROP TABLE users;

-- VACIAR LA TABLA Y REINICIAR EL ID DESDE 1 
TRUNCATE TABLE users RESTART IDE

-- INSERTAR UN VALOR EN UNA TABLA
INSERT INTO users(name, email, age)
VALUES ('Elliot', 'elliotFsociety@gmail.com', 23);

-- INSERTAR MÁS DE UN VALOR EN UNA TABLA 
INSERT INTO users(name, email, age)
VALUES 
	('Alderson', 'alderson@gmail.com', 35), 
	('Mr. Robot', 'mrRobot@gmail.com', 44), 
	('Price', 'price12@gmail.com', 56);

INSERT INTO users(name, email, age)
VALUES ('Allison', 'elliotFsociet@gmail.com', 23);

-- Seleccionar datos de una tablar (*)
SELECT * FROM users;
