#!/bin/bash

ps -ef | grep ora_pmon | egrep -v 'grep|awk' | awk -Fora_pmon_ '{print $2}' |while read v_instname
do
	v_dbname=$(echo ${v_instname} | awk -F_ '{print tolower($1)}')
	v_adrci_home=`adrci exec="show home" | grep rdbms | grep ${v_instname} | grep ${v_dbname}`
	adrci exec="set home ${v_adrci_home}; show problem;"
done