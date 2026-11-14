# Blue Lock SQL Project  
## Índices en _PostgreSQL_ 

- Un **índice** en una base de datos tiene como **objetivo** mejorar el **rendimiento** de las `consultas (queries)`, permitiendo localizar **registros** de forma más **eficiente** sin _recorrer_ toda la **tabla**.

- Funciona como una **estructura de datos** adicional (_generalmente un **árbol B-Tree**_) que almacena **valores** de una o varias **columnas** junto con **referencias** a las filas correspondientes.

- Esto permite que las **consultas** sean más **rápidas** en operaciones como `WHERE`, `JOIN`, `ORDER BY` y `GROUP BY`, reduciendo el uso de **_escaneos completos de tabla (Seq Scan)_**.

> **OJO (PostgreSQL):** el escaneo completo se llama **`Seq Scan`**, no `Table Scan`. Y el planificador decide si usa el índice o no; un índice que no se usa solo ocupa espacio y hace más lentos los `INSERT`/`UPDATE`/`DELETE`.

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
---

## Tipos _Generales_  _(Se me ocurrió llamarlo así)_

- **Índice Primario (`PRIMARY KEY`)**
  - Se crea **automáticamente** al definir una `PRIMARY KEY`.
  - Garantiza que los **valores** sean **únicos** y **no nulos (`NOT NULL`)**.
  - Se utiliza para identificar de forma **única** cada registro de una **tabla**.

  **Ejemplo:**
  ```sql
  CREATE TABLE empleados (
      employeeid INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      firstname VARCHAR(50),
      lastname VARCHAR(50)
  );
  ```
---

- **Índice Único (`UNIQUE`)**
  - Garantiza que no existan **valores duplicados** en una o varias **columnas**.
  - En PostgreSQL, un `UNIQUE` permite **varios `NULL`** (los `NULL` no se consideran iguales entre sí).
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
  - Permite valores **nulos** si el atributo lo **_permite_**. 

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

- **Índice Parcial (`Partial Index`)**
  - Indexa **solo las filas que cumplen una condición**. Es más chico y más rápido que un índice completo.
  - Muy útil para columnas con muchos `NULL` o para estados concretos.

  ```sql
  CREATE INDEX idx_pedidos_pendientes
  ON pedidos(fecha)
  WHERE estado = 'pendiente';
  ```

---

- **Índice por Expresión (`Expression Index`)**
  - Indexa el **resultado de una expresión**, no la columna cruda. Sirve para búsquedas por `LOWER()`, fechas truncadas, etc.

  ```sql
  CREATE INDEX idx_email_lower
  ON usuarios(LOWER(email));
  ```

  ```sql
  SELECT * FROM usuarios WHERE LOWER(email) = 'ana@mail.com';
  ```

---

- **Índice de Cobertura (`Covering Index` con `INCLUDE`)**
  - Agrega columnas al índice para que la consulta se resuelva **solo con el índice** (_Index Only Scan_).

  ```sql
  CREATE INDEX idx_empleados_apellido
  ON empleados(lastname) INCLUDE (firstname, email);
  ```

---

## _Clusterizado_ en PostgreSQL

- PostgreSQL **no tiene índices clusterizados** como SQL Server. La `PRIMARY KEY` **no** ordena físicamente la tabla.
- Existe el comando `CLUSTER`, que **reordena una vez** la tabla según un índice. No se mantiene automáticamente: hay que volver a ejecutarlo.

  ```sql
  CLUSTER empleados USING idx_empleados_apellido;
  ```

  > **Nota:** para tablas que crecen mucho, `CLUSTER` bloquea la tabla. Se usa en ventanas de mantenimiento.

---

## Búsqueda de _texto completo_

- PostgreSQL **no usa `FULLTEXT` ni `MATCH ... AGAINST`** (eso es de MySQL). Se resuelve con:
  - `tsvector` + `tsquery` + índice **GIN** (búsqueda por palabras, con diccionario y stemming).
  - Extensión **`pg_trgm`** + índice GIN/GiST (búsquedas tipo `LIKE '%texto%'`).

  **Ejemplo con `tsvector`:**
  ```sql
  CREATE INDEX idx_productos_busqueda
  ON productos
  USING GIN (to_tsvector('spanish', description));
  ```

  ```sql
  SELECT *
  FROM productos
  WHERE to_tsvector('spanish', description) @@ to_tsquery('spanish', 'laptop & gamer');
  ```

  **Ejemplo con `pg_trgm`:**
  ```sql
  CREATE EXTENSION IF NOT EXISTS pg_trgm;

  CREATE INDEX idx_productos_trgm
  ON productos
  USING GIN (description gin_trgm_ops);
  ```

  ```sql
  SELECT * FROM productos WHERE description ILIKE '%laptop%';
  ```

---

## Tipos de índice según la _estructura_ en PostgreSQL

| Tipo | Para qué sirve |
|------|----------------|
| **B-Tree** | El más común. Igualdad, rangos y orden (`=`, `<`, `>`, `BETWEEN`, `ORDER BY`). Es el **default**. |
| **Hash** | Solo igualdad (`=`). Rara vez conviene frente a B-Tree. |
| **GIN** | Arreglos, `JSONB`, `tsvector`, `pg_trgm`. Ideal para búsquedas "contiene". |
| **GiST** | Datos geométricos, rangos, búsqueda de texto y vecinos más cercanos. |
| **BRIN** | Tablas enormes y ordenadas naturalmente (por ejemplo, series de tiempo). Muy chico. |
| **SP-GiST** | Estructuras no balanceadas: puntos, rutas, prefijos. |

```sql
CREATE INDEX idx_documento_json
ON documentos
USING GIN (contenido jsonb_path_ops);
```

---

## TABLA

## Clasificación de los Índices

| **Criterio** | **¿Qué clasifica?** | **Tipos** |
|---------------|----------------------|-----------|
| **Según la unicidad** | Si permite o no **valores duplicados** en la columna indexada. | `UNIQUE`, `NON UNIQUE` |
| **Según el número de columnas** | La cantidad de **columnas** que forman el índice. | Simple, Compuesto |
| **Según la organización física** | Cómo se almacenan físicamente los **datos** de la tabla con respecto al índice. | `CLUSTER` (reordenamiento manual), sin equivalente a "clustered index" |
| **Según su finalidad** | El **propósito** o uso específico del índice. | `PRIMARY KEY`, `UNIQUE`, parcial, expresión, cobertura |
| **Según la estructura interna** | La **estructura de datos** utilizada por el motor para implementar el índice. | `B-Tree`, `Hash`, `GIN`, `GiST`, `BRIN`, `SP-GiST` |

--- 

> **Ver los índices de una tabla en _PostgreSQL_:**   
> ```SQL 
> -- Desde psql:
> \d products
>
> -- O consultando el catálogo:
> SELECT indexname, indexdef
> FROM pg_indexes
> WHERE tablename = 'products';
> ```

> **Crear un índice sin bloquear la tabla (producción):**  
> ```sql
> CREATE INDEX CONCURRENTLY idx_empleados_apellido
> ON empleados(lastname);
> ```
> `CONCURRENTLY` no se puede usar dentro de una transacción y tarda más, pero no bloquea escrituras.

> **Consejo de Nombre a Índices:**  
> Puedes llamarlos así: `idx_NameTable_NameField`

> **Si vas a eliminar un Índice**  
> ```sql
> DROP INDEX idx_NameTable_NameField;
> ```
> _En PostgreSQL no se pone `ON tabla` al eliminar: el índice ya sabe a qué tabla pertenece. Sirve para índices `UNIQUE` también._

> **Ver el tamaño de los índices:**
> ```sql
> SELECT indexrelname, pg_size_pretty(pg_relation_size(indexrelid))
> FROM pg_stat_user_indexes
> ORDER BY pg_relation_size(indexrelid) DESC;
> ```

--- 
