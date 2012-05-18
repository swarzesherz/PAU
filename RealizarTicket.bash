#/bin/bash
#
###################################################################
#este script debe ser invocado con dos argumentos vendedor y venta#
#se hara uso del archivo en el directorio de trabajo ventas.txt   #
#El archivo tendra el siguiente formato:                	  #
# idVenta:nombreProducto:cantidad:precio			  #
###################################################################
#
trap 'echo Saliendo... ; exit 1' 1 2 3 15 20
#
if [ $# -ne 2 ]
	then
		zenity --error --text="Error al recibir parametros"
		exit 1
fi
vendedor=$1
venta=$2


total=$(cat ventas.txt|\
	awk -v venta=${venta} '$1 == venta' FS=":" |\
	awk '{suma += ($4*$3)} END { print suma}' FS=":")

echo "Total: " ${total}
exit 0
