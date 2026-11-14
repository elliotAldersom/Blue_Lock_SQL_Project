-- FUNCIONES MATEMATICAS 
use bdejemplo;

-- Operadores Matemáticos: 
-- suma (+) | resta (-) | multiplicacion (*) | división (/) | módulo o resto (%) 
select empleados.*, sueldo * 12 as sueldo_anual from empleados;

-- Funciones Matemáticas 
-- ABS(num) : Valor absoluto 
select abs(-102); -- 102

-- ROUND(a, b) : Redondea 
-- a => Número a redondear | b => Número de decimales que va a tener 
select round(59.789, 2); -- 59.79

-- CEIL(num) o CEILING(num) : Redondea hacia arriba  
select ceil(15.1); -- 16

-- FLOOR(num) : Redondea hacia abajo (como si quitara el decimal) 
select floor(15.9); -- 15 

-- POW(num, exp) o POWER(num, exp) : Potenica 
select pow(2, 3); -- 8

-- SQRT(num) : Raiz cuadrada
select sqrt(9); -- 3

-- MOD(dividendo, divisor) : Residuo de división 
select mod(10,3); -- 1 | Equivalente a  SELECT 10 % 3;

-- RAND() : RANDOM Número pseudoaleatoria entre 0 - 1 
-- 0 <= x < 1
-- FORMULA GENERAL DE NUM ALEATORIOS ENTEROS: FLOOR(RAND() * (max - min + 1)) + min
select round((rand() * (120 - 50 + 1) + 50), 2);

