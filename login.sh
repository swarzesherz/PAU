#!/bin/bash
trap 'echo Saliendo... ; exit 1' 1 2 3 15 20

auth=$(zenity --forms --title="Iniciar sesion" \
	--text="Intro" \
	--separator="|" \
	--add-entry="Correo-e" \
	--add-password="Password")

case $? in
         0)
			email=$(echo ${auth:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $1;}') 
			password=$(echo ${auth:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $2;}' | md5sum | awk '{print $1}')
			user=$(psql -h localhost -p 5432 -U postgres burgerking -A -t -F ':' -c "SELECT vendedor_id, ap_pat, ap_mat, nombre, passwd FROM vendedor WHERE vendedor_correo='${email}'")
			if [ $? -ne 0 -o ${user:-NULL} == "NULL" ]
				then
				zenity --error \
				--text="El usuario ${email:-NULL} no existe en el sistema"
				exit 1
			fi
			if [ ${password:-NULL} != $(echo ${user:-NULL} | awk 'BEGIN{FS=":"; ORS="";}{print $5;}') ]
				then
				zenity --error \
				--text="Password incorrecto"
				exit 1
			fi
			echo $user;
		;;
         1)
                zenity --error \
		--text="No se pudo autenticar"
		exit 1
		;;
        -1)
                zenity --error \
		--text="Ha ocurrido un error inesperado."
		exit 1
		;;
esac

exit 0
