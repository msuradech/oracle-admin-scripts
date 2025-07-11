alter session set NLS_DATE_FORMAT='DD/MM/YY HH24:MI';
col START form a30
col END form a30
set lines 500 pages 500
select snap_id,min(SAMPLE_TIME) "START",max(SAMPLE_TIME) "END",SQL_ID,SQL_CHILD_NUMBER,SQL_PLAN_HASH_VALUE 
from DBA_HIST_ACTIVE_SESS_HISTORY group by snap_id,sql_id,SQL_CHILD_NUMBER,SQL_PLAN_HASH_VALUE having SQL_ID = '&SQL_ID' order by 1;
