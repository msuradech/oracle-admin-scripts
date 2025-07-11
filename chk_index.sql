UNDEFINE OWNER
UNDEFINE TABLE
UNDEFINE spool_log
set lines 180 pages 300 verify off
col segment_name for a32
col segment_type for a16
col OBJECT_TYPE for a16
col MB for 999,999.99
col column_name for a32
col INDEX_OWNER for a16
col OWNER for a14
col TABLE_OWNER for a16
col COLUMN_EXPRESSION for a42
col spool_name new_value spool_log
col TYPE for a12
col table_name for a32
col index_name for a32
col PARTITION_NAME for a32
col NUM_BUCK for 999999

alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';

--select 'chk_index_'||'&&OWNER'||'_'||'&&TABLE'||to_char(sysdate,'_YYYYMMDD_HHMM')||'.out' spool_name from dual;
select 'chk_index_'||instance_name||'_'||'&&OWNER'||'_'||'&&TABLE'||'_'||to_char(sysdate,'YYYYMMDD_HH24MI')||'.out' spool_name from v$instance;

spool &&spool_log

PROMPT #### Non-Partition object;

select a.owner, a.segment_name, a.segment_type, a.PARTITION_NAME, a.bytes/1024/1024 MB, a.tablespace_name
from dba_segments a
where a.segment_type not in('TABLE PARTITION','INDEX PARTITION')
and a.owner=upper('&&OWNER')
and (a.segment_name=upper('&&TABLE')
	or a.segment_name in(select c.index_name
		from dba_indexes c
		where c.owner=upper('&&OWNER')
		and c.table_name=upper('&&TABLE')))
order by a.owner, a.segment_type desc, a.segment_name, a.PARTITION_NAME;

PROMPT #### Partition object;

select a.owner, a.segment_name, a.segment_type, a.PARTITION_NAME, a.bytes/1024/1024 MB, a.tablespace_name
from dba_segments a
where a.segment_type in('TABLE PARTITION','INDEX PARTITION')
and a.owner=upper('&&OWNER')
and (a.segment_name=upper('&&TABLE')
	or a.segment_name in(select c.index_name
		from dba_indexes c
		where c.owner=upper('&&OWNER')
		and c.table_name=upper('&&TABLE')))
order by a.owner, a.segment_type desc, a.segment_name, a.PARTITION_NAME;

PROMPT #### Table and Index statistic;

select * from (
select a.owner, b.object_name, b.object_type, a.blocks BLOCKS, a.num_rows, a.sample_size, a.last_analyzed, b.created, b.last_ddl_time
from dba_tables a, dba_objects b
where a.owner = upper('&&OWNER')
and a.table_name = upper('&&TABLE')
and a.owner = b.owner
and a.table_name = b.object_name
union all
select a.owner, b.object_name, b.object_type, null BLOCKS, a.num_rows, a.sample_size, a.last_analyzed, b.created, b.last_ddl_time
from dba_indexes a, dba_objects b
where a.owner = upper('&&OWNER')
and a.table_name = upper('&&TABLE')
and a.owner = b.owner
and a.index_name = b.object_name)
order by OBJECT_TYPE desc, OBJECT_NAME;

PROMPT #### Index;

col UNIQ for a4
col INDEX_TYPE for a14
col DEGREE for a8
select
--	OWNER,
	INDEX_NAME,
	decode(INDEX_TYPE,
	 'FUNCTION-BASED NORMAL', 'F-BASE NORMAL',
	 'FUNCTION-BASED BITMAP', 'F-BASE BITMAP',
	 INDEX_TYPE) INDEX_TYPE,
	decode(UNIQUENESS,
     'UNIQUE', 'Y',
     'NONUNIQUE', 'N',
	 UNIQUENESS) UNIQ,
	COMPRESSION,
--	PREFIX_LENGTH,
	LOGGING,
	BLEVEL,
	LEAF_BLOCKS,
	DISTINCT_KEYS,
--	AVG_LEAF_BLOCKS_PER_KEY,
--	AVG_DATA_BLOCKS_PER_KEY,
	CLUSTERING_FACTOR,
	STATUS,
--	NUM_ROWS,
--	SAMPLE_SIZE,
--	LAST_ANALYZED,
	DEGREE
from DBA_INDEXES
where OWNER=upper('&&OWNER')
and TABLE_NAME=upper('&&TABLE')
order by INDEX_NAME;

PROMPT #### Index column;

break on INDEX_OWNER on TABLE_NAME on INDEX_NAME
select a.INDEX_OWNER, a.TABLE_NAME, a.INDEX_NAME, a.COLUMN_POSITION "POSITION", a.COLUMN_NAME,
b.NUM_DISTINCT, b.NUM_NULLS, b.NUM_BUCKETS NUM_BUCK
  from DBA_IND_COLUMNS a, DBA_TAB_COLUMNS b
  where a.TABLE_NAME =upper('&&TABLE') and a.INDEX_OWNER = upper('&&OWNER')
  and a.INDEX_OWNER = b.OWNER
  and a.TABLE_NAME = b.TABLE_NAME
  and a.COLUMN_NAME = b.COLUMN_NAME
  order by a.TABLE_NAME, a.INDEX_NAME, a.COLUMN_POSITION;
clear break

PROMPT #### Index expression;

select INDEX_OWNER, TABLE_NAME, INDEX_NAME, COLUMN_POSITION "POSITION", COLUMN_EXPRESSION
from dba_ind_expressions
where INDEX_OWNER = upper('&&OWNER')
and TABLE_NAME =upper('&&TABLE')
order by TABLE_NAME, INDEX_NAME, COLUMN_POSITION;

PROMPT #### Constraint;

set pages 1000
col SEARCH_CONDITION for a42
col R_OWNER for a14
col constraint_name for a30
col R_CONST for a30
col TYPE for a12

select 
	--OWNER,
   decode(constraint_type,
     'C', 'Check',
     'O', 'R/O View',
     'P', 'Primary',
     'R', 'Foreign',
     'U', 'Unique',
     'V', 'Check view') type,
   constraint_name,
   SEARCH_CONDITION,
   decode(R_OWNER,
	null, '',
   R_OWNER || '.' || R_CONSTRAINT_NAME) R_CONST,
--   DELETE_RULE,
   status,
   last_change
from    
   dba_constraints
where
   table_name = upper('&&TABLE') 
   and OWNER = upper('&&OWNER')
order by type desc;


PROMPT #### Foreign Key;

col R_CONST for a42

break on table_name on CONSTRAINT_NAME

SELECT a.table_name, 
       a.constraint_name,
	   a.position,
       a.column_name,
	   c2.table_name||'.'||c.R_CONSTRAINT_NAME R_CONST,
	   c.DELETE_RULE
FROM DBA_CONS_COLUMNS A, DBA_CONSTRAINTS C, DBA_CONSTRAINTS C2
where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  and c.R_CONSTRAINT_NAME = C2.constraint_name
  and a.owner = upper('&&OWNER')
  and a.table_name = upper('&&TABLE') 
  and C.CONSTRAINT_TYPE = 'R'
order by a.table_name, a.constraint_name, a.position;

clear break

set pages 300

PROMPT #### Column Info;
col DATA_DEFAULT for a18
  
select OWNER, TABLE_NAME, COLUMN_NAME, DATA_DEFAULT, 
NUM_DISTINCT, NUM_NULLS, NUM_BUCKETS NUM_BUCK, LAST_ANALYZED, HISTOGRAM
from dba_tab_columns
where owner=upper('&&OWNER')
and table_name=upper('&&TABLE')
order by NUM_DISTINCT;


col STALE_STATS for a12
col LOCKED for a8
select * from (
select OWNER, TABLE_NAME OBJECT_NAME, PARTITION_NAME, OBJECT_TYPE, CHAIN_CNT,
  EMPTY_BLOCKS, STATTYPE_LOCKED "LOCKED", STALE_STATS
  from DBA_TAB_STATISTICS where OWNER = upper('&&OWNER')
  and table_name = upper('&&TABLE')
union all  
select OWNER, INDEX_NAME OBJECT_NAME, PARTITION_NAME, OBJECT_TYPE, null CHAIN_CNT,
  null EMPTY_BLOCKS, STATTYPE_LOCKED "LOCKED", STALE_STATS
  from DBA_IND_STATISTICS where OWNER = upper('&&OWNER')
  and table_name = upper('&&TABLE'))
order by OBJECT_TYPE desc, OBJECT_NAME;

spool off
