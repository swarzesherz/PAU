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
#Menu principal
userName=$(echo $user | awk 'BEGIN {FS=":"} {print $2,$3,$4}')
userID=$(echo $user | awk 'BEGIN {FS=":"} {print $1}')
export user
export userName
export userID
app=$(zenity  --list  \
	--title="BurgerKing - ${userName:-NULL}" \
	--text "Seleccione la aplicación deseada" \
	--radiolist  \
	--column "Seleccione" \
	--column "Descripción" \
	FALSE "Agregar vendedor" \
	TRUE "Pedidos"\
	FALSE "Salir")

case ${app:-NULL} in
	"Agregar vendedor" )
		gksu -w -u postgres --message "Ingrese la contraseña del usuario \"postgres\" para agregar un vendedor" ./agregarVendedor.sh
		if [ $? -ne 0 ]
			then
			zenity --error \
			--text="No se agregar el vendedor"
			exit 1
		fi
	;;
esac
exit 0