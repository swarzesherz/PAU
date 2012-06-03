#/bin/bash

#################################################################
# Este script debe ser invocado con dos argumentos:		#
# vendedor y idventa. Del directorio de trabajo, se hara uso	#
# del archivo  ventas.txt					#
# El archivo tendra el siguiente formato:			#
# 	idVenta:nombreProducto:cantidad:precio			#
#################################################################

trap 'echo Saliendo... ; exit 1' 1 2 3 15 20

if [ $# -ne 2 ] # Si no se ejecuta con 2 argumentos
	then
		zenity --error --text="Error al recibir parametros"
		exit 1
fi

vendedor=$(psql burgerking -c "select nombre||' '||ap_pat||' '||ap_mat from vendedor where vendedor_id=${1}"|awk '{if (NR == 3)print}')

 # Para mostrar el ticket
psql burgerking -c "select pv.cantidad_producto, p.producto_nombre, pv.precio_venta from producto_venta pv inner join producto p on p.producto_id=pv.producto_id inner join venta v on v.venta_id=pv.venta_id where v.venta_id=${2}"|awk '{if (NR >2){for (x=1;x<=NF;x++){printf "%s", $x} printf "\n"}}'|awk -F"(" '{print $1}'|awk -f calcularTotal.awk -F"|" -v vendedor="${vendedor:-NULL}" -v venta=${2}>tmp.txt

zenity --text-info --title="Ticket-${2}" --filename=tmp.txt

if [ $? -ne 0 ]
	then
		zenity --error --text="Error al Mostrar el ticket"
		exit 1
fi
 # Para Cobrar
total=$(awk -v venta=${2} \
	'$1 == venta {suma += ($4*$3)}END { print suma}' FS=':' ventas.txt)

efectivo=$(zenity --entry \
		--text="Total a pagar: ${total}\
		 	\nIngresa la cantidad Recibida:")

exit 0
