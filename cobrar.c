#include <stdio.h>
#include <stdlib.h>
main(int argc, char **argv){

	float total=atof(argv[1]);
	float recibido=atof(argv[2]);

	if(total > recibido || argc != 3){
		printf("Error\n");
		return 1;
	}
	printf("%.2f\n",recibido-total);

	return 0;
}
