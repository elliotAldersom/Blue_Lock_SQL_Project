OLIST - PAQUETE PARA SQL SERVER

Contenido:
- csv/: las 11 tablas exportadas como CSV UTF-8 con encabezados.
- create_tables.sql: crea las tablas en dbo, sin PK/FK para facilitar la carga inicial.
- bulk_insert_template.sql: ejemplo de carga masiva; cambiar C:\Olist\csv por la ruta real.
- Este paquete no modifica la base SQLite original.

Tablas incluidas:
- customers
- geolocation
- leads_closed
- leads_qualified
- order_items
- order_payments
- order_reviews
- orders
- product_category_name_translation
- products
- sellers

Carga recomendada:
1. Descomprime el ZIP en una carpeta, por ejemplo C:\Olist.
2. En SSMS, conéctate a la base de datos destino (créala primero si aún no existe).
3. Ejecuta create_tables.sql.
4. Para importar, puedes usar SSMS: clic derecho en la base > Tasks > Import Data, o ejecutar bulk_insert_template.sql después de ajustar las rutas.
5. Si usas BULK INSERT, la cuenta del servicio de SQL Server debe tener permiso de lectura sobre la carpeta CSV. Si el servidor SQL está en otra máquina, la ruta debe ser accesible desde esa máquina.
6. Verifica los conteos con SELECT COUNT(*) en cada tabla.

Notas:
- Los campos de código postal se exportan como texto NVARCHAR(10), conservando ceros a la izquierda.
- Las columnas de texto se crean como NVARCHAR; comentarios largos como NVARCHAR(MAX).
- Los valores numéricos REAL se crean como FLOAT.
- No se agregan claves primarias ni foráneas todavía. Es mejor cargar y validar primero; luego crear las relaciones.
- Los campos vacíos del CSV pueden requerir revisión si necesitas distinguir exactamente entre NULL y cadena vacía de SQLite.
