#!/bin/bash

SCRIPT_NAME=$(basename "$0")

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $SCRIPT_NAME [SID] [OWNER] [TAB_NAME] [DIRECTORY]"
	echo
    exit 1
fi

ORACLE_SID=${1}
OWNER=${2}
TABNAME=${3}
EXP_PATH=${4}

if [ -z "$4" ]; then
    EXP_PATH=$(pwd)
else
    EXP_PATH="${4}"
fi

xDATE=$(date +%Y%m%d_%H%M)
DUMP_FILE=EXP_TAB_${ORACLE_SID}_${OWNER}_${TABNAME}_${xDATE}.dmp
LOG_FILE=EXP_TAB_${ORACLE_SID}_${OWNER}_${TABNAME}_${xDATE}.log
DIR_NAME=EXP_SC_${xDATE}

sqlplus -s / as sysdba << EOF
create directory ${DIR_NAME} as '${EXP_PATH}';
EOF

expdp \"/ as sysdba\" \
directory=${DIR_NAME} \
dumpfile=${DUMP_FILE} \
logfile=${LOG_FILE} \
tables=${OWNER}.${TABNAME}

sqlplus -s / as sysdba << EOF
drop directory ${DIR_NAME};
EOF