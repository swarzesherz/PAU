// Equipo Kernihan
// Programado por Angulo Ramirez Daniel
#include <stdio.h>
#include <stdlib.h>

main(int argc, char **argv){

	float total=atof(argv[1]);
	float recibido=atof(argv[2]);
	// Recibe dos argumentos

	if(total > recibido || argc != 3){
		printf("Error\n");
		return 1;
		// Si la cantidad recicbida en menor que el total  pagar imprime un error
	}
	printf("%.2f\n",recibido-total);
	// Solo se imprime la diferencia entre las dos cantidades.

	return 0;
}
