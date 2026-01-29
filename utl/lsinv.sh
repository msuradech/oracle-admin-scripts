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
  (select value from v\$parameter where name='memory_target') || '|' ||
  (select value from v\$parameter where name='sga_target') || '|' ||
  (select value from v\$parameter where name='pga_aggregate_target') || '|' ||
  round((select sum(bytes) from cdb_data_files)/1024/1024/1024,2) || '|' ||
  round((select sum(bytes) from cdb_temp_files)/1024/1024/1024,2)
from dual;
exit;
EOF
)
	
	echo "${v_host}|${v_cpumodel}|${v_cpunum}|${v_memsize}|${v_instname}|${dbinfo}"
done