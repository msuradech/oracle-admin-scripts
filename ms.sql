SET LIN 250
set pages 0
set heading off
set feedback off
alter session set nls_date_language = ENGLISH ;
column "Sid,Serial#"            format a12 wrap
column sid              format 99999 trunc
column serial#          format 9999999 trunc
column username         format a10 trunc
column cpu_usage        format 99999.99
column "Ratio%"                                 format 999.99
column pid              format a9 trunc
column status           format a6 trunc
column sql_text         format a20 trunc
column lockwait         heading "Lck-W" format a5 trunc
column blocking_session_status heading "BLK Status" format a11 trunc
column blocking_session heading "BLK-S" format 99999
column event            format a20 trunc
column p1text           format a10
column p2text           format a10
column p3text           format a10
column seconds_in_wait  heading "W-Sec." format 99999
column SQL_EXEC_START                       format a14 trunc
column machine          format a15 trunc
column program          format a25 trunc
column sql_child_number heading "Ch#" format 999

--break on report
--compute count of username on report

--break on username on status
--compute count of status on status

column f1       format a60
select  'DATABASE => '||name||'    DATE => '||rtrim(to_char(sysdate,'DD MONTH YYYY hh24:mi:ss')) f1
from            v$database
;
set heading on
SET PAGES 500
/* DBA_MONITOR_SCRIPT */
SELECT ss.inst_id,
ss.sid||','||ss.serial# "Sid,Serial#"
,pr.spid as pid
,ss.username as username
--,ss.status as status
,ss.lockwait as lockwait
,ss.blocking_session
,ss.sql_id
,ss.sql_child_number
,ss.program as program
,ss.event
,p1
,p2
,p3
,ss.seconds_in_wait
--,to_char(ss.SQL_EXEC_START,'dd/mm/yy hh24:mi') as SQL_EXEC_START
,ss.machine as machine
FROM    gv$session ss,gv$process pr
WHERE pr.addr=ss.paddr
AND pr.INST_ID = ss.INST_ID
AND ss.status = 'ACTIVE'
-- AND ((ss.username is not null and ss.username not in (select user from dual)) or ss.username is null)
-- AND ((ss.username is not null and ss.username not in (select user from dual)) )
AND ((ss.username is not null ) )
order by username,status,ss.sid||','||ss.serial#
;
set feedback on
--clear breaks
