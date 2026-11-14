# 🧠 Blue Lock SQL Project

## 🔒 Bloqueos (Locks) en SQL

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

1. Inicia una transacción
2. Solicita un lock
3. El DBMS evalúa si puede concederlo
4. Si está ocupado → espera
5. Al finalizar → se libera con COMMIT o ROLLBACK

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
- Si usa `WRITE` no permite leer
- Si usa `READ` si permite leer 
- En ambos casos no permite `UPDATE | INSERT | DELETE`

**📌 Uso**
- Operaciones masivas
- Sistemas simples
- MyISAM (MySQL)

--- 
**🧪 Ejemplo**

```sql
LOCK TABLES empleados WRITE;
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
LOCK TABLES empleados WRITE;
```
--- 

❌ Otro usuario:

```sql
UPDATE empleados SET salario = 9999 WHERE id = 1;
```
--- 

⛔ Espera hasta liberación.

```sql
UNLOCK TABLES;
```

--- 

### 2. 🔸 Lock de Fila (Row Lock ) o Lock Reservado 

- Bloquea solo filas específicas.
- Normalmente permite lectura. 

**📌 Uso**
- Alta concurrencia
- Sistemas críticos (bancos, stock)
- InnoDB

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

👉 Implicitamente bloquea la fila.

---

## ⚠️ PROBLEMAS DE CONCURRENCIA

### 🔁 Deadlock (Interbloqueo)

Dos transacciones se bloquean entre sí.

**Ejemplo:**

- T1 bloquea fila A → espera B
- T2 bloquea fila B → espera A

⛔ Resultado: ciclo infinito

**🧠 Importante:**

**El DBMS:**

- ✔ detecta deadlock
- ✔ mata una transacción (victim selection)
- ✔ libera recursos automáticamente

### 🧠 Dirty Read / Lectura Sucia 

- Leer datos no confirmados.

### 📉 Lost Update / Actualización Perdida

- Dos usuarios actualizan sin ver cambios del otro.

---

## ⚙️ NIVELES DE AISLAMIENTO (IMPORTANTÍSIMO)

Los locks dependen del nivel de aislamiento:

### 1. READ UNCOMMITTED
- Permite dirty reads
- Sin protección real

### 2. READ COMMITTED
- Evita dirty reads
- Lecturas solo de datos confirmados

### 3. REPEATABLE READ (MySQL default)
- Evita que datos cambien durante la transacción
- Usa MVCC + locks inteligentes

### 4. SERIALIZABLE
- Máximo nivel
- Todo se comporta como ejecución en serie
- Mucho bloqueo

---

## 🧬 MVCC (Multi-Version Concurrency Control)

👉 Usado por InnoDB en MySQL

En vez de bloquear siempre:

- ✔ crea versiones de los datos
- ✔ los lectores no bloquean escritores
- ✔ mejora rendimiento

**📌 Ejemplo conceptual:**

- Usuario A ve versión vieja
- Usuario B modifica
- A sigue viendo su versión

---

## ⚙️ TIPOS DE LOCK EN MYSQL (INNO DB)

- Row-level locks
- Gap locks (bloquea huecos)
- Next-key locks (fila + rango)

👉 Esto evita "phantom reads"

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

## 🐬 NOTA IMPORTANTE (MySQL)

- MyISAM → table locks
- InnoDB → row locks + MVCC
- FOR UPDATE → lock exclusivo de fila
- LOCK IN SHARE MODE → lock compartido

---

## 🧠 RESUMEN FINAL

| Concepto        | Qué hace                          |
|------------------|------------------------------------|
| Table Lock       | Bloquea toda la tabla             |
| Row Lock         | Bloquea filas                     |
| Shared Lock      | Solo lectura                      |
| Exclusive Lock   | Escritura total                   |
| MVCC             | Versiones sin bloqueo agresivo    |

---

## 🔥 CONCLUSIÓN

Los locks no son solo "bloqueos", sino parte de un sistema completo:

👉 Transacciones + aislamiento + MVCC + control de concurrencia

Eso es lo que hace que una base de datos sea confiable en sistemas reales.

--- 