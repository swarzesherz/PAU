#!/bin/bash
#Verificamos si existe la BD y si hay al menos un vendedor
verify=$(psql -h localhost -p 5432 -U ventas burgerking -A -t -F '|' -c "SELECT count(*) FROM vendedor" 2>/dev/null)
if [ $? -ne 0 -o ${verify:-0} -lt 1 ]
	then
		gksu -w -u postgres --message "Ingrese la contraseña del usuario \"postgres\" para inicializar el sistema" ./initialize.sh
		if [ $? -ne 0 ]
			then
			zenity --error \
			--text="No se pudo inicializar el sistema"
			exit 1
		fi
fi
user=$(./login.sh)
if [ $? != 0 ]
then
	exit 1
fi
export user
echo $user | awk 'BEGIN {FS=":"} {print $1}'
exit 0