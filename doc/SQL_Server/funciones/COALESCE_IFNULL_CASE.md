# Blue Lock SQL Project

# 🔹 Manejo de NULL en SQL: COALESCE, IFNULL y CASE

Cuando trabajas con bases de datos, uno de los problemas más comunes es el valor `NULL`. Para solucionarlo existen varias formas. Aquí tienes las 3 más importantes.

---

# 🟢 1. COALESCE (RECOMENDADO - estándar SQL)

## ¿Qué es?

`COALESCE` es una función que devuelve el **primer valor que NO sea NULL**.

---

## 📌 Sintaxis

```sql
COALESCE(valor1, valor2, valor3, ...)
```

---

## 🧠 Cómo funciona

- Recorre de izquierda a derecha
- Devuelve el primer valor válido (no NULL)
- Si todos son NULL, devuelve NULL

---

## 🔹 Ejemplos

```sql
SELECT COALESCE(NULL, NULL, 10, 20);
```

Resultado:
```
10
```

---

```sql
SELECT COALESCE(price, 0)
FROM products;
```

| price | resultado |
|------|----------|
| 100  | 100 |
| NULL | 0 |

---

## 🔥 Uso en UPDATE (muy importante)

```sql
UPDATE products
SET price = COALESCE(price, 0) + 10
WHERE ProductID = 1;
```

✔ Si price es NULL → usa 0  
✔ Evita resultados NULL en operaciones

---

## 💡 Uso real más avanzado

```sql
SELECT COALESCE(phone, email, 'Sin contacto')
FROM customers;
```

👉 Devuelve:
- teléfono si existe
- si no, email
- si no, "Sin contacto"

---

## ✔ Resumen

- Estándar SQL (funciona en casi todas las BD)
- Muy flexible
- Puede recibir múltiples valores
- Es la mejor práctica

---

# 🟡 2. ISNULL (solo SQL Server — no es estándar SQL)

## ¿Qué es?

Función que reemplaza NULL por un valor.

> ⚠️ **Importante para SQL Server:** aquí la función se llama **`ISNULL`**, no `IFNULL`. `IFNULL` **no existe** en SQL Server (eso es de MySQL). Y `ISNULL` **no es estándar SQL**: solo acepta 2 argumentos y tiene reglas de tipo propias.

---

## 📌 Sintaxis (SQL Server)

```sql
ISNULL(valor, reemplazo)
```

---

## 🔹 Ejemplo (SQL Server)

```sql
SELECT ISNULL(price, 0)
FROM products;
```

---

## 🔥 En UPDATE (SQL Server)

```sql
UPDATE products
SET price = ISNULL(price, 0) + 10
WHERE ProductID = 1;
```

---

## ✅ Equivalente portable (estándar SQL)

```sql
SELECT COALESCE(price, 0)
FROM products;
```

```sql
UPDATE products
SET price = COALESCE(price, 0) + 10
WHERE ProductID = 1;
```

---

## ⚠️ Importante

- Solo funciona en SQL Server y en Sybase (en MySQL el nombre es `IFNULL`).
- Solo acepta 2 valores.
- **Diferencia de tipos con `COALESCE`:** `ISNULL` toma el tipo del **primer** argumento; `COALESCE` aplica las reglas de precedencia de tipos de SQL Server. Por eso `ISNULL('abc', 1)` devuelve `'abc'` como texto, mientras que `COALESCE('abc', 1)` lanza un error de conversión. Para código portable, preferí `COALESCE`.
- `ISNULL` es una **función**; `IS NULL` es un **operador de comparación**. No los confundas: `WHERE price ISNULL 0` no existe.

---

## ✔ Resumen

- Rápido y fácil en SQL Server.
- **No existe en PostgreSQL** (ahí se usa `COALESCE`).
- Reemplaza NULL por un valor.

---

## 🟣 Extra: NULLIF (estándar SQL)

`NULLIF(valor1, valor2)` hace lo **contrario**: si los dos valores son iguales devuelve `NULL`, y si no, devuelve el primero. Es útil para **evitar divisiones por cero**:

```sql
SELECT total / NULLIF(cantidad, 0) AS precio_unitario
FROM pedidos;
```

Si `cantidad` es `0`, el resultado es `NULL` en lugar de lanzar `Divide by zero error encountered.`

---

# 🔴 3. CASE (condición explícita - más poderoso)

## ¿Qué es?

`CASE` permite crear **condiciones tipo IF/ELSE dentro de SQL**.

Es la opción más flexible.

---

## 📌 Sintaxis básica

```sql
CASE
    WHEN condición THEN resultado
    ELSE otro_resultado
END
```

---

## 🔹 Ejemplo simple

```sql
SELECT 
    price,
    CASE
        WHEN price IS NULL THEN 0
        ELSE price
    END AS price_final
FROM products;
```

---

## 🔹 En UPDATE (caso real importante)

```sql
UPDATE products
SET price = CASE
    WHEN price IS NULL THEN 10
    WHEN price < 0 THEN 0
    ELSE price + 5
END
WHERE ProductID = 1;
```

---

## 🧠 Explicación paso a paso

- Si price es NULL → se convierte en 10
- Si price es negativo → se corrige a 0
- Si no → se suma 5

---

## 🔥 Ejemplo más real (negocio)

```sql
SELECT 
    ProductName,
    price,
    CASE
        WHEN price IS NULL THEN 'Sin precio'
        WHEN price = 0 THEN 'Gratis'
        WHEN price > 100 THEN 'Carísimo'
        ELSE 'Normal'
    END AS categoria
FROM products;
```

---

## ✔ Ventajas

- Muy flexible
- Permite múltiples condiciones
- Funciona en todos los motores SQL

---

## ✔ Resumen

- Es como un IF/ELSE en SQL
- Maneja lógica compleja
- Más potente que COALESCE e IFNULL

---

# ⚖️ COMPARACIÓN FINAL

| Función | Tipo | Soporta múltiples valores | Nivel |
|--------|------|--------------------------|------|
| COALESCE | estándar SQL | Sí | ⭐ recomendado |
| ISNULL | SQL Server (en MySQL es `IFNULL`) | No | básico |
| CASE | lógica condicional | Sí (condiciones) | ⭐⭐⭐ potente |

---

# 🧠 CONCLUSIÓN

- Usa **COALESCE** para reemplazar NULL de forma simple. Es la opción portable y la que funciona también en SQL Server.
- **ISNULL** solo si trabajas con SQL Server; si necesitás portabilidad usá `COALESCE`.
- Usa **CASE** cuando necesitas lógica real (IF/ELSE en SQL).

---

# 🚀 IDEA CLAVE

> COALESCE resuelve NULL de forma portable  
> ISNULL es el atajo de SQL Server  
> CASE resuelve lógica completa
