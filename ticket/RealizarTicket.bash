#/bin/bash

# Equipo Kernihan
# Programado por Angulo Ramirez Daniel

# Mandar a llamar como: 
#	./ticket/RealizarTicket.bash vendedor_id venta_id
#
# Este scrpipt primero obtiene los datos que intervienen en la venta.
# Como mombre de vendedor y los productos vendidos.
trap 'echo Saliendo... ; exit 1' 1 2 3 15 20
# Si no se ejecuta con 2 argumentos
if [ $# -ne 2 ]
	then
		zenity --error --text="Error al recibir argumentos"
		exit 1
fi
# con el id del vendedor que esta en $1 se obtiene el nombre completo del vendedor 
# consultando la base de datos y la salida se asigna a la variable vendedor
vendedor=$(psql -h localhost -p 5432 burgerking -A -t -F '|' -c "select nombre||' '||ap_pat||' '||ap_mat from vendedor where vendedor_id=${1}")
# Se realiza una consulta a la base de datos para obtener los productos vendidos
# Con un scriipt en awk se calcula el total
psql -h localhost -p 5432 -U ventas burgerking -A -t -c "select pv.cantidad_producto, p.producto_nombre, pv.precio_venta from producto_venta pv inner join producto p on p.producto_id=pv.producto_id inner join venta v on v.venta_id=pv.venta_id where v.venta_id=${1}"|awk -f calcularTotal.awk -F"|" -v vendedor="${vendedor:-NULL}" -v venta=${2}>vendedor-${1}.tmp
# La salida anterior se guarda en el archivo vendedor-${1}.tmp para despues ser usada agregando:
#	Encabezado y pie del ticket.
zenity --text-info --title="Ticket-${2}" --filename="vendedor-${1}.tmp"
# Se muestra el contenido de la venta asi como su total, para que el vendedor lo pueda verificar
if [ $? -ne 0 ]
	then
		zenity --error --text="Error al Mostrar el total"
		exit 1
fi
# Para Cobrar
total=$(awk -F"Total: " 'END{print $2}' vendedor-${1}.tmp)
valido="-"
# valida que se ingrese una cantidad mayor oigual al total
while [ ${valido} == "-" ] # Si la variable valido es igual a - se ejecuta
do
	efectivo=$(zenity --entry \
		--text="Total a pagar: ${total}\
		 	\nIngresa la cantidad Recibida:" --title="Ingrese Efectivo")
		 	if [ $? -ne 0 ]
		 		then
		 			zenity --error --text="cancelado"
		 			exit 1
		 		fi
	valido=$(echo "${efectivo:-0}-${total}"|bc -l|awk '{print substr($0, 1, 1)}')
	if [ ${valido:--} == "-" ]
	then
		zenity --info --text="Ingresa una cantidad valida"
	fi
done
# se ejecuta un programa en c que recibe 2 argumentos total y efectivo
cambio="$(./cobrar ${total} ${efectivo})"
if [ ${cambio:-Error} == "Error" ]
	then
		zenity --error --text="Error al calcular el cobro."
		exit 22
fi
zenity --info --text="Recibido:  ${efectivo}\nTotal:${total}\n\n<b>Cambio:${cambio}</b>"
if [ $? -ne 0 ]
	then
		zenity --error --text="Error al cobrar"
		exit 1
fi
psql -h localhost -p 5432 -U ventas burgerking -c "update venta set pagada='SI' where venta_id=${2}" 2>/dev/null >/dev/null
# Una vez cobrado es necesario cambiar el estado de la venta para que se registre como pagada
if [ $? -ne 0 ]
	then
		zenity --error --text="Error al cobrar"
		exit 1
fi
(cat encabezado.txt;cat vendedor-1.tmp;echo "             Pagado: ${total}";cat pie.txt;echo "";echo "Ticket : ${2}";echo "Tienda : 15327";echo -n "Fecha  :";date '+ %d-%m-%Y')>ticket-vendedor-${1}.tmp
######Se despliegan 3 archivos, tambien se ejecutan algunos comandos para darle el formato final al ticket
cat ticket-vendedor-${1}.tmp #|lpr
# Se muestra el ticket generado y se imprime
zenity --info --text="Venta realizada..."
exit 0
