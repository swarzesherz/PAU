#!/bin/bash
#Equipo Kernighan
#Autor: Rendón Cruz Arturo (Herz)
#Descripcion: El siguiente script se encarga de mostrar el menu principal
trap 'zenity --error --text="Saliendo del sistema..."; exit 1' 1 2 3 15 20
#Verificamos si existe la BD y si hay al menos un vendedor
verify=$(psql -h localhost -p 5432 -U ventas burgerking -A -t -F '|' -c "SELECT count(*) FROM vendedor" 2>/dev/null)
if [ $? -ne 0 -o ${verify:-0} -lt 1 ]
	then
#En caso de no existir la BD o un vendedor llamamos al script ./initialize.sh como el usuario postgres
		gksu -w -u postgres --message "Ingrese la contraseña del usuario \"postgres\" para inicializar el sistema" ./initialize.sh
		if [ $? -ne 0 ]
			then
			#Si el comando anteior termino con un codigo diferente de 0 lanzamos un error con zenity
			zenity --error \
			--text="No se pudo inicializar el sistema"
			#Salimos con codigo 1
			exit 1
		fi
fi
#Llamamos al scrip ./login.sh y el resultado lo asigmos a la variable user
user=$(./login.sh)
if [ $? != 0 ]
then
#Si el comando anterior termino diferente de 0 salimso con codigo 1
	exit 1
fi
#Asignamos a la variable userName el resultado del comando
userName=$(echo $user | awk 'BEGIN {FS=":"} {print $2,$3,$4}')
#Asignamos a la variable userID el resultado del comando
userID=$(echo $user | awk 'BEGIN {FS=":"} {print $1}')
#Exportamos las variables user, userName y userID para que las puedan ver los otros scripts
export user
export userName
export userID
#Creamos el menu con zenity y una lista con las opciones de la aplicación y el valor seleccionado lo asignamos a  la variable app
app=$(zenity  --list  \
	--title="BurgerKing - ${userName:-NULL}" \
	--text "Seleccione la aplicación deseada" \
	--radiolist  \
	--column "Seleccione" \
	--column "Descripción" \
	FALSE "Agregar vendedor" \
	TRUE "Pedidos"\
	FALSE "Salir")
#Entramos en la opcion elegina de acuerdo al valor en la vraible appp
case ${app:-NULL} in
	"Agregar vendedor" )
	#Si la opcion fue Agregar vendedor llamaos al scrip ./agregarVendedor.sh como el usuario postgres
		gksu -w -u postgres --message "Ingrese la contraseña del usuario \"postgres\" para agregar un vendedor" ./agregarVendedor.sh
		if [ $? -ne 0 ]
			then
			#Si el comando anteior termino con un codigo diferente de 0 lanzamos un error con zenity
			zenity --error \
			--text="No se agregar el vendedor"
			#Salimos con codigo 1
			exit 1
		fi
	;;
esac
#Si todo salio bien salimos con codigo 0
exit 0