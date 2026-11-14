# 🧠 Blue Lock SQL Project

## 🔒 Bloqueos (Locks) en PostgreSQL

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

1. Inicia una transacción (`BEGIN;`)
2. Solicita un lock (implícito o explícito)
3. PostgreSQL evalúa si puede concederlo
4. Si está ocupado → espera
5. Al finalizar → se libera con `COMMIT` o `ROLLBACK`

---

## 🔁 TRANSACCIONES (BASE DE TODO)

Un lock nunca existe solo, siempre está dentro de una transacción.

### 🧪 Ejemplo básico

```sql
BEGIN;

UPDATE empleados
SET salario = salario + 500
WHERE id = 1;

COMMIT;
```

### ❌ Si algo falla

```sql
BEGIN;

UPDATE empleados SET salario = salario + 500 WHERE id = 1;

ROLLBACK;
```

👉 Esto deshace todo lo bloqueado/modificado.

---

## 🧱 TIPOS DE BLOQUEOS

### 1. 🔹 Lock de Tabla (Table Lock)

- Bloquea toda la tabla completa.
- En PostgreSQL se pide explícitamente con `LOCK TABLE`.
- `ACCESS EXCLUSIVE` **no permite ni leer ni escribir**.
- `SHARE` permite leer pero **no** escribir.
- `ACCESS SHARE` es el que toma un `SELECT` normal.

**📌 Uso**
- Operaciones masivas
- Migraciones (`ALTER TABLE`)
- Mantenimiento

--- 
**🧪 Ejemplo**

```sql
-- Bloqueo total: nadie más lee ni escribe
LOCK TABLE empleados IN ACCESS EXCLUSIVE MODE;

-- Bloqueo de lectura: otros pueden leer, pero no escribir
LOCK TABLE empleados IN SHARE MODE;
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
LOCK TABLE empleados IN ACCESS EXCLUSIVE MODE;
```
--- 

❌ Otro usuario:

```sql
UPDATE empleados SET salario = 9999 WHERE id = 1;
```
--- 

⛔ Espera hasta liberación.

```sql
COMMIT;  -- o ROLLBACK;
```

> **OJO:** en PostgreSQL los locks de tabla se liberan al terminar la transacción. No existe `UNLOCK TABLES` (eso es de MySQL); se usa `COMMIT` o `ROLLBACK`.

--- 

### 2. 🔸 Lock de Fila (Row Lock) o Lock Reservado 

- Bloquea solo filas específicas.
- Normalmente permite lectura. 

**📌 Uso**
- Alta concurrencia
- Sistemas críticos (bancos, stock)
- Es el modo normal de PostgreSQL

--- 

**🧪 Ejemplo**

```sql
SELECT * FROM empleados
WHERE id = 2
FOR UPDATE;
```

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

**🧪 Ejemplo**

```sql
SELECT * FROM empleados FOR SHARE;
```

> **OJO:** `FOR SHARE` reemplaza al viejo `LOCK IN SHARE MODE` de MySQL. En PostgreSQL moderno **no se usa** `LOCK IN SHARE MODE`.

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
UPDATE empleados
SET salario = salario + 500
WHERE id = 1;
```

👉 Implícitamente bloquea la fila.

### 5. 🔹 Modos de fila en PostgreSQL

| Modo | Qué bloquea | Uso |
|------|-------------|-----|
| `FOR UPDATE` | Bloqueo exclusivo fuerte. | Cuando vas a modificar la fila. |
| `FOR NO KEY UPDATE` | Exclusivo, pero no bloquea las FK que apuntan a la fila. | `UPDATE` normal. |
| `FOR SHARE` | Compartido. Varios pueden leer, nadie escribe. | Lectura consistente. |
| `FOR KEY SHARE` | Compartido débil. | Verificar claves foráneas. |

```sql
SELECT * FROM empleados WHERE id = 2 FOR NO KEY UPDATE;
SELECT * FROM empleados WHERE id = 2 FOR KEY SHARE;
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

**PostgreSQL:**

- ✔ detecta el deadlock
- ✔ aborta **una** de las transacciones (la elige el motor)
- ✔ libera recursos automáticamente
- ✔ la transacción abortada recibe el error `deadlock detected`

> **Tip:** para reducir deadlocks, accedé siempre las filas en el **mismo orden** y mantené las transacciones cortas.

### 🧠 Dirty Read / Lectura Sucia 

- Leer datos no confirmados.
- **En PostgreSQL no ocurre**: el nivel `READ UNCOMMITTED` se trata internamente como `READ COMMITTED`.

### 📉 Lost Update / Actualización Perdida

- Dos usuarios actualizan sin ver cambios del otro.

---

## ⚙️ NIVELES DE AISLAMIENTO (IMPORTANTÍSIMO)

Los locks dependen del nivel de aislamiento:

### 1. READ UNCOMMITTED
- En el estándar permite dirty reads.
- **En PostgreSQL se comporta igual que `READ COMMITTED`** (no permite dirty reads).

### 2. READ COMMITTED (default de PostgreSQL)
- Evita dirty reads.
- Lecturas solo de datos confirmados.
- Cada sentencia ve una foto nueva de los datos.

### 3. REPEATABLE READ
- Evita que datos cambien durante la transacción.
- Usa MVCC.
- En PostgreSQL **sí evita phantom reads** (a diferencia de MySQL).

### 4. SERIALIZABLE
- Máximo nivel.
- Todo se comporta como ejecución en serie.
- Usa **SSI** (Serializable Snapshot Isolation) y puede abortar transacciones con `could not serialize access`.

```sql
BEGIN ISOLATION LEVEL SERIALIZABLE;
-- ...
COMMIT;
```

---

## 🧬 MVCC (Multi-Version Concurrency Control)

👉 PostgreSQL usa MVCC de forma **nativa** en todas las tablas.

En vez de bloquear siempre:

- ✔ crea versiones de los datos
- ✔ los lectores no bloquean escritores
- ✔ mejora rendimiento

**📌 Ejemplo conceptual:**

- Usuario A ve versión vieja
- Usuario B modifica
- A sigue viendo su versión

> **Diferencia con MySQL:** PostgreSQL no tiene un motor transaccional alternativo (no hay InnoDB vs MyISAM). El `VACUUM` se encarga de limpiar las versiones viejas que ya nadie usa.

---

## ⚙️ TIPOS DE LOCK EN POSTGRESQL

- **Row-level locks**: `FOR UPDATE`, `FOR NO KEY UPDATE`, `FOR SHARE`, `FOR KEY SHARE`.
- **Table-level locks**: `ACCESS SHARE`, `ROW SHARE`, `ROW EXCLUSIVE`, `SHARE UPDATE EXCLUSIVE`, `SHARE`, `SHARE ROW EXCLUSIVE`, `EXCLUSIVE`, `ACCESS EXCLUSIVE`.
- **Advisory locks**: locks "de aplicación" que no dependen de una tabla.

```sql
-- Lock de aplicación (útil para coordinar procesos)
SELECT pg_advisory_lock(12345);
SELECT pg_advisory_unlock(12345);
```

> **OJO:** PostgreSQL **no tiene gap locks ni next-key locks** (eso es de InnoDB). Para evitar phantom reads usa `SERIALIZABLE` o `SELECT ... FOR UPDATE` sobre el rango que te interesa.

---

## 🔍 Ver los locks activos

```sql
SELECT
    l.pid,
    a.usename,
    l.locktype,
    l.mode,
    l.granted,
    a.query
FROM pg_locks l
JOIN pg_stat_activity a ON a.pid = l.pid
ORDER BY l.pid;
```

```sql
-- Ver si hay esperas
SELECT * FROM pg_stat_activity WHERE wait_event_type = 'Lock';
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

## 🐘 NOTA IMPORTANTE (PostgreSQL)

- Todas las tablas → row locks + MVCC.
- `FOR UPDATE` → lock exclusivo de fila.
- `FOR SHARE` → lock compartido (reemplaza a `LOCK IN SHARE MODE`).
- `LOCK TABLE` → lock de tabla explícito.
- `pg_advisory_lock` → lock de aplicación.
- No hay gap locks ni next-key locks.
- El nivel por defecto es `READ COMMITTED`.

---

## 🧠 RESUMEN FINAL

| Concepto        | Qué hace                          |
|------------------|------------------------------------|
| Table Lock       | Bloquea toda la tabla             |
| Row Lock         | Bloquea filas                     |
| Shared Lock      | Solo lectura                      |
| Exclusive Lock   | Escritura total                   |
| MVCC             | Versiones sin bloqueo agresivo    |
| Advisory Lock    | Lock de aplicación                |

---

## 🔥 CONCLUSIÓN

Los locks no son solo "bloqueos", sino parte de un sistema completo:

👉 Transacciones + aislamiento + MVCC + control de concurrencia

Eso es lo que hace que una base de datos sea confiable en sistemas reales.

---
