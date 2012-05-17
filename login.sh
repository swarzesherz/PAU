#!/bin/sh

auth=$(zenity --password --username)
case $? in
         0)
                zenity --info \
		--text="Validadando"
		;;
         1)
                zenity --error \
		--text="No se pudo autenticar"
		exit 1
		;;
        -1)
                zenity --error \
		--text="Ha ocurrido un error inesperado."
		exit 1
		;;
esac

exit 0
