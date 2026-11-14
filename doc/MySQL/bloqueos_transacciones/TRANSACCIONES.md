# Blue Lock SQL Project

# 🔄 Transacciones (Transactions) en SQL

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
BEGIN
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
BEGIN;

UPDATE cuentas
SET saldo = saldo - 1000
WHERE id = 1;

UPDATE cuentas
SET saldo = saldo + 1000
WHERE id = 2;

COMMIT;
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
BEGIN;

UPDATE cuentas
SET saldo = saldo - 1000
WHERE id = 1;

-- Error inesperado

ROLLBACK;
```

Resultado:

| id | nombre | saldo |
|----|---------|-------|
| 1 | Ana | 5000 |
| 2 | Luis | 3000 |

Todo vuelve al estado anterior.

---

# 🧩 Sentencias principales

---

## BEGIN (o START TRANSACTION)

Inicia una nueva transacción.

```sql
BEGIN;
```

o

```sql
START TRANSACTION;
```

---

## COMMIT

Confirma permanentemente todos los cambios realizados.

```sql
COMMIT;
```

Una vez ejecutado:

- ✔ Los datos quedan guardados.
- ✔ No pueden revertirse mediante ROLLBACK.

---

## ROLLBACK

Cancela todos los cambios realizados desde el inicio de la transacción.

```sql
ROLLBACK;
```

Se utiliza cuando ocurre algún error.

---

# 💾 SAVEPOINT

Permite crear un punto de restauración dentro de una transacción.

---

## Ejemplo

```sql
BEGIN;

UPDATE productos
SET stock = stock - 2
WHERE id = 10;

SAVEPOINT descuento;

UPDATE clientes
SET puntos = puntos + 50
WHERE id = 3;

ROLLBACK TO descuento;

COMMIT;
```

---

## ¿Qué ocurrió?

Se mantiene:

✔ Actualización del stock.

Se deshace:

❌ Actualización de puntos.

---

# 📌 RELEASE SAVEPOINT

Elimina un punto de restauración.

```sql
RELEASE SAVEPOINT descuento;
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

Aquí es donde aparecen los **bloqueos (locks)** y el **MVCC**.

---

## 🅳 Durability (Durabilidad)

Una vez ejecutado:

```sql
COMMIT;
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
COMMIT;
```

o

```sql
ROLLBACK;
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

# 🐬 Nota importante (MySQL)

- En **InnoDB**, las transacciones están completamente soportadas.
- En **MyISAM**, las transacciones **no están soportadas**.
- Si `AUTOCOMMIT = ON` (valor por defecto), cada sentencia SQL se confirma automáticamente.
- Para agrupar varias operaciones en una misma transacción, se utiliza `START TRANSACTION` o `BEGIN`.

---

# ⚙️ AUTOCOMMIT

Por defecto, muchos DBMS (como MySQL) trabajan con:

```sql
AUTOCOMMIT = ON;
```

Esto significa que cada sentencia SQL se confirma automáticamente.

Ejemplo:

```sql
UPDATE empleados
SET salario = salario + 500
WHERE id = 1;
```

Equivale prácticamente a:

```sql
BEGIN;

UPDATE empleados
SET salario = salario + 500
WHERE id = 1;

COMMIT;
```

Si se desea controlar manualmente las transacciones:

```sql
SET AUTOCOMMIT = 0;
```

---

# 🧠 Resumen de comandos

| Comando | Función |
|----------|---------|
| BEGIN / START TRANSACTION | Inicia una transacción |
| COMMIT | Guarda definitivamente los cambios |
| ROLLBACK | Deshace todos los cambios |
| SAVEPOINT | Crea un punto de restauración |
| ROLLBACK TO SAVEPOINT | Regresa a un punto específico |
| RELEASE SAVEPOINT | Elimina un punto de restauración |

---

# 🎯 Resumen final

Una transacción permite ejecutar varias operaciones `SQL` como una única unidad de trabajo, garantizando que la base de datos permanezca consistente incluso cuando ocurren errores.

Gracias a las propiedades **ACID**, las transacciones aseguran que los datos sean confiables, que los cambios sean permanentes una vez confirmados y que múltiples usuarios puedan trabajar simultáneamente sin comprometer la integridad de la información.