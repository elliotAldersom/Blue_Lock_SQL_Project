import mysql.connector 
import pandas as pd 

try: 
    # CONEXION 
    cnx = mysql.connector.connect(
        host = "127.0.0.1", 
        port = "3307", 
        user = "root" ,
        password = "root" ,
        database = "northwind"
    )

    # SENTENCIA (statement)
    query = """
    select *, square(Price) as price_square 
    from Products
    where price > 0 and ProductName is not null"""

    # CURSOR 
    cursor = cnx.cursor(dictionary=True) 
    # Ejectutar 
    cursor.execute(query) 

    # Obtener los registros 
    listResults = cursor.fetchall()

    # Iterar y mostrar uno por uno 
    for row in listResults : 
        print(row)

    # Hacer como una tabla para ver mejor en consola 
    df = pd.DataFrame(listResults)

    print(df)

except mysql.connector.Error as error: 
    print(f"Ocurrió un error: {error}")

finally: 
    if 'cursor' in locals(): 
        cursor.close()
    
    if 'cnx' in locals():
        cnx.close()

