#!/bin/bash
trap 'echo Saliendo... ; exit 1' 1 2 3 15 20
authUser=$(zenity --entry \
	--title="Usuario" \
	--text="Escriba su correo electronico:")
case $? in
         0)
		if [ ! -f "${authUser:-NULL}.user.asc" ]
			then
				zenity --error \
				--text="El usuario ${authUser:-NULL} no existe en el sistema"
				exit 1
		fi
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

authPasswd=$(zenity --entry \
	--title="Password" \
	--text="Escriba su password:" \
	--hide-text)

case $? in
         0)
		user="$(gpg --batch --passphrase "${authPasswd:-NULL}" -o - -q "${authUser:-NULL}.user.asc")"
		if [ $? -ne 0 ]
			then
				zenity --error \
				--text="Password es incorrecto"
				exit 1
		fi
		echo $user
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
