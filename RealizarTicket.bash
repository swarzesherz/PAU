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
 
 # Para mostrar el ticket
zenity 	--info \
	--text="$(awk -f calcularTotal.awk \
		-F":" -v vendedor=${1} -v venta=${2}  ventas.txt)"
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
if [ $efectivo -
exit 0
