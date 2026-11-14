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

# 🟡 2. IFNULL (solo MySQL)

## ¿Qué es?

Función que reemplaza NULL por un valor.

---

## 📌 Sintaxis

```sql
IFNULL(valor, reemplazo)
```

---

## 🔹 Ejemplo

```sql
SELECT IFNULL(price, 0)
FROM products;
```

---

## 🔥 En UPDATE

```sql
UPDATE products
SET price = IFNULL(price, 0) + 10
WHERE ProductID = 1;
```

---

## ⚠️ Importante

- Solo funciona en MySQL
- Solo acepta 2 valores
- Es más simple pero menos portable

---

## ✔ Resumen

- Rápido y fácil
- Solo MySQL
- Reemplaza NULL por un valor

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
| IFNULL | MySQL | No | básico |
| CASE | lógica condicional | Sí (condiciones) | ⭐⭐⭐ potente |

---

# 🧠 CONCLUSIÓN

- Usa **COALESCE** para reemplazar NULL de forma simple
- Usa **IFNULL** si trabajas solo con MySQL y quieres algo rápido
- Usa **CASE** cuando necesitas lógica real (IF/ELSE en SQL)

---

# 🚀 IDEA CLAVE

> COALESCE e IFNULL resuelven NULL  
> CASE resuelve lógica completa
