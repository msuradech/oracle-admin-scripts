set lines 2000 pages 1000 trims on colsep '!'
col SAMPLE_TIME for a32
col INST_ID for 999999
col event for a128
col spool_name new_value spool_log
col P1TEXT for a24
col P2TEXT for a24
col P3TEXT for a24

def v_date = sysdate;

select 'chk_v_ash_'||instance_name||'_'||to_char(&&v_date,'YYYYMMDD_HH24MI')||'.out' spool_name from v$instance;

spool &&spool_log

alter session set nls_date_format='YYYYMMDD HH24:MI:SS';

set feedback off
set serveroutput on
begin
dbms_output.put_line('input YYYYMMDD HH24:MI example ' || to_char(sysdate, 'YYYYMMDD HH24:MI'));
end;
/

set feedback on

select *
from v$active_session_history
where SAMPLE_TIME between to_date('&&BegTime','YYYYMMDD HH24:MI') and to_date('&&EndTime','YYYYMMDD HH24:MI')
order by SAMPLE_TIME ;


spool off
undef BegTime;
undef EndTime;
set colsep ' '
