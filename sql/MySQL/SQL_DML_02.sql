use bdejemplo;

-- FUNCIONES AGREGADAS 

-- ORDER BY : Ordenar Lexicográficamente (orden de diccionario)
-- Sintaxys: 
-- select  -  from  -  order by colum asc / desc 
select * from productos;
-- Ordenar alfabéticamente de forma ascendente
select * from productos order by nombre asc;
-- Ordenar alfabéticamente de forma descendente
select * from productos order by nombre desc;

-- Ordenar por precio ascendentemente 
select * from productos order by precio asc; 
-- Ordenar por precio descendentemente
select * from productos order by precio desc; 

-- COUNT(column) : Cuenta el número de filas no nulo
select count(id) as n_productos from productos;
select count(*) from productos;

-- SUM : Suma los valores numéricos de una columna
select sum(stock) as productos_totales_en_tienda 
from productos
where stock <= 100;
 
-- MIN / MAX : Mínimo y Máximo valor numérico de una columna 
select min(precio) as precio_mas_barato from productos;
select max(precio) as precio_mas_caro from productos;

select categoria, 
max(precio) as mas_caro, 
min(precio) as mas_barato,
count(*) as cantidad_producto,
sum(stock) as suma_stock
from productos 
group by categoria 
order by categoria;

select * from productos;

-- AVG (AVERAG) : Promedio 
select avg(precio) as precio_promedio from productos;

select categoria,
count(id) as cantidad_producto,
sum(stock) as cantidad_stock, 
min(precio) as precio_mas_bajo,
max(precio) as precio_mas_caro,
avg(precio) as precio_promedio
from productos 
where precio > 1000
group by categoria
order by categoria;


-- GROUP BY : Agrupar por 
-- Siempore usa con funciones de agregación como el sum(column) , min(column), max(column), aveg(column), count(column)
select categoria,
min(precio) as precio_bajo,
max(precio) as precio_alto, 
avg(precio) as precio_promedio
from productos 
group by categoria;


-- DISTINCT : Eliminar filas duplicadas 
select distinct categoria  from productos;

-- HAVING : Filtra los grupos que cumplen una condición 
-- se usa comumente de la mano del GROPU BY para usarlo 

select categoria, 
sum(precio) 
from productos 
where precio > 100
group by  categoria 
having sum(precio) > 500;

-- LIMIT : Limitar cantidad de resultados deseados 
select * from productos
order by precio asc
limit 5;


-- ============================================================

-- ORDEN DE SINTAXIS 
-- SELECT and DISTINCT: 
select categoria,
min(precio) as precio_mas_barato,
max(precio) as precio_mas_caro, 
round(avg(precio), 2) as precio_promedio,
sum(stock) as n_productos_stock, 
count(id) as n_producto
-- FROM:
from productos 
-- WHERE:
-- GROUP BY:
group by categoria
-- HAVING:
-- ORDER BY:
order by n_productos_stock desc
-- LIMIT:
limit 5;

-- ORDEN DE SINTAXIS 
-- SELECT and DISTINCT: 
select categoria,
min(precio) as precio_mas_barato,
max(precio) as precio_mas_caro, 
round(avg(precio), 2) as precio_promedio
-- FROM:
from productos 
-- WHERE:
-- GROUP BY:
group by categoria
-- HAVING: 
having round(avg(precio), 2) > 500
-- ORDER BY: 
order by categoria asc;
-- LIMIT: