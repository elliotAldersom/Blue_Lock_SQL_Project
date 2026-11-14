# Blue Lock SQL Project  
## Índices 

- Un **índice** en una base de datos tiene como **objetivo** mejorar el **rendimiento** de las `consultas (queries)`, permitiendo localizar **registros** de forma más **eficiente** sin _recorrer_ toda la **tabla**.

- Funciona como una **estructura de datos** adicional (_generalmente un **árbol B-Tree**_) que almacena **valores** de una o varias **columnas** junto con **referencias** a las filas correspondientes.

- Esto permite que las **consultas** sean más **rápidas** en operaciones como `WHERE`, `JOIN`, `ORDER BY` y `GROUP BY`, reduciendo el uso de **_escaneos completos de tabla (Table Scan)_**.

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
      EmployeeID INT PRIMARY KEY,
      FirstName VARCHAR(50),
      LastName VARCHAR(50)
  );
  ```
---

- **Índice Único (`UNIQUE`)**
  - Garantiza que no existan **valores duplicados** en una o varias **columnas**.
  - Permite valores `NULL` (_dependiendo del motor de base de datos_).
  - En Gestores como `MySQL` el crear un `atributo UNIQUE` internamente se crear un `UNIQUR INDEX`. 

  **Ejemplo:**
  ```sql
  CREATE UNIQUE INDEX idx_email
  ON empleados(Email);
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
  ON empleados(LastName);
  ```

  Consulta que se beneficia del índice:

  ```sql
  SELECT *
  FROM empleados
  WHERE LastName = 'Silva';
  ```
---

- **Índice Compuesto (`Composite Index`)**
  - Se crea sobre **dos o más columnas**.
  - Es útil cuando las consultas filtran o ordenan utilizando **varias columnas** al mismo tiempo.
  - Su eficiencia depende del **orden** en que fueron definidas las columnas (_regla del prefijo izquierdo o **Leftmost Prefix Rule**_).

  **Ejemplo:**
  ```sql
  CREATE INDEX idx_name
  ON empleados(LastName, FirstName);
  ```

  **Ejemplo: con UNIQUE / Indice Único Compuesto**

  ```sql
  CREATE UNIQUE INDEX idx_name
  ON empleados(LastName, FirstName);
  ```

  Consulta que aprovecha el índice:

  ```sql
  SELECT *
  FROM empleados
  WHERE LastName = 'Silva'
    AND FirstName = 'Flavio';
  ```
---

- **Índice Clusterizado (`Clustered Index`)**
  - Ordena físicamente los **datos** de la tabla según el **índice**.
  - Una **tabla** solo puede tener **un** índice clusterizado.

  **Ejemplo (SQL Server):**
  ```sql
  CREATE CLUSTERED INDEX idx_employee
  ON empleados(EmployeeID);
  ```

  > **Nota:** En **MySQL (InnoDB)**, la `PRIMARY KEY` actúa como el **índice clusterizado**, por lo que normalmente no se crea explícitamente.
---

- **Índice No Clusterizado (`Non-Clustered Index`)**
  - No modifica el orden físico de la **tabla**.
  - Almacena una estructura separada con las **claves indexadas** y referencias a las **filas**.
  - Una **tabla** puede tener **varios** índices no clusterizados.

  **Ejemplo (SQL Server):**
  ```sql
  CREATE NONCLUSTERED INDEX idx_lastname
  ON empleados(LastName);
  ```

  > **Nota:** En **MySQL**, los índices creados con `CREATE INDEX` son **no clusterizados** por defecto (_excepto la `PRIMARY KEY` en InnoDB_).
---

- **Índice de Texto Completo (`FULLTEXT`)**
  - Diseñado para realizar búsquedas de **texto** sobre grandes cantidades de información.
  - Permite búsquedas por **palabras**, **frases** o **relevancia**, siendo más eficiente que `LIKE` en este tipo de consultas.

  **Ejemplo:**
  ```sql
  CREATE FULLTEXT INDEX idx_description
  ON productos(Description);
  ```

  Consulta utilizando el índice:

  ```sql
  SELECT *
  FROM productos
  WHERE MATCH(Description)
  AGAINST ('laptop gamer');
  ```

--- 
## TABLA

## Clasificación de los Índices

| **Criterio** | **¿Qué clasifica?** | **Tipos** |
|---------------|----------------------|-----------|
| **Según la unicidad** | Si permite o no **valores duplicados** en la columna indexada. | `UNIQUE`, `NON UNIQUE` |
| **Según el número de columnas** | La cantidad de **columnas** que forman el índice. | Simple, Compuesto |
| **Según la organización física** | Cómo se almacenan físicamente los **datos** de la tabla con respecto al índice. | Clustered, Non-Clustered |
| **Según su finalidad** | El **propósito** o uso específico del índice. | `PRIMARY KEY`, `FULLTEXT`, `SPATIAL`, etc. |
| **Según la estructura interna** | La **estructura de datos** utilizada por el motor para implementar el índice. | `B-Tree`, `Hash`, `R-Tree`, etc. |

--- 

> **Ver los indices de una tabla en _MySQL_:**   
> ```SQL 
> -- VER LOS INDEX EN MYSQL 
>  SHOW INDEX FROM products;
> ```

> **Consejo de Nombre a Índices:**  
> Puedes llamarlos así: `idx_NameTable_NameField`

> **Si vas a eliminar un Índice**  
> `DROP INDEX idx_NamTable_NameField on NameTable`  
> _Sirve para Índices con UNIQUE también_. 
--- 