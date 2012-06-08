#!/bin/bash
vendedor=$(zenity --forms --title="Añadir vendedor" \
	--text="Introduzca la información del vendedor" \
	--separator="|" \
	--add-entry="Nombre" \
	--add-entry="Apellido Paterno" \
	--add-entry="Apellido Materno" \
	--add-entry="Correo-e" \
	--add-password="Password")

case $? in
    0)
        nombre=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $1}')
        apelldoP=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $2}')
        apelldoM=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $3}')
        correo=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $4}')
        password=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $5}' | md5sum | awk '{print $1}')
   		query="INSERT INTO vendedor(nombre, ap_pat, ap_mat, vendedor_correo, passwd) VALUES('${nombre:-NULL}', '${apelldoP:-NULL}', '${apelldoM:-NULL}', '${correo:-NULL}', '${password:-NULL}');"
    	psql -h localhost -p 5432 burgerking -A -t -F '|' -c "${query:-NULL}" &>/dev/null
    	#Verificamos la correcta ejecucion del comando ateriro
    	if [ $? -ne 0 ]
    		then
    		zenity --error \
			--text="No se pudo agregar el vendedor"
			exit 1
    	fi
    ;;
    1)
		zenity --error \
		--text="No se pudo agregar el vendedor"
		exit 1
	;;
    -1)
        zenity --error \
		--text="Ha ocurrido un error inesperado."
		exit 1
	;;
esac
