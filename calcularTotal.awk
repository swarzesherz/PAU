#!/usr/bin/awk -f

	BEGIN{
		if(("/bin/date '+%d-%m-%Y %H:%M'"|getline fecha) != 1){
			fecha = "Desconocida"
		}
		close("/bin/date")
		print 	"<b>---------BURGUER KING----------</b>"
		print	"Vend: " vendedor
		print	"No.Venta: " venta
		print	"Fecha:" fecha
		print	"<b>---------------------------------------</b>"
		print	"Cant	Producto	Precio"
		print	"<b>---------------------------------------</b>"
	}

	{
		if($1 == venta){
			if(length($2) < 8){
				print $3" "$2"\t\t\t\t"$4
			}
			else if(length($2) < 16){
				print $3" "$2"\t\t"$4
			}
			else{
				print $3" "substr($2, 1, 18)"\t"$4
			}
			suma += ($4*$3)
		}
	}
	
	END{
		print	"<b>---------------------------------------</b>"
		print "<b>Total:</b>\t\t\t\t<b>"suma"</b>"
	}
