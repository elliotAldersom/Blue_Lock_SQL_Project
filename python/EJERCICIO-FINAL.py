import mysql.connector 
import pandas as pd 
import matplotlib.pyplot as plt

try: 
    cnx = mysql.connector.connect(
        host = "127.0.0.1",
        port = "3307",
        user = "root",
        password = "root",
        database = "northwind"
    )

    # Con esto vemos a los productos más rentables
    query1 = """
    select p.ProductName, (p.price * sum(od.Quantity)) as revenue
    from products as p 
    inner join orderdetails as od 
    on p.ProductID = od.ProductID 
    group by p.ProductID
    having revenue = (
        select max(total2) 
        from(
        select (p.price * sum(od.Quantity)) as total2
        from products as p 
        inner join orderdetails as od 
        on od.ProductID = p.ProductID 
        group by p.ProductID 
        ) as t
    ) """

    # Vemos los 10 productos con más ingresos (revenue)
    query2 = """
    select p.ProductName, (p.price * sum(od.Quantity)) as revenue
    from products as p 
    inner join orderdetails as od 
    on p.ProductID = od.ProductID 
    group by p.ProductID
    order by revenue desc 
    limit 10
    """

    # Hacer Gráfico
    top_products = pd.read_sql_query(query2,cnx)

    top_products.plot(x="ProductName", y="revenue", kind="bar", figsize=(10,5), legend=False)

    plt.title("10 Productos Más Rentables")
    plt.xlabel("Productos")
    plt.ylabel("Revenue")
    plt.xticks(rotation= 90)

    # Ver los 10 empleados más efectivo
    query3 = """ 
    select concat(e.FirstName, ' ' , e.LastName) as FullName, count(*) as N_Orders
    from employees as e 
    inner join orders as o
    on e.EmployeeID = o.EmployeeID 
    group by e.EmployeeID
    order by N_Orders desc
    limit 10
"""
    # Gráfico 
    top_employees = pd.read_sql_query(query3, cnx) 

    top_employees.plot(x="FullName", y="N_Orders", kind="bar", figsize=(10,5), legend=False)

    plt.title("Los empleados y sus ordenes atendidas")
    plt.xlabel("Nombre Empleado")
    plt.ylabel("Ordenes Atendidas")
    plt.xticks(rotation = 45)
    plt.show()

except mysql.connector.Error as error : 
    print(f"Error: {error}")