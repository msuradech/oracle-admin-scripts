#!/bin/bash

#########################################################
# note** for Oracle 19c or later

v_host=`hostname`
v_cpumodel=`lscpu | awk -F: '/Model name/ {print $2}' | xargs`
v_cpunum=`lscpu | awk -F: '/^CPU\(s\):/ {print $2}' | xargs`
v_memsize=`lsmem | awk -F: '/Total online memory/ {print $2}' | xargs`

# ===== header mode =====
if [ "$1" = "header" ]; then
  echo "HOST|CPU_MODEL|CPU_NUM|MEM_SIZE|DB_NAME|INST_NAME|VERSION|EDITION|CDB|MEMORY_TARGET|SGA_TARGET|PGA_TARGET|DB_SIZE_GB|TEMP_SIZE_GB"
fi

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
  (select name from v\$database) || '|' ||
  (select instance_name from v\$instance) || '|' ||
  (select version from v\$instance) || '|' ||
  (select edition from v\$instance) || '|' ||
  (select cdb from v\$database) || '|' ||
  (select value from v\$parameter where name='memory_target') || '|' ||
  (select value from v\$parameter where name='sga_target') || '|' ||
  (select value from v\$parameter where name='pga_aggregate_target') || '|' ||
  round((select sum(bytes) from cdb_data_files)/1024/1024/1024,2) || '|' ||
  round((select sum(bytes) from cdb_temp_files)/1024/1024/1024,2)
from dual;
exit;
EOF
)
	
	echo "${v_host}|${v_cpumodel}|${v_cpunum}|${v_memsize}|${dbinfo}"
done