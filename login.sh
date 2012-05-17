#!/bin/sh

auth=$(zenity --password --username)
case $? in
         0)
                zenity --info \
		--text="Validadando"
		;;
         1)
                zenity --error \
		--text="Saliendo"
		;;
        -1)
                zenity --error \
		--text="Ha ocurrido un error inesperado."
		;;
esac

exit 0
