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

    # SENTENCIA (statement)
    query = """
    insert into employees(LastName, FirstName, BirthDate, Photo, Notes) 
    values (%s, %s, %s, %s,%s)
    """

    # Valores en tupla 
    valores = ("Lopez", "Mauricio", "1950-02-15", "EmpID16.pic", "Good Employee.")

    cursor = cnx.cursor(dictionary=True) 

    cnx.start_transaction()

    # Ejectuar con los 2 parámetros 
    cursor.execute(query, valores) 

    # Obtener nuevo ID 
    newId = cursor.lastrowid

    # GUARDAR CAMBIOS 
    cnx.commit()

    print("Registro Exitoso")
    print(f"ID del Empleado: {newId}")
    

except mysql.connector.Error as error: 
    print(f"Ocurrió un error: {error}")

    if 'cnx' in locals(): 
        cnx.rollback()

finally: 
    if 'cursor' in locals(): 
        cursor.close()
    
    if 'cnx' in locals():
        cnx.close()

