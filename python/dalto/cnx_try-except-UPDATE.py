import mysql.connector 
import pandas as pd 

try: 
    cnx = mysql.connector.connect(
        host = "127.0.0.1", 
        port = "3307", 
        user = "root" ,
        password = "root" ,
        database = "northwind"
    )

    query = """
    update employees set Photo = %s where EmployeeID = %s
    """

    valores = ("EmpID17.pic", 17)

    # valores puede ser diccionario también, no solo tupla o lista 
    # Para esto adaptamos el 'query' de la siguiente forma 
    # SENTENCIA (statement)
    query = """
    update employees set Photo = %(foto)s where EmployeeID = %(id)s
    """

    # Valores en diccionario 
    valores = {
        "foto" : "EmpID17.pic", 
        "id" : 17
    }

    cursor = cnx.cursor(dictionary=True) 

    cnx.start_transaction()

    cursor.execute(query, valores) 

    # GUARDAR CAMBIOS 
    cnx.commit()

    query = """ 
    select * from employees where EmployeeID = %s
    """

    # Acá se usa lista []
    # (17,) => El 2do parámetro o argumento debe de ser una tupla
    # Pero podemos usar Listas => [17] | basta esto, reemplazar '()' por '[]'
    cursor.execute(query, [17])

    row = cursor.fetchall()

    print("Registro Actualizado con Exito")
    print(f"==== ==== ==== ==== \nRegistro: \n{row} \n==== ==== ==== ====")
    

except mysql.connector.Error as error: 
    print(f"Ocurrió un error: {error}")

    if 'cnx' in locals(): 
        cnx.rollback()

finally: 
    if 'cursor' in locals(): 
        cursor.close()
    
    if 'cnx' in locals():
        cnx.close()

