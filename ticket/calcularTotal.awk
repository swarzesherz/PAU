#!/usr/bin/awk -f

	BEGIN{
		if(("/bin/date '+%b%d-%y %H:%M'"|getline fecha) != 1){
			fecha = "Desconocida"
		}
		close("/bin/date")
		print	"Vend:" substr(vendedor,1,26)
		print 	"--------------------------------"
		print	"Venta: "venta"  "fecha
		print	"--------------------------------"
	}

	{
			
			if(length($2) < 20){
				printf "%s %s",$1,$2
				for(i=1;i<=20-length($2);i++){printf " "}
				printf "%s\n", $3
			}
			else{
				print $1" "substr($2, 1, 19)" "$3
			}
			{suma += ($1*$3)}
		
	}
	
	END{
		print	"--------------------------------"
		printf  "              Total: "
		printf "%.2f\n",suma
	}
