set verify off

col NAME for a32
col SEGMENT_NAME for a32
col INTERVAL for a32
col PARTITION_NAME for a32
col GB for 999,999.99
col TABLE_OWNER for a12
col HIGH_VALUE for a32 trunc
col COLUMN_NAME for a32
col POSITION for 99999999

select seg.owner, 
	seg.SEGMENT_NAME, 
	tpart.PARTITION_POSITION POSITION,
	seg.PARTITION_NAME, 
	tpart.HIGH_VALUE, 
	seg.BYTES/1024/1024/1024 gb 
from dba_segments seg, DBA_TAB_PARTITIONS tpart
where seg.owner = tpart.table_owner
and seg.segment_name = tpart.table_name
and seg.PARTITION_NAME = tpart.PARTITION_NAME
and seg.owner = upper('&&1')
and seg.segment_name = upper('&&2')
order by tpart.PARTITION_POSITION;

select owner, name, column_name, column_position 
from DBA_PART_KEY_COLUMNS 
where owner = upper('&&1')
and name = upper('&&2')
order by column_position;

select INTERVAL, autolist
from dba_part_tables
where owner = upper('&&1')
and table_name = upper('&&2');

set verify on
undef 1
undef 2
