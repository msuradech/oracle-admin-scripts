set verify off

col SESSION# for a12
col OBJECT for a82

select 
	a.CURRENT_OBJ#,
	b.OWNER||'.'||b.OBJECT_NAME||'.'||b.SUBOBJECT_NAME||' ['||b.OBJECT_TYPE||']' OBJECT,
	count(*) WAIT_SEC
from v$active_session_history a, dba_objects b
where a.CURRENT_OBJ# = b.OBJECT_ID
and a.sql_id = '&&sqlid'
and a.SAMPLE_TIME > sysdate - &&period/24/60
group by a.CURRENT_OBJ#, b.owner, b.object_name, b.subobject_name, b.object_type
order by count(*)
/


PROMPT ### wait class for &&sqlid [last &&period minutes] 
col EVENT for a42

select a.WAIT_CLASS, a.EVENT,
--to_char(sum(a.TIME_WAITED),'999,999,999,999') "TIME_WAITED[us]"
count(*) WAIT_SEC, round(count(*)*100/sum(count(*)) over(),2) pctload
from v$active_session_history a
where a.sql_id = '&&sqlid'
and a.SAMPLE_TIME > sysdate - &&period/24/60
group by a.WAIT_CLASS, a.EVENT
--order by sum(a.TIME_WAITED) desc
order by count(*) desc
/


select a.SESSION_ID||','||a.SESSION_SERIAL# SESSION#, a.PROGRAM, a.SQL_PLAN_HASH_VALUE, count(*) WAIT_SEC
from v$active_session_history a
where a.sql_id = '&&sqlid'
and a.SAMPLE_TIME > sysdate - &&period/24/60
group by a.SESSION_ID, a.SESSION_SERIAL#, a.PROGRAM, a.SQL_PLAN_HASH_VALUE
order by count(*) desc
/

PROMPT ### chk_dba_hist_sqlstat.sql

col END_INTERVAL_TIME for a26
col EXECUTIONS for 999,999,999
col ROWS_PROC for 999,999,999
col CPU_SEC for 999,999,999
col ELAP_SEC for 999,999,999
col CC_SEC for 999,999,999
col IO_SEC for 999,999,999

select b.END_INTERVAL_TIME, a.snap_id, a.sql_id, a.PLAN_HASH_VALUE PHV,
	a.executions_delta EXECUTIONS, 
	a.rows_processed_delta ROWS_PROC, 
	a.ELAPSED_TIME_DELTA/1000000 ELAP_SEC, 
	a.CPU_TIME_DELTA/1000000 CPU_SEC,
	a.CCWAIT_DELTA/1000000 CC_SEC,
	a.IOWAIT_DELTA/1000000 IO_SEC
from dba_hist_sqlstat a, DBA_HIST_SNAPSHOT b
where  a.snap_id = b.snap_id
and a.sql_id = '&&sqlid'
and b.END_INTERVAL_TIME > sysdate - 1
order by a.snap_id
/

col OPERATION for a16
col OPTIONS for a20
col OBJECT_OWNER heading "OBJ_OWNER" for a12
col OBJECT_TYPE for a16

select SQL_ID,
	PLAN_HASH_VALUE,
	--ID,
	--TIMESTAMP,
	OPERATION,
	OPTIONS,
	--OBJECT#,
	OBJECT_OWNER,
	OBJECT_NAME,
	OBJECT_TYPE,
	CARDINALITY,
	BYTES
from V$SQL_PLAN_STATISTICS_ALL
where sql_id='&&sqlid'
order by ID
/

select owner, table_name, num_rows, sample_size, last_analyzed
from dba_tables
where table_name in (select object_name from V$SQL_PLAN_STATISTICS_ALL where sql_id='&&sqlid' and object_name is not null)
/

select owner, index_name, num_rows, sample_size, last_analyzed, status
from dba_indexes
where index_name in (select object_name from V$SQL_PLAN_STATISTICS_ALL where sql_id='&&sqlid' and object_name is not null)
/


undef sqlid;
undef period;
