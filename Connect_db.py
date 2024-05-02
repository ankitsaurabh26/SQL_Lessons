import mysql.connector

mydb = mysql.connector.connect(host='localhost',user='root',passwd='1234') # other parameter: database='database_name'

mycursor = mydb.cursor()

mycursor.execute('show databases')

for i in mycursor:
    print(i)