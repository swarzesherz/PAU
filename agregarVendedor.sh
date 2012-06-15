#!/bin/bash
#Equipo Kernighan
#Autor: Rendón Cruz Arturo (Herz)
#Descripcion: El siguiente script agrega vendedores a al sistema
trap 'zenity --error --text="Saliendo del sistema..."; exit 1' 1 2 3 15 20
#Creamos un formulario con zenity para obtener los datos del vendedor y el resultado lo asignamos a la variable vendedor
vendedor=$(zenity --forms --title="Añadir vendedor" \
	--text="Introduzca la información del vendedor" \
	--separator="|" \
	--add-entry="Nombre" \
	--add-entry="Apellido Paterno" \
	--add-entry="Apellido Materno" \
	--add-entry="Correo-e" \
	--add-password="Password")
#Dependiendo de como haya terminado el comando entramos en la opcion correspondiente
case $? in
#El programa termino sin errores
    0)
        #Extraemos los datos individales de la variable vendedor y los asignamos a variables individuales
        nombre=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $1}')
        apelldoP=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $2}')
        apelldoM=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $3}')
        correo=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $4}')
        password=$(echo ${vendedor:-NULL} | awk 'BEGIN{FS="|"; ORS="";}{print $5}' | md5sum | awk '{print $1}')
        #Creamos un cadena con la consulta que se realizara en la BD y la almacenamos en la variable "query"
   		query="INSERT INTO vendedor(nombre, ap_pat, ap_mat, vendedor_correo, passwd) VALUES('${nombre:-NULL}', '${apelldoP:-NULL}', '${apelldoM:-NULL}', '${correo:-NULL}', '${password:-NULL}');"
    	#Ejecutamos la consulta
        psql -h localhost -p 5432 burgerking -A -t -F '|' -c "${query:-NULL}" &>/dev/null
    	#Verificamos la correcta ejecucion del comando ateriro
    	if [ $? -ne 0 ]
    		then
            #Si el comando termino con codigo diferente de 0 mandamos un mensaje de error con zenity
    		zenity --error \
			--text="No se pudo agregar el vendedor"
            #Salimos del scrip con codigo 1
			exit 1
    	fi
    ;;
    1)
        #Mandamos un mensaje de error con zenity
		zenity --error \
		--text="No se pudo agregar el vendedor"
        #Salimos del scrip con codigo 1
		exit 1
	;;
    -1)
        #Mandamos un mensaje de error con zenity
        zenity --error \
		--text="Ha ocurrido un error inesperado."
        #Salimos del scrip con codigo 1
		exit 1
	;;
esac
#Si todo salio bien salimos con codigo 0
exit 0