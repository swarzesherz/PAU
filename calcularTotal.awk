#!/usr/bin/awk -f

	BEGIN{
		if(("/bin/date '+%H:%M'"|getline fecha) != 1){
			fecha = "Desconocida"
		}
		close("/bin/date")
		print 	"		  BURGUER KING		    "
		print 	"		SUC. 15327 RELOX		"
		print 	"	 Av. Insurgentes # 2374	 	"
		print 	"Col San Angel Del Alvaro Obregon"
		print 	"	  Mexico Df C.P. 1000		"
		print
		print	"Vend: " vendedor
		print 	"--------------------------------"
		print	"Venta: " venta"   "fecha
		print	"--------------------------------"

	}

	{
			
			if(length($2) < 7){
				print $1" "$2"\t\t\t\t"$3
			}
			else if(length($2) < 16){
				print $1" "$2"\t\t\t"$3
			}
			else{
				print $1" "substr($2, 1, 18)" "$3
			}
			suma += ($1*$3)
		
	}
	
	END{
		print	"--------------------------------"
		print "Total:\t\t\t\t"suma
	}
