#!/bin/bash
# La ejecucion del programa muestra un menu donde el usurio puede realizar varias aciones
trap 'echo Saliendo...; date, exit 1' 1 2 3 15 20 # esta linea  captura alguna señal que intervenga en la ejecucion del programa
pedido="1024"

while true   # Estructura iterativa que siempre va a ser verdadera, su propsito es que el GUI creado en las lineas siguientes se muestre indefinidamente.
do
	opcion=$(zenity --title="BURGER KING" --width=400 --height=500 \
		--text="<b>Pedido numero:  ${pedido} \nSelecciona el combo que deseas agregar:</b>" \
		--list --column="Seleccionar" --column="Paquete"  --column="cantidad" \
		--radiolist FALSE "Combo 1" "${cantidad1:-0}" FALSE "Combo 2" "${cantidad2:-0}" FALSE "Combo 3" "${cantidad3:-0}" FALSE "Combo 4" "${cantidad4:-0}" FALSE "Finalizar orden" "") # Menu con diversas opciones

	if [ $? -eq 0 ] # Estructura de flujo de control  que evalua si el ultimo comando fue terminado correctamente.
	then
		IFS="|"
		if [ $opcion ]
		then
			
			if [ ${opcion} = "Combo 1" ] # Realiza esa opcion
			then
				cantidad1=$(expr ${cantidad1:-0} + 1)
				
			fi
		
			if [ ${opcion} = "Combo 2" ] # Realiza esa opcion
			then
				cantidad2=$(expr ${cantidad2:-0} + 1)
			fi

			if [ ${opcion} = "Combo 3" ] # Realiza esa opcion
			then
				cantidad3=$(expr ${cantidad3:-0} + 1)
			fi

			if [ ${opcion} = "Combo 4" ] # Realiza esa opcion
			then
				cantidad4=$(expr ${cantidad4:-0} + 1)
			fi

			if [ ${opcion} = "Finalizar orden" ] # Realiza esa opcion
			then

				if [ ${cantidad1:-0} -gt 0 ]
				then
					echo "$pedido:Combo 1:$cantidad1:67.5"	>> ventas.txt			
				fi

				if [ ${cantidad2:-0} -gt 0 ]
				then
					echo "$pedido:Combo 2:$cantidad2:67.5"	>> ventas.txt				
				fi

				if [ ${cantidad3:-0} -gt 0 ]
				then
					echo "$pedido:Combo 3:$cantidad3:67.5"	>> ventas.txt				
				fi
		
				if [ ${cantidad4:-0} -gt 0 ]
				then
					echo "$pedido:Combo 4:$cantidad4:67.5"	>> ventas.txt				
				fi
								
				exit 0
			fi

			
		fi
		IFS=""
	else

		zenity --info --text="<b>Cancelado!</b>"
		exit 0 # Salida del programa sin error
	fi # Fin estructura if
done  # Fin estructura while


