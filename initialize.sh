#!/bin/bash
#Equipo Kernighan
#Autor: Rendón Cruz Arturo (Herz)
#Descripcion: El siguiente script se encarga de inicializar la BD así como crear el primer verdedor si no existiera
trap 'zenity --error --text="Saliendo del sistema..."; exit 1' 1 2 3 15 20
#Verificamos que el usuario postgres sea el que este ejecutando el archivo
if [ $LOGNAME != "postgres" ]
	then
#En caso de que no sea lanzamos un mensaje de error con zenity
	zenity --error \
	--text="No esta autorizado para ejecutar este programa"
#Salimos del script con codigo 1
	exit 1
fi
#Verificamos la existencia de la base de datos
verifydb=$(psql -h localhost -p 5432 burgerking -A -t -F '|' -c "SELECT count(*) FROM vendedor" 2>&1)
if [ $? -ne 0 -a $(echo ${verifydb:-0} | egrep -c "does not exist") -gt 0 ]
	then
	#Si la BD no existe la creamos
	createdb burgerking -E 'UTF8' -T 'template0' &>/dev/null
	#Verficamos la correcta ejecucion del comando anterior
	if [ $? -ne 0 ]
		then
	#En caso de que el comando no se ejecute correctamente lanzamos un mensaje de error con zenity y salimos con codigo 1
		zenity --error \
		--text="Error al crear la base de datos"
		exit 1
	fi
	#Creamos la estructura (DDL) de la BD 
	psql -h localhost -p 5432 burgerking < ./DB_BurgerKing/BurgerKing.SQL 2>/dev/null
	#Verficamos la correcta ejecucion del comando anterior
	if [ $? -ne 0 ]
		then
	#En caso de que el comando no se ejecute correctamente lanzamos un mensaje de error con zenity y salimos con codigo 1
		zenity --error \
		--text="Error al crear la estructura de la base de datos"
		exit 1
	fi
fi
#Verificamos si existe al menos un usuario en la BD
verifydb=$(psql -h localhost -p 5432 burgerking -A -t -F '|' -c "SELECT count(*) FROM vendedor" 2>&1)
if [ $? -eq 0 -a ${verifydb:-0} -lt 1 ]
	then
	#Si no existe llamamos al script ./agregarVendedor.sh
	./agregarVendedor.sh
	exit $?
fi

#Si todo salio bien salimos con codigo 0
exit 0