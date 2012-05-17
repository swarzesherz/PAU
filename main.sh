#!/bin/bash
user=$(./login.sh)
if [ $? != 0 ]
then
	exit 1
fi
export user
echo $user | awk 'BEGIN {FS=":"} {print $1}'
