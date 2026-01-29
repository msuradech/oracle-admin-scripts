#!/bin/bash

cpunum=`lscpu | awk -F: '/^CPU\(s\):/ {print $2}' | xargs`
cpumodel=`lscpu | awk -F: '/Model name/ {print $2}' | xargs`
memsize=`lsmem | awk -F: '/Total online memory/ {print $2}' | xargs`

ps -ef | grep ora_pmon | grep -v grep | awk '{print $8}' | while read pmon
do
instname=$(echo $pmon | awk -F_ '{print $3}')
echo "${cpunum}|${cpumodel}|${memsize}|${instname}"
done