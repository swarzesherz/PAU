#!/usr/bin/awk -f

# Eqipo Kernihan
# Programado por Angulo Ramirez Daniel

# Con los datos recibidos por la ejecucion de unquery se procesan como sigue:
	BEGIN{
		if(("/bin/date '+%b%d-%y %H:%M'"|getline fecha) != 1){
			fecha = "Desconocida"
		} # Se obtiene la fecha
		close("/bin/date") # cierra el comando utilizado
		print	"Vend:" substr(vendedor,1,26) # Imprime nombre del vendedor solo los primeros 26 caracteres
		print 	"--------------------------------"
		print	"Venta: "venta"  "fecha		# Imprime id de la venta
		print	"--------------------------------"
	}	# Mostramos los datos del ticket

	{
			
			if(length($2) < 20){ # Segun la longitud del nombre del producto se muestran los datos
				printf "%s %s",$1,$2 # se imprime la cantidad y el nombre del producto
				for(i=1;i<=20-length($2);i++){printf " "} # Para determinar cuantos espacios imprimir
				printf "%s\n", $3 # Se imprime l costo unitario del producto
			}
			else{
				print $1" "substr($2, 1, 19)" "$3 # si el nombre del prooducto tiene una longitud mayor o igual a 20 solo se mostraran los primeros 19 caracteres
			}
			{suma += ($1*$3)} # para cada registro procesado se va incrementando el valor de suma
		
	} # se le da un formato a los elementos del ticket
	
	END{
		print	"--------------------------------"
		printf  "              Total: "
		printf "%.2f\n",suma
	} # Mostramos el total o importe de la venta
