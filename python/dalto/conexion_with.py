import mysql.connector 

import pandas as pd 

# print(mysql.connector.__version__)

# EJECTUAR CONEXIÓN A LA BASE DE DATOS
# Instancia de la clase: CMySQLConnection
conexion = mysql.connector.connect(
    host = "127.0.0.1", 
    user = "root", 
    port = "3307",
    password = "root", 
    database = "northwind"
)

# VERIFICAR CONEXIÓN (BOOLEANO)
# print(conexion.is_connected())

# VER TIPO QUE ES CONEXION -> ES UNA CLASE
# print(type(conexion))

# CREAR SENTENCIA SQL 
query = "SELECT * FROM orderdetails" 

# CREAR CURSOR PARA EJECUTAR CONSULTAS SQL 
# Hacemos que nos devuelva cada registros como un diccionario 
# Por defecto devuelve en tuplas 
# cursor = conexion.cursor(dictionary= True)  
with conexion.cursor(dictionary=True) as cursor:
    cursor.execute(query) 

    listResult = cursor.fetchall() 
    
    # FOR PARA ITERAR 
    for row in listResult: 
        print(row)

    print("==== ==== ==== ==== ==== ==== ==== ====")

    results_fr = pd.DataFrame(listResult) 
    print(results_fr)

# COMMIT (GUARDAR CAMBIOS EN LA BASE DE DATOS)
# conexion.commit()

# CERRAR CURSOR y CONEXION 
conexion.close()