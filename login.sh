#!/bin/bash
#Equipo Kernighan
#Autor: Rendón Cruz Arturo (Herz)
#Descripcion: El siguiente script se encarga autenticar a los usuarios en el sistema
trap 'zenity --error --text="Saliendo del sistema..."; exit 1' 1 2 3 15 20

#Creamos un formulario con zenity para pedir los datos de autenticación
auth=$(zenity --forms --title="Iniciar sesion" \
	--text="Ingrese los siguientes datos" \
	--separator="|" \
	--add-entry="Correo-e" \
	--add-password="Password")

#Entramos en un switch dependiendo de la teminacion del comando anterior
case $? in
		#El comando se ejecuto correctamente
		0)
			#Obtenemos solo la cadena correspondiente al correo
			email=$(echo ${auth:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $1;}') 
			#Obtenemos solo la cadena correspondiente al password y generamos la cadema md5
			password=$(echo ${auth:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $2;}' | md5sum | awk '{print $1}')
			#Realizamos una consulta en la BD buscando al usuario por email y la almcenamos el variable user
			user=$(psql -h localhost -p 5432 -U postgres burgerking -A -t -F ':' -c "SELECT vendedor_id, ap_pat, ap_mat, nombre, passwd FROM vendedor WHERE vendedor_correo='${email}'")
			#Si la ejecucion del comando termino diferente de 0 o el contenido de la variable user es "NULL"
			if [ $? -ne 0 -o ${user:-NULL} == "NULL" ]
				then
				#Mandamos un mensaje de error con zenity
				zenity --error \
				--text="El usuario ${email:-NULL} no existe en el sistema"
				exit 1
			fi
			#Verificamos que el contendido de la variable $password sea el mismo al que tenemos almacenado en la BD
			if [ ${password:-NULL} != $(echo ${user:-NULL} | awk 'BEGIN{FS=":"; ORS="";}{print $5;}') ]
				then
				#Mandamos un mensaje de error con zenity
				zenity --error \
				--text="Password incorrecto"
				exit 1
			fi
			echo $user;
		;;
		1)
			#Mandamos un mensaje de error con zenity
			zenity --error \
			--text="No se pudo autenticar"
			exit 1
		;;
		-1)
			#Mandamos un mensaje de error con zenity
			zenity --error \
			--text="Ha ocurrido un error inesperado."
			exit 1
		;;
esac

#Si todo salibo bien salimos con código 0
exit 0
