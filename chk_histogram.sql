set lines 200
set verify off
col data_type for a16
col COL_ID for 999999
col ENDPOINT_ACTUAL_VALUE for a32
col COLUMN_NAME for a24
col TABLE_NAME for a42

prompt
prompt TABLE:: &&1..&&2
select COLUMN_ID COL_ID, COLUMN_NAME, DATA_TYPE, DATA_SCALE,
NUM_DISTINCT, DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
GLOBAL_STATS, USER_STATS, HISTOGRAM
from dba_tab_columns 
where owner = upper('&&1') 
and table_name = upper('&&2')
order by COLUMN_ID
/

PAUSE

select 
--	a.OWNER||'.'||a.TABLE_NAME "TABLE_NAME",
	b.COLUMN_ID COL_ID,
	a.COLUMN_NAME,
	a.ENDPOINT_NUMBER,
	a.ENDPOINT_VALUE,
	a.ENDPOINT_ACTUAL_VALUE,
	b.HISTOGRAM
from DBA_HISTOGRAMS a, dba_tab_columns b
where a.owner = upper('&&1')
and a.table_name = upper('&&2')
and a.OWNER = b.OWNER
and a.TABLE_NAME = b.TABLE_NAME
and a.COLUMN_NAME = b.COLUMN_NAME
order by b.COLUMN_ID, a.ENDPOINT_NUMBER
/

undef 1
undef 2
set verify on
