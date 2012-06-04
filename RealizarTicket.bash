#/bin/bash

trap 'echo Saliendo... ; exit 1' 1 2 3 15 20

if [ $# -ne 2 ] # Si no se ejecuta con 2 argumentos
	then
		zenity --error --text="Error al recibir argumentos"
		exit 1
fi

# con el id del vendedor se obtiene el nombre completo y se asigna a la variable vendedor
vendedor=$(psql burgerking -c "select nombre||' '||ap_pat||' '||ap_mat from vendedor where vendedor_id=${1}"|awk '{if (NR == 3)print}')

 # Para mostrar el contenido del ticket se envian todos los datos aun archivo que despues se imprimira
psql burgerking -c "select pv.cantidad_producto, p.producto_nombre, pv.precio_venta from producto_venta pv inner join producto p on p.producto_id=pv.producto_id inner join venta v on v.venta_id=pv.venta_id where v.venta_id=${2}"|awk '{if (NR >2){for (x=1;x<=NF;x++){printf "%s", $x} printf "\n"}}'|awk -F"(" '{print $1}'|awk -f calcularTotal.awk -F"|" -v vendedor="${vendedor:-NULL}" -v venta=${2}>vendedor-${1}.tmp

zenity --text-info --title="Ticket-${2}" --filename="vendedor-${1}.tmp"

if [ $? -ne 0 ]
	then
		zenity --error --text="Error al Mostrar el total"
		exit 1
fi
 # Para Cobrar
total=$(awk -F"Total:" 'END{print $2}' vendedor-${1}.tmp|awk '{print $1}')

valido="-"
# valida que se ingrese una cantidad mayor oigual al total
while [ ${valido} == "-" ]
do
	efectivo=$(zenity --entry \
		--text="Total a pagar: ${total}\
		 	\nIngresa la cantidad Recibida:")
	valido=$(echo "${efectivo:-0}-${total}"|bc -l|awk '{print substr($0, 1, 1)}')
done

# se ejecuta un programa en c que recibe 2 argumentos total y efectivo
cambio="$(./cobrar ${total} ${efectivo})"
if [ ${cambio:-Error} == "Error" ]
	then
		zenity --info --text="Error al calcular el cobro."
		exit 22
fi
zenity --info --text="Recibido:  ${efectivo}\nTotal:${total}\n\n<b>Cambio:${cambio}</b>"
if [ $? -ne 0 ]
	then
		zenity --error --text="Error al cobrar"
		exit 1
fi
psql burgerking -c "update venta set pagada='SI' where venta_id=${2}" 2>/dev/null >/dev/null

(cat encabezado.txt;cat vendedor-1.tmp;echo "             Pagado: ${total}";cat pie.txt;echo "";echo "Ticket : ${2}";echo "Tienda : 15327";echo -n "Fecha  :";date '+ %d-%m-%Y')>ticket-vendedor-${1}.tmp

exit 0
