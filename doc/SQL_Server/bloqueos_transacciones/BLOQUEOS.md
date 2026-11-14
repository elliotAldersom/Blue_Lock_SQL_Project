# 🧠 Blue Lock SQL Project

## 🔒 Bloqueos (Locks) en SQL Server

### 📖 Definición 🤓

Los bloqueos (locks) son mecanismos utilizados por los sistemas de gestión de bases de datos (DBMS) para controlar el acceso concurrente a los datos, evitando inconsistencias cuando múltiples usuarios leen o modifican la misma información al mismo tiempo.

> 👉 En simple: Un bloqueo asegura que los datos no sean modificados de forma conflictiva mientras otra operación los está usando.

--- 
### 🧠 ¿Por qué existen los bloqueos? 🤔

En sistemas con múltiples usuarios (bancos, apps web, e-commerce), muchas operaciones ocurren al mismo tiempo.

Sin bloqueos pueden aparecer problemas como:

- 🔁 Datos sobrescritos (lost update)
- 💰 Doble pago o doble descuento
- 📉 Lecturas incorrectas (dirty reads)
- ❌ Inconsistencia general de datos

--- 

### ⚙️ ¿Cómo funcionan los bloqueos?

Cuando una transacción accede a datos:

1. Inicia una transacción (`BEGIN TRANSACTION;`)
2. Solicita un lock (implícito o explícito)
3. El motor evalúa si puede concederlo
4. Si está ocupado → espera
5. Al finalizar → se libera con `COMMIT` o `ROLLBACK`

--- 

## 🔁 TRANSACCIONES (BASE DE TODO)

Un lock nunca existe solo, siempre está dentro de una transacción.

### 🧪 Ejemplo básico

```sql
BEGIN TRANSACTION;

UPDATE empleados
SET salario = salario + 500
WHERE id = 1;

COMMIT TRANSACTION;
```

### ❌ Si algo falla

```sql
BEGIN TRANSACTION;

UPDATE empleados SET salario = salario + 500 WHERE id = 1;

ROLLBACK TRANSACTION;
```

👉 Esto deshace todo lo bloqueado/modificado.

--- 

## 🧱 TIPOS DE BLOQUEOS

### 1. 🔹 Lock de Tabla (Table Lock)

- Bloquea toda la tabla completa.
- En SQL Server **no existe `LOCK TABLE`** (eso es de PostgreSQL). Se pide con **hints** dentro de la consulta: `WITH (TABLOCK)` o `WITH (TABLOCKX)`.
- `TABLOCKX` **no permite ni leer ni escribir**.
- `TABLOCK` es un bloqueo **compartido** de tabla: bloquea escrituras, permite lecturas.
- El motor puede **escalar** los bloqueos de fila a tabla cuando una sola sentencia toca demasiadas filas (`LOCK_ESCALATION`).

**📌 Uso**
- Operaciones masivas
- Migraciones (`ALTER TABLE`)
- Mantenimiento

--- 
**🧪 Ejemplo**

```sql
-- Bloqueo total: nadie más lee ni escribe
SELECT * FROM empleados WITH (TABLOCKX);

-- Bloqueo de lectura: otros pueden leer, pero no escribir
SELECT * FROM empleados WITH (TABLOCK);

-- Igual que TABLOCK, pero se mantiene hasta el final de la transacción
SELECT * FROM empleados WITH (TABLOCK, HOLDLOCK);
```
--- 

**📊 Ejemplo visual**

| id | nombre | salario |
|----|--------|---------|
| 1  | Ana    | 2000    |
| 2  | Luis   | 2500    |
| 3  | Carla  | 3000    |

--- 
**🔒 Bloqueo activo**

```sql
BEGIN TRANSACTION;
SELECT * FROM empleados WITH (TABLOCKX);
-- ...
```
--- 

❌ Otro usuario:

```sql
UPDATE empleados SET salario = 9999 WHERE id = 1;
```
--- 

⛔ Espera hasta liberación.

```sql
COMMIT TRANSACTION;  -- o ROLLBACK TRANSACTION;
```

> **OJO:** en SQL Server los locks de tabla se liberan al terminar la transacción. **No existe `UNLOCK TABLES`** (eso es de MySQL); se usa `COMMIT` o `ROLLBACK`, o el fin de la sentencia si no hay transacción explícita.

--- 

### 2. 🔸 Lock de Fila (Row Lock) o Lock Reservado 

- Bloquea solo filas específicas.
- **Por defecto** SQL Server bloquea a nivel de **fila o de página**, no de tabla. El motor decide y puede escalar.
- Normalmente permite lectura. 

**📌 Uso**
- Alta concurrencia
- Sistemas críticos (bancos, stock)
- Es el modo normal de SQL Server

--- 

**🧪 Ejemplo**

```sql
BEGIN TRANSACTION;

SELECT *
FROM empleados WITH (UPDLOCK, ROWLOCK)
WHERE id = 2;

-- ...
COMMIT TRANSACTION;
```

> **OJO:** en SQL Server **no existe `FOR UPDATE`** (eso es de PostgreSQL). El equivalente es el hint **`WITH (UPDLOCK)`**: toma un bloqueo de actualización (U), que impide que otro lo modifique pero no bloquea a los lectores.

--- 

**📊 Visual**

Solo queda bloqueado:

| id | nombre    | salario |
|----|-----------|---------|
| 2  | Luis 🔒   | 2500   |

--- 

❌ Otro usuario:

```sql
UPDATE empleados SET salario = 9999 WHERE id = 2;
```

⛔ Espera liberación

--- 

### 3. 🔹 Lock Compartido (Shared Lock)

Permite lecturas simultáneas pero bloquea escrituras.

En SQL Server **los `SELECT` normales ya toman locks compartidos (`S`)** en el nivel de aislamiento `READ COMMITTED`, pero se liberan **al terminar la sentencia**, no al terminar la transacción. Para que se mantengan, usá `HOLDLOCK` o `REPEATABLEREAD`.

**🧪 Ejemplo**

```sql
BEGIN TRANSACTION;

-- Mantiene el lock compartido hasta el COMMIT
SELECT * FROM empleados WITH (HOLDLOCK);

COMMIT TRANSACTION;
```

> **OJO:** `HOLDLOCK` es equivalente a `SERIALIZABLE` para esa tabla, así que bloquea bastante. Si lo que querés es solo "no me cambien las filas leídas", usá `WITH (REPEATABLEREAD)`.

--- 

**📊 Resultado**

| Usuario | SELECT | UPDATE |
|---------|--------|--------|
| A       | ✔      | ❌     |
| B       | ✔      | ❌     |

--- 

### 4. 🔸 Lock Exclusivo

Solo una transacción puede modificar. Los demás podrían leer pero no modificar. 

```sql
BEGIN TRANSACTION;

UPDATE empleados
SET salario = salario + 500
WHERE id = 1;

COMMIT TRANSACTION;
```

👉 Implícitamente bloquea la fila con un lock **`X`**.

### 5. 🔹 Modos de bloqueo en SQL Server

| Modo | Qué bloquea | Uso |
|------|-------------|-----|
| `S` (Shared) | Compartido: varios leen, nadie escribe. | `SELECT` normal. |
| `X` (Exclusive) | Exclusivo: nadie lee ni escribe. | `INSERT`, `UPDATE`, `DELETE`. |
| `U` (Update) | Bloqueo intermedio, evita deadlocks en conversiones `S → X`. | `WITH (UPDLOCK)`. |
| `I` (Intent) | Aviso de que hay un lock más fino abajo. | Interno del motor. |
| `Sch-S` / `Sch-M` | Bloqueo de **esquema**: impide cambiar la estructura de la tabla. | `ALTER TABLE`, `DROP TABLE`. |
| **Key-Range** | Bloqueo de **rango de claves**: evita phantom reads. | `SERIALIZABLE` con índice. |

```sql
-- Bloqueo exclusivo explícito de la fila
SELECT * FROM empleados WITH (XLOCK, ROWLOCK) WHERE id = 2;

-- Bloqueo de actualización (lo que en PostgreSQL es FOR UPDATE)
SELECT * FROM empleados WITH (UPDLOCK, ROWLOCK) WHERE id = 2;
```

---

## ⚠️ PROBLEMAS DE CONCURRENCIA

### 🔁 Deadlock (Interbloqueo)

Dos transacciones se bloquean entre sí.

**Ejemplo:**

- T1 bloquea fila A → espera B
- T2 bloquea fila B → espera A

⛔ Resultado: ciclo infinito

**🧠 Importante:**

**SQL Server:**

- ✔ detecta el deadlock con el **monitor de deadlocks** (cada 5 segundos)
- ✔ aborta **una** de las transacciones (la elige el motor por costo)
- ✔ libera recursos automáticamente
- ✔ la transacción abortada recibe el error **1205**: `Transaction was deadlocked on lock resources with another process and has been chosen as the deadlock victim.`
- ✔ podés influir con `SET DEADLOCK_PRIORITY LOW | NORMAL | HIGH`

```sql
SET DEADLOCK_PRIORITY LOW;   -- esta sesión pierde primero
```

> **Tip:** para reducir deadlocks, accedé siempre las filas en el **mismo orden** y mantené las transacciones cortas. Y usá `SET XACT_ABORT ON;` para que un error no deje la transacción abierta.

### 🧠 Dirty Read / Lectura Sucia 

- Leer datos no confirmados.
- **En SQL Server sí puede ocurrir**, a diferencia de PostgreSQL: el nivel `READ UNCOMMITTED` (o el hint `WITH (NOLOCK)`) permite leer datos no confirmados.

```sql
-- Lecturas sucias: NO usar en producción salvo casos muy justificados
SELECT * FROM empleados WITH (NOLOCK);
```

> **OJO:** `NOLOCK` no bloquea, pero puede devolver datos que después se revierten (*dirty reads*), filas duplicadas o filas que se saltean. Se usa como "último recurso" en reportes.

### 📉 Lost Update / Actualización Perdida

- Dos usuarios actualizan sin ver cambios del otro.

--- 

## ⚙️ NIVELES DE AISLAMIENTO (IMPORTANTÍSIMO)

Los locks dependen del nivel de aislamiento:

### 1. READ UNCOMMITTED
- Permite dirty reads.
- **En SQL Server sí permite dirty reads** (no lo trata como READ COMMITTED).
- Solo se usa con `WITH (NOLOCK)` o para reportes que toleran datos sucios.

### 2. READ COMMITTED (default de SQL Server)
- Evita dirty reads.
- Lecturas solo de datos confirmados.
- Cada sentencia toma locks compartidos que **se liberan al terminar la sentencia**.
- Es el nivel por defecto de SQL Server.

### 3. REPEATABLE READ
- Evita que datos cambien durante la transacción: mantiene los locks compartidos hasta el `COMMIT`.
- **No evita phantom reads**.

### 4. SERIALIZABLE
- Máximo nivel.
- Todo se comporta como ejecución en serie.
- Usa **bloqueos de rango de claves** (*key-range locks*) y puede generar más deadlocks.
- Evita phantom reads **si hay un índice** sobre la columna filtrada.

### 5. SNAPSHOT
- **Nivel propio de SQL Server**, no existe en el estándar.
- Usa versiones de fila (MVCC) en `tempdb`: los lectores **no bloquean** a los escritores.
- Requiere habilitarlo con `ALTER DATABASE ... SET ALLOW_SNAPSHOT_ISOLATION ON;`.

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
-- ...
COMMIT TRANSACTION;
```

```sql
-- Nivel recomendado para reportes en bases con mucha concurrencia
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
```

> **OJO:** SQL Server **tiene MVCC, pero es opt-in**. El equivalente a lo que PostgreSQL hace siempre es **READ COMMITTED SNAPSHOT (RCSI)**, que se habilita por base de datos:
> ```sql
> ALTER DATABASE tienda SET READ_COMMITTED_SNAPSHOT ON;
> ```

--- 

## 🧬 MVCC (Multi-Version Concurrency Control)

👉 SQL Server **sí tiene MVCC, pero no lo usa por defecto** (a diferencia de PostgreSQL, que lo usa siempre).

En vez de bloquear siempre:

- ✔ crea versiones de los datos en `tempdb`
- ✔ los lectores no bloquean escritores *(si RCSI o SNAPSHOT están habilitados)*
- ✔ mejora rendimiento en cargas de mucha lectura

**📌 Ejemplo conceptual:**

- Usuario A ve versión vieja
- Usuario B modifica
- A sigue viendo su versión

> **Diferencia con PostgreSQL:** en SQL Server el versionado es **opcional** y vive en `tempdb`. Si no habilitás RCSI ni `ALLOW_SNAPSHOT_ISOLATION`, el motor **bloquea lectores contra escritores**. No existe `VACUUM`: las versiones de `tempdb` las limpia el motor solo.

--- 

## ⚙️ TIPOS DE LOCK EN SQL SERVER

- **Row / Page / Extent / Table / Database level**: el motor elige la granularidad y puede escalar de fila a tabla.
- **Lock modes**: `S`, `X`, `U`, `IS`, `IX`, `SIX`, `Sch-S`, `Sch-M`, `key-range`.
- **Application locks**: locks "de aplicación" que no dependen de una tabla. Se piden con `sp_getapplock`.

```sql
-- Lock de aplicación (útil para coordinar procesos)
EXEC sp_getapplock @Resource = 'proceso_cierre_mes',
                   @LockMode = 'Exclusive',
                   @LockOwner = 'Transaction';

EXEC sp_releaseapplock @Resource = 'proceso_cierre_mes';
```

> **OJO:** los **key-range locks** son el equivalente a los *gap locks* / *next-key locks* de MySQL InnoDB. En SQL Server solo aparecen en `SERIALIZABLE` y necesitan un índice sobre la columna. En niveles inferiores puede haber **phantom reads**.

> **OJO:** SQL Server **escala bloqueos** automáticamente cuando una sentencia toca más de ~5000 filas de una sola tabla. Si eso te perjudica, se desactiva por tabla: `ALTER TABLE empleados SET (LOCK_ESCALATION = DISABLE);`

--- 

## 🔍 Ver los locks activos

```sql
SELECT
    request_session_id   AS session_id,
    resource_type,
    resource_description,
    request_mode,
    request_status
FROM sys.dm_tran_locks
WHERE resource_database_id = DB_ID()
ORDER BY request_session_id;
```

```sql
-- Ver si hay esperas
SELECT
    session_id,
    blocking_session_id,
    wait_type,
    wait_time,
    wait_resource,
    command
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
```

```sql
-- Vista clásica de sesiones y bloqueos
EXEC sp_who2;
```

```sql
-- Evitar esperar para siempre por un lock
SET LOCK_TIMEOUT 5000;   -- 5 segundos; si no consigue el lock, error 1222
```

--- 

## 📌 CASOS DE USO REALES

- ✔ Bancos (transferencias)
- ✔ E-commerce (stock limitado)
- ✔ Reservas (hoteles/vuelos)
- ✔ Sistemas de pagos
- ✔ Inventarios

--- 

## ⚙️ IMPORTANCIA

Los locks garantizan:

- 🛡 Integridad de datos
- ⚡ Concurrencia segura
- 💳 Transacciones confiables
- 🔄 Consistencia en sistemas reales

--- 

## 🐘 NOTA IMPORTANTE (SQL Server)

- Todas las tablas → row locks + **MVCC opcional** (RCSI / SNAPSHOT).
- `WITH (UPDLOCK)` → lock de actualización de fila (equivalente a `FOR UPDATE` de PostgreSQL).
- `WITH (HOLDLOCK)` → mantiene el lock compartido hasta el `COMMIT` (más cercano a `FOR SHARE`).
- `WITH (TABLOCKX)` → lock de tabla exclusivo (equivalente a `LOCK TABLE ... IN ACCESS EXCLUSIVE MODE`).
- `sp_getapplock` → lock de aplicación (equivalente a `pg_advisory_lock`).
- **Sí hay key-range locks** en `SERIALIZABLE` (equivalente a los gap locks de MySQL); no existen como modo independiente.
- El nivel por defecto es `READ COMMITTED`, **sin** snapshot isolation.

--- 

## 🧠 RESUMEN FINAL

| Concepto        | Qué hace                          |
|------------------|------------------------------------|
| Table Lock       | Bloquea toda la tabla             |
| Row Lock         | Bloquea filas                     |
| Shared Lock      | Solo lectura                      |
| Exclusive Lock   | Escritura total                   |
| Update Lock (U)  | Evita deadlocks en lecturas-para-modificar |
| MVCC (RCSI/SNAPSHOT) | Versiones sin bloqueo agresivo (opcional) |
| Application Lock | Lock de aplicación                |

--- 

## 🔥 CONCLUSIÓN

Los locks no son solo "bloqueos", sino parte de un sistema completo:

👉 Transacciones + aislamiento + versionado opcional + control de concurrencia

Eso es lo que hace que una base de datos sea confiable en sistemas reales.

---
