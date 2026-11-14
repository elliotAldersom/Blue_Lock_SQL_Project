# Blue Lock SQL Project

# 🔄 Transacciones (Transactions) en SQL Server

---

## 📖 Definición 🤓

Una **transacción** es un conjunto de una o más operaciones `SQL` que se ejecutan como **una única unidad lógica de trabajo**.

Su objetivo es garantizar que los datos permanezcan **consistentes e íntegros**, incluso cuando ocurren errores o fallos durante la ejecución.

> 👉 **En simple:** Una transacción hace que todas las operaciones se ejecuten correctamente o que ninguna tenga efecto.

---

## 🧠 ¿Por qué existen las transacciones? 🤔

En muchos sistemas, una sola operación requiere modificar varias tablas o registros.

Por ejemplo:

- 💳 Transferencias bancarias
- 🛒 Compras en línea
- 📦 Actualización de inventario
- 📝 Registro de matrículas
- 🏨 Reservas de hoteles

Si una de las operaciones falla, sería un problema que las demás sí se ejecutaran.

Las transacciones evitan este tipo de inconsistencias.

---

## ⚙️ ¿Cómo funciona una transacción?

Una transacción sigue normalmente este flujo:

```text
BEGIN TRANSACTION
   ↓
Ejecutar operaciones SQL
   ↓
¿Todo salió bien?
   ↓
Sí -----------> COMMIT
No -----------> ROLLBACK
```

---

## 📌 Ejemplo sencillo

Supongamos la siguiente tabla.

| id | nombre | saldo |
|----|---------|-------|
| 1 | Ana | 5000 |
| 2 | Luis | 3000 |

Ana desea transferir **1000** a Luis.

---

### Sin transacción

```sql
UPDATE cuentas
SET saldo = saldo - 1000
WHERE id = 1;

-- ocurre un error aquí

UPDATE cuentas
SET saldo = saldo + 1000
WHERE id = 2;
```

Resultado:

| id | nombre | saldo |
|----|---------|-------|
| 1 | Ana | 4000 |
| 2 | Luis | 3000 |

❌ Se perdió dinero.

---

### Con transacción

```sql
BEGIN TRANSACTION;

UPDATE cuentas
SET saldo = saldo - 1000
WHERE id = 1;

UPDATE cuentas
SET saldo = saldo + 1000
WHERE id = 2;

COMMIT TRANSACTION;
```

Resultado:

| id | nombre | saldo |
|----|---------|-------|
| 1 | Ana | 4000 |
| 2 | Luis | 4000 |

✔ Transferencia correcta.

---

## ❌ ¿Qué ocurre si algo falla?

Si durante la transacción ocurre un error:

```sql
BEGIN TRANSACTION;

UPDATE cuentas
SET saldo = saldo - 1000
WHERE id = 1;

-- Error inesperado

ROLLBACK TRANSACTION;
```

Resultado:

| id | nombre | saldo |
|----|---------|-------|
| 1 | Ana | 5000 |
| 2 | Luis | 3000 |

Todo vuelve al estado anterior.

> **OJO (muy importante):** en SQL Server, si `XACT_ABORT` está en `OFF` (el default), **no todos los errores cierran la transacción automáticamente**. Podés quedar con una transacción abierta y bloqueando filas. Por eso conviene escribir `SET XACT_ABORT ON;` al inicio del lote o del procedimiento.

```sql
SET XACT_ABORT ON;
```

---

# 🧩 Sentencias principales

---

## BEGIN TRANSACTION

Inicia una nueva transacción.

```sql
BEGIN TRANSACTION;
```

o su forma corta:

```sql
BEGIN TRAN;
```

> **OJO:** `BEGIN` a secas **no es una transacción**: abre un bloque de código. La transacción se abre con **`BEGIN TRANSACTION`**. Y `START TRANSACTION` (MySQL/PostgreSQL) **no existe** en SQL Server.

---

## COMMIT

Confirma permanentemente todos los cambios realizados.

```sql
COMMIT TRANSACTION;
```

Una vez ejecutado:

- ✔ Los datos quedan guardados.
- ✔ No pueden revertirse mediante ROLLBACK.

> **OJO (transacciones anidadas):** `BEGIN TRANSACTION` incrementa `@@TRANCOUNT`. Un `COMMIT` lo decrementa, pero **solo el último confirma** realmente los datos. Un `ROLLBACK` revierte **todo**, sin importar cuántos `BEGIN` haya.

---

## ROLLBACK

Cancela todos los cambios realizados desde el inicio de la transacción.

```sql
ROLLBACK TRANSACTION;
```

Se utiliza cuando ocurre algún error.

---

# 💾 SAVE TRANSACTION

Permite crear un punto de restauración dentro de una transacción.

En SQL Server **no existe `SAVEPOINT`** (eso es de MySQL y PostgreSQL). Se llama **`SAVE TRANSACTION`**.

---

## Ejemplo

```sql
BEGIN TRANSACTION;

UPDATE productos
SET stock = stock - 2
WHERE id = 10;

SAVE TRANSACTION descuento;

UPDATE clientes
SET puntos = puntos + 50
WHERE id = 3;

ROLLBACK TRANSACTION descuento;

COMMIT TRANSACTION;
```

---

## ¿Qué ocurrió?

Se mantiene:

✔ Actualización del stock.

Se deshace:

❌ Actualización de puntos.

> **OJO:** `ROLLBACK TRANSACTION nombre_savepoint` **no** cierra la transacción: vuelve al punto y la transacción sigue abierta. Hay que terminarla con `COMMIT` o con `ROLLBACK` completo.

---

# 📌 RELEASE SAVEPOINT

Elimina un punto de restauración.

En SQL Server **no existe `RELEASE SAVEPOINT`**. Los savepoints se descartan solos al hacer `COMMIT` (o al hacer `ROLLBACK` completo). No hace falta liberarlos a mano.

```sql
-- En PostgreSQL sería:
-- RELEASE SAVEPOINT descuento;

-- En SQL Server simplemente no existe ese comando.
```

---

# 🧠 Propiedades ACID

Toda transacción debe cumplir las propiedades ACID.

---

## 🅰 Atomicity (Atomicidad)

La transacción ocurre completamente o no ocurre.

No existen resultados parciales.

---

### Ejemplo

Transferencia bancaria.

- Descontar dinero.
- Depositar dinero.

Si falla una operación:

✔ Ambas se cancelan.

---

## 🅲 Consistency (Consistencia)

La base de datos siempre debe permanecer válida.

Antes:

```
Saldo total = 8000
```

Después:

```
Saldo total = 8000
```

Nunca deben perderse datos.

---

## 🅸 Isolation (Aislamiento)

Las transacciones no interfieren entre sí.

Mientras una está trabajando:

- Otra debe esperar o trabajar con una versión consistente de los datos.

Aquí es donde aparecen los **bloqueos (locks)** y el **versionado de filas** (RCSI / SNAPSHOT).

---

## 🅳 Durability (Durabilidad)

Una vez ejecutado:

```sql
COMMIT TRANSACTION;
```

Los datos permanecen guardados incluso si ocurre:

- apagón
- reinicio del servidor
- caída del sistema

---

# 🔒 Relación entre Transacciones y Locks

Los bloqueos forman parte del funcionamiento de las transacciones.

Cuando una transacción modifica datos:

1. Se bloquean los registros necesarios.
2. Otras transacciones deben esperar si existe conflicto.
3. Al ejecutar:

```sql
COMMIT TRANSACTION;
```

o

```sql
ROLLBACK TRANSACTION;
```

los bloqueos se liberan.

---

# ⚠️ Problemas que resuelven

Las transacciones ayudan a evitar:

- Dirty Read
- Lost Update
- Inconsistent Read
- Escrituras parciales
- Corrupción de datos
- Errores por concurrencia

---

# 📌 Casos de uso reales

- 💳 Transferencias bancarias
- 🛒 Compras por Internet
- 📦 Gestión de inventario
- 🏨 Reservas de hoteles
- ✈ Compra de boletos
- 🎓 Matrículas universitarias
- 🏥 Sistemas hospitalarios

---

# 🐘 Nota importante (SQL Server)

- **Todas las tablas de SQL Server son transaccionales** (no existe algo como MyISAM). Incluso el **DDL es transaccional**: un `CREATE TABLE` o un `ALTER TABLE` puede revertirse con `ROLLBACK`.
- SQL Server **tiene MVCC, pero es opcional**: se activa con `READ_COMMITTED_SNAPSHOT` o `ALLOW_SNAPSHOT_ISOLATION`.
- Por defecto, cada sentencia SQL se confirma automáticamente (**autocommit**). Se puede cambiar con `SET IMPLICIT_TRANSACTIONS ON;`.
- Para agrupar varias operaciones en una misma transacción, se utiliza `BEGIN TRANSACTION;` (o `BEGIN TRAN;`).
- El nivel de aislamiento por defecto es **`READ COMMITTED`**.
- Los procedimientos almacenados **pueden** hacer `COMMIT`/`ROLLBACK`; las funciones **no deberían** (SQL Server lo permite, pero rompe la semántica de una función).
- Para dejar constancia de un error, usá `TRY ... CATCH` + `THROW`.

---

# ⚙️ AUTOCOMMIT

Por defecto, SQL Server trabaja en modo **autocommit**:

```sql
-- Cada sentencia se confirma sola
UPDATE empleados
SET salario = salario + 500
WHERE id = 1;
```

Eso equivale prácticamente a:

```sql
BEGIN TRANSACTION;

UPDATE empleados
SET salario = salario + 500
WHERE id = 1;

COMMIT TRANSACTION;
```

> **OJO:** SQL Server **no tiene** el comando `SET AUTOCOMMIT = 0;` (eso es de MySQL). Lo que tiene es `SET IMPLICIT_TRANSACTIONS`, que hace lo contrario: **abre una transacción implícita** antes de cada sentencia y la deja abierta hasta que vos hagas `COMMIT` o `ROLLBACK`.

```sql
-- Activar transacciones implícitas en la sesión
SET IMPLICIT_TRANSACTIONS ON;

-- Volver al modo autocommit
SET IMPLICIT_TRANSACTIONS OFF;
```

Con `IMPLICIT_TRANSACTIONS` activado, cada `SELECT`/`INSERT`/`UPDATE`/`DELETE` abre una transacción que queda abierta hasta que ejecutes `COMMIT;` o `ROLLBACK;`. **Ojo:** si te olvidás de cerrarla, bloqueás la tabla para los demás.

También podés abrir una transacción explícita en cualquier cliente:

```sql
BEGIN TRANSACTION;

UPDATE empleados
SET salario = salario + 500
WHERE id = 1;

COMMIT TRANSACTION;
```

### Manejo de errores con TRY ... CATCH

La forma recomendada en SQL Server:

```sql
SET XACT_ABORT ON;
BEGIN TRY
    BEGIN TRANSACTION;

        UPDATE cuentas SET saldo = saldo - 1000 WHERE id = 1;
        UPDATE cuentas SET saldo = saldo + 1000 WHERE id = 2;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;   -- relanza el error original
END CATCH
```

> **OJO:** `@@TRANCOUNT` indica cuántas transacciones hay abiertas en la sesión. Es la forma correcta de saber si hace falta `ROLLBACK` dentro del `CATCH`.

---

# 🧠 Resumen de comandos

| Comando | Función |
|----------|---------|
| BEGIN TRANSACTION / BEGIN TRAN | Inicia una transacción |
| COMMIT / COMMIT TRANSACTION | Guarda definitivamente los cambios |
| ROLLBACK / ROLLBACK TRANSACTION | Deshace todos los cambios |
| SAVE TRANSACTION | Crea un punto de restauración *(no existe `SAVEPOINT`)* |
| ROLLBACK TRANSACTION savepoint | Regresa a un punto específico |
| TRY ... CATCH | Captura errores para hacer `ROLLBACK` controlado |

---

# 🎯 Resumen final

Una transacción permite ejecutar varias operaciones `SQL` como una única unidad de trabajo, garantizando que la base de datos permanezca consistente incluso cuando ocurren errores.

Gracias a las propiedades **ACID**, las transacciones aseguran que los datos sean confiables, que los cambios sean permanentes una vez confirmados y que múltiples usuarios puedan trabajar simultáneamente sin comprometer la integridad de la información.

> **Diferencia clave con PostgreSQL y MySQL:** SQL Server usa `BEGIN TRANSACTION` (no `BEGIN` ni `START TRANSACTION`), `SAVE TRANSACTION` en lugar de `SAVEPOINT`, no tiene `RELEASE SAVEPOINT`, y el autocommit se controla con `SET IMPLICIT_TRANSACTIONS` (no con `SET AUTOCOMMIT`).
