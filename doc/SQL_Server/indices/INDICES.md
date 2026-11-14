# Blue Lock SQL Project  
## Índices en _SQL Server_ 

- Un **índice** en una base de datos tiene como **objetivo** mejorar el **rendimiento** de las `consultas (queries)`, permitiendo localizar **registros** de forma más **eficiente** sin _recorrer_ toda la **tabla**.

- Funciona como una **estructura de datos** adicional (_generalmente un **árbol B-Tree**_) que almacena **valores** de una o varias **columnas** junto con **referencias** a las filas correspondientes.

- Esto permite que las **consultas** sean más **rápidas** en operaciones como `WHERE`, `JOIN`, `ORDER BY` y `GROUP BY`, reduciendo el uso de **_escaneos completos de tabla_**.

> **OJO (SQL Server):** el escaneo completo se llama **`Table Scan`** si la tabla no tiene índice clúster (es un *heap*), o **`Clustered Index Scan`** si la tabla sí lo tiene. Cuando el motor usa el índice para localizar filas se llama **`Index Seek`**; cuando lo recorre entero, **`Index Scan`**. Y el planificador decide si usa el índice o no; un índice que no se usa solo ocupa espacio y hace más lentos los `INSERT`/`UPDATE`/`DELETE`.

---
## Las _dos_ estructuras que tenés que entender

SQL Server organiza los índices en **dos grandes familias** según cómo guardan los datos:

- **Índice clúster (`CLUSTERED`)**
  - **Ordena físicamente las filas de la tabla** según la clave del índice. El nivel hoja del índice **es la tabla misma**.
  - Solo puede haber **UNO por tabla**, porque los datos no pueden estar ordenados de dos formas distintas a la vez.
  - La `PRIMARY KEY` crea un índice **clúster por defecto** (salvo que digas `PRIMARY KEY NONCLUSTERED` o ya exista otro clúster).
  - Es ideal para columnas por las que se consulta **rangos** (`fechas`, `id`).

- **Índice no clúster (`NONCLUSTERED`)**
  - Es una **estructura separada** que guarda la clave del índice + un **localizador** hacia la fila real (la clave del clúster, o el `RID` si la tabla es un *heap*).
  - Puede haber **muchos por tabla** (hasta 999).
  - Al final del índice puede llevar **columnas incluidas** (`INCLUDE`) para no tener que ir a buscar la fila.

```sql
-- Clúster sobre la fecha (ordenar la tabla por fecha)
CREATE CLUSTERED INDEX ix_pedidos_fecha
ON pedidos(fecha);

-- No clúster sobre el cliente (búsquedas puntuales)
CREATE NONCLUSTERED INDEX ix_pedidos_cliente
ON pedidos(id_cliente);
```

---
## Tipos según la _UNICIDAD_

- **Índice Único (`UNIQUE`)**
  - No permite valores duplicados en la columna o conjunto de columnas indexadas.
  
  ```SQL 
  CREATE UNIQUE INDEX idx_email
  ON usuarios(email);  
  ```  

- **Índice No Único (`NON UNIQUE`)**
  - Permite valores duplicados.
  - Es el tipo de índice más utilizado para mejorar el rendimiento de las consultas.

  ```SQL 
  CREATE INDEX idx_apellido
  ON empleados(apellido);
  ```  

> **OJO:** en SQL Server, un índice `UNIQUE` **no permite más de un `NULL`** (a diferencia de PostgreSQL, que sí los permite). Si necesitás varios `NULL`, usá un **índice filtrado** (`WHERE email IS NOT NULL`).

---

## Tipos _Generales_  _(Se me ocurrió llamarlo así)_

- **Índice Primario (`PRIMARY KEY`)**
  - Se crea **automáticamente** al definir una `PRIMARY KEY`.
  - Garantiza que los **valores** sean **únicos** y **no nulos (`NOT NULL`)**.
  - Se utiliza para identificar de forma **única** cada registro de una **tabla**.
  - Por defecto es **`CLUSTERED`**. Si querés que sea no clúster (porque preferís ordenar la tabla por otra columna), escribí `PRIMARY KEY NONCLUSTERED`.

  **Ejemplo:**
  ```sql
  CREATE TABLE empleados (
      employeeid INT IDENTITY(1,1) PRIMARY KEY,
      firstname VARCHAR(50),
      lastname VARCHAR(50)
  );
  ```
---
 
- **Índice Único (`UNIQUE`)**
  - Garantiza que no existan **valores duplicados** en una o varias **columnas**.
  - En SQL Server, un `UNIQUE` **no permite varios `NULL`** (solo uno).
  - Crear una restricción `UNIQUE` crea internamente un índice único.

  **Ejemplo:**
  ```sql
  CREATE UNIQUE INDEX idx_email
  ON empleados(email);
  ```
---

- **Índice Simple**
  - Se crea sobre una **única columna**.
  - Mejora el rendimiento de las consultas que utilizan esa **columna** en filtros o búsquedas.
  - Permite **duplicados**.

  **Ejemplo:**
  ```sql
  CREATE INDEX idx_lastname
  ON empleados(lastname);
  ```

  Consulta que se beneficia del índice:

  ```sql
  SELECT *
  FROM empleados
  WHERE lastname = 'Silva';
  ```
---

- **Índice Compuesto (`Composite Index`)**
  - Se crea sobre **dos o más columnas**.
  - Es útil cuando las consultas filtran o ordenan utilizando **varias columnas** al mismo tiempo.
  - Su eficiencia depende del **orden** en que fueron definidas las columnas (_regla del prefijo izquierdo o **Leftmost Prefix Rule**_).

  **Ejemplo:**
  ```sql
  CREATE INDEX idx_name
  ON empleados(lastname, firstname);
  ```

  **Ejemplo: con UNIQUE / Índice Único Compuesto**

  ```sql
  CREATE UNIQUE INDEX idx_name
  ON empleados(lastname, firstname);
  ```

  Consulta que aprovecha el índice:

  ```sql
  SELECT *
  FROM empleados
  WHERE lastname = 'Silva'
    AND firstname = 'Flavio';
  ```
---

- **Índice Filtrado (`Filtered Index`)**
  - Indexa **solo las filas que cumplen una condición**. Es más chico y más rápido que un índice completo.
  - Es el equivalente al *partial index* de PostgreSQL.
  - Muy útil para columnas con muchos `NULL` o para estados concretos.
  - **Restricción:** no puede usarse en consultas parametrizadas que no repliquen exactamente el filtro.

  ```sql
  CREATE INDEX idx_pedidos_pendientes
  ON pedidos(fecha)
  WHERE estado = 'pendiente';
  ```

---

- **Índice por Columna Calculada (`Computed Column Index`)**
  - SQL Server **no indexa expresiones directamente** (eso es el *expression index* de PostgreSQL). Hay que declarar una **columna calculada persistida** y luego indexarla.

  ```sql
  ALTER TABLE usuarios
  ADD email_lower AS LOWER(email) PERSISTED;

  CREATE INDEX idx_email_lower
  ON usuarios(email_lower);
  ```

  ```sql
  SELECT * FROM usuarios WHERE LOWER(email) = 'ana@mail.com';
  ```

---

- **Índice de Cobertura (`Covering Index` con `INCLUDE`)**
  - Agrega columnas al índice para que la consulta se resuelva **solo con el índice**.
  - En el plan de ejecución se ve como **`Index Seek`** sin un operador `Key Lookup` _(o `RID Lookup` en un heap)_.
  - Ojo: `INCLUDE` solo guarda la columna en el nivel hoja; no participa del orden ni de la búsqueda.

  ```sql
  CREATE INDEX idx_empleados_apellido
  ON empleados(lastname) INCLUDE (firstname, email);
  ```

---

## _Clusterizado_ en SQL Server

- **SQL Server sí tiene índices clúster**, a diferencia de PostgreSQL. La `PRIMARY KEY` crea uno por defecto y **ordena físicamente la tabla**.
- Si la tabla **no** tiene índice clúster se llama **`heap`** y sus filas no tienen un orden garantizado.
- La fragmentación se corrige con `ALTER INDEX ... REBUILD` o `ALTER INDEX ... REORGANIZE`. **No existe el comando `CLUSTER`** (eso es de PostgreSQL).

  ```sql
  -- Reconstruir el índice (bloquea la tabla)
  ALTER INDEX ix_empleados_apellido ON empleados REBUILD;

  -- Reorganizar el índice (online, menos invasivo)
  ALTER INDEX ix_empleados_apellido ON empleados REORGANIZE;
  ```

  > **Nota:** `REBUILD` con `ONLINE = ON` permite seguir leyendo y escribiendo mientras se reconstruye, pero solo está disponible en **Enterprise / Developer / Azure SQL**.

---

## Búsqueda de _texto completo_

- SQL Server **no usa `FULLTEXT` como si fuera MySQL** ni `MATCH ... AGAINST`. Usa un **índice de texto completo** (`FULLTEXT`) sobre un catálogo, y luego las funciones:
  - `CONTAINS`: búsqueda precisa (palabras, frases, prefijos, sinónimos).
  - `FREETEXT`: búsqueda aproximada por significado.
  - `CONTAINSTABLE` / `FREETEXTTABLE`: las mismas pero devolviendo ranking.

  **Ejemplo:**
  ```sql
  -- 1. Crear el catálogo de texto completo
  CREATE FULLTEXT CATALOG catalogo_productos;

  -- 2. Crear el índice de texto completo
  CREATE FULLTEXT INDEX ON productos(description)
  KEY INDEX PK_productos
  ON catalogo_productos;
  ```

  ```sql
  SELECT *
  FROM productos
  WHERE CONTAINS(description, '"laptop" AND "gamer"');
  ```

  > **OJO:** para búsquedas tipo `LIKE '%texto%'` **SQL Server no tiene `pg_trgm`** (eso es de PostgreSQL). Un `LIKE '%...%'` no usa el índice y hace un escaneo.

---

## Tipos de índice según la _estructura_ en SQL Server

| Tipo | Para qué sirve |
|------|----------------|
| **Rowstore B-Tree** (`CLUSTERED` / `NONCLUSTERED`) | El más común. Igualdad, rangos y orden (`=`, `<`, `>`, `BETWEEN`, `ORDER BY`). Es el **default**. |
| **Columnstore** (`CLUSTERED` / `NONCLUSTERED`) | Analítica y Data Warehouse. Comprime por columnas y acelera agregaciones sobre millones de filas. |
| **Hash** | Solo para tablas **optimizadas para memoria** (*In-Memory OLTP*). Igualdad muy rápida. |
| **XML** | Único para consultas sobre columnas de tipo `XML`. |
| **Spatial** | Único para columnas `GEOMETRY` / `GEOGRAPHY`. |
| **Full-Text** | Búsquedas por palabras en texto largo. |

> **NO existen en SQL Server:** `GIN`, `GiST`, `BRIN`, `SP-GiST` (eso es de PostgreSQL). Para JSON no hay índice GIN: se indexan columnas calculadas que extraen el valor con `JSON_VALUE`.

```sql
-- Índice columnstore no clúster: ideal para reportes y agregaciones
CREATE NONCLUSTERED COLUMNSTORE INDEX cci_ventas
ON ventas(fecha, total, categoria);

-- Índice sobre un valor extraído de JSON (columna calculada)
ALTER TABLE documentos
ADD cliente_id AS JSON_VALUE(contenido, '$.cliente.id') PERSISTED;

CREATE INDEX idx_documento_cliente
ON documentos(cliente_id);
```

---

## TABLA

## Clasificación de los Índices

| **Criterio** | **¿Qué clasifica?** | **Tipos** |
|---------------|----------------------|-----------|
| **Según la unicidad** | Si permite o no **valores duplicados** en la columna indexada. | `UNIQUE`, `NON UNIQUE` |
| **Según el número de columnas** | La cantidad de **columnas** que forman el índice. | Simple, Compuesto |
| **Según la organización física** | Cómo se almacenan físicamente los **datos** de la tabla con respecto al índice. | `CLUSTERED` (uno por tabla, ordena las filas), `NONCLUSTERED` |
| **Según su finalidad** | El **propósito** o uso específico del índice. | `PRIMARY KEY`, `UNIQUE`, filtrado, columna calculada, cobertura |
| **Según la estructura interna** | La **estructura de datos** utilizada por el motor para implementar el índice. | Rowstore B-Tree, Columnstore, Hash, XML, Spatial, Full-Text |

---

> **Ver los índices de una tabla en _SQL Server_:**   
> ```SQL 
> -- Desde SSMS / sqlcmd:
> sp_helpindex 'products';
>
> -- O consultando el catálogo:
> SELECT i.name, i.type_desc, i.is_unique, c.name AS columna
> FROM sys.indexes AS i
> JOIN sys.index_columns AS ic
>     ON ic.object_id = i.object_id AND ic.index_id = i.index_id
> JOIN sys.columns AS c
>     ON c.object_id = ic.object_id AND c.column_id = ic.column_id
> WHERE i.object_id = OBJECT_ID('products')
> ORDER BY i.index_id, ic.key_ordinal;
> ```

> **Crear un índice sin bloquear la tabla (producción):**  
> ```sql
> CREATE NONCLUSTERED INDEX idx_empleados_apellido
> ON empleados(lastname)
> WITH (ONLINE = ON);
> ```
> `ONLINE = ON` no bloquea lecturas ni escrituras, pero tarda más y solo está disponible en **Enterprise / Developer / Azure SQL**.

> **Consejo de Nombre a Índices:**  
> Puedes llamarlos así: `idx_NameTable_NameField`

> **Si vas a eliminar un Índice**  
> ```sql
> DROP INDEX idx_NameTable_NameField ON empleados;
> ```
> _En SQL Server **sí** se pone `ON tabla` al eliminar: a diferencia de PostgreSQL, el nombre del índice solo es único dentro de cada tabla, no en toda la base._

> **Ver el tamaño de los índices:**
> ```sql
> SELECT OBJECT_NAME(i.object_id) AS tabla,
>        i.name AS indice,
>        SUM(ps.used_page_count) * 8 / 1024.0 AS tamano_mb
> FROM sys.indexes AS i
> JOIN sys.dm_db_partition_stats AS ps
>     ON ps.object_id = i.object_id AND ps.index_id = i.index_id
> GROUP BY i.object_id, i.name
> ORDER BY tamano_mb DESC;
> ```

> **Ver la fragmentación de un índice:**
> ```sql
> SELECT OBJECT_NAME(object_id) AS tabla,
>        index_id,
>        avg_fragmentation_in_percent
> FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED')
> WHERE avg_fragmentation_in_percent > 10;
> ```

---
