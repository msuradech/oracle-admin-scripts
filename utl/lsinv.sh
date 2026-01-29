#!/bin/bash

v_host=`hostname`
v_cpumodel=`lscpu | awk -F: '/Model name/ {print $2}' | xargs`
v_cpunum=`lscpu | awk -F: '/^CPU\(s\):/ {print $2}' | xargs`
v_memsize=`lsmem | awk -F: '/Total online memory/ {print $2}' | xargs`

ps -ef | grep ora_pmon | grep -v grep | awk '{print $8}' | while read pmon
do
	v_instname=$(echo $pmon | awk -F_ '{print $3}')
	export ORACLE_SID=$v_instname
	
	dbinfo=$(sqlplus -s / as sysdba <<EOF
set pagesize 0
set feedback off
set heading off
set verify off
select
max(case when name='memory_target' then value end) || '|' ||
max(case when name='sga_target' then value end) || '|' ||
max(case when name='pga_aggregate_target' then value end)
from v\$parameter
where name in ('memory_target','sga_target','pga_aggregate_target');
exit;
EOF
)
	
	echo "${v_host}|${v_cpumodel}|${v_cpunum}|${v_memsize}|${v_instname}|${dbinfo}"
done