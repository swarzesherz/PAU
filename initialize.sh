#!/bin/bash
#Verificamos que el usuario postgres sea el que este ejecutando el archivo
if [ $LOGNAME != "postgres" ]
	then
	zenity --error \
	--text="No esta autorizado para ejecutar este programa"
	exit 1
fi
#Si la base de datos no existe la creamos
verifydb=$(psql -h localhost -p 5432 burgerking -A -t -F '|' -c "SELECT count(*) FROM vendedor" 2>&1)
if [ $? -ne 0 -a $(echo ${verifydb:-0} | egrep -c "does not exist") -gt 0 ]
	then
	createdb burgerking -E 'UTF8' -T 'template0' &>/dev/null
	#Verficamos la correcta ejecucion del comando anterior
	if [ $? -ne 0 ]
		then
		zenity --error \
		--text="Error al crear la base de datos"
		exit 1
	fi
	psql -h localhost -p 5432 burgerking < ./DB_BurgerKing/BurgerKing.SQL 2>/dev/null
	#Verficamos la correcta ejecucion del comando anterior
	if [ $? -ne 0 ]
		then
		zenity --error \
		--text="Error al crear la estructura de la base de datos"
		exit 1
	fi
fi
#Creamos el primer usuario si no hay uno el la BD
verifydb=$(psql -h localhost -p 5432 burgerking -A -t -F '|' -c "SELECT count(*) FROM vendedor" 2>&1)
if [ $? -eq 0 -a ${verifydb:-0} -lt 1 ]
	then
	./agregarVendedor.sh
	exit $?
fi

exit 0