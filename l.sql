set lines 180 pages 60 trims on
col HOST_NAME for a16
col OSUSER for a16
col INST_ID for 999999
col "SESSION" for a12
col SPID for a12
col USERNAME for a16
col OWNER for a16
col OBJECT_NAME for a32
col TABLE_NAME for a32
col INDEX_NAME for a32
col PARTITION_NAME for a32
col OBJECT_TYPE for a32
col SEGMENT_NAME for a32
col DIRECTORY_PATH for a64
col FILE_NAME for a42
col MEMBER for a42
col sessid new_value v_sessid for a6
col MB for 999,999.99
col GB for 999,999.99

COLUMN name_col_plus_show_param FORMAT a30
COLUMN value_col_plus_show_param FORMAT a72

def _EDITOR=vi

set describe depth all linenum on indent on
set feedback off

alter session set nls_date_format = 'DD-MON-YYYY HH24:MI';

select INSTANCE_NAME, HOST_NAME, STARTUP_TIME, STATUS, ARCHIVER
from v$instance;



select a.INST_ID, trim(a.SID) sessid, a.SERIAL#, b.SPID, a.USERNAME, a.OSUSER, a.LOGON_TIME
from gv$session a, gv$process b
where a.PADDR = b.ADDR
and a.INST_ID = b.INST_ID
and a.sid = (select sid from v$mystat where rownum=1);

set sqlprompt "_user'['&v_sessid']@'_connect_identifier:SQL> "
set feedback on

prompt
