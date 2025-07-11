set lines 300 pages 100 verify off
col MB for 999,999.99
col incre_MB for 999,999.99
col MAX_MB for 999,999.99
col file_name for a64
col TABLESPACE_NAME for a16


column value new_val blksize
select value from v$parameter where name = 'db_block_size';

select TABLESPACE_NAME, SEGMENT_NAME, STATUS, SUM(bytes)/1024/1024 MB
  from dba_undo_extents
  group by TABLESPACE_NAME, SEGMENT_NAME, STATUS
  ORDER by TABLESPACE_NAME,STATUS;

break   on report 
compute sum of MB on report 
compute sum of MAX_MB on report

 
select TABLESPACE_NAME,STATUS, SUM(bytes)/1024/1024 MB
  from dba_undo_extents
  group by TABLESPACE_NAME, STATUS
  ORDER by TABLESPACE_NAME, STATUS;

show parameter undo_retention
  
select TABLESPACE_NAME, FILE_ID, FILE_NAME, 
BYTES/1024/1024 MB, (INCREMENT_BY*&&blksize)/1024/1024 incre_MB, MAXBYTES/1024/1024 MAX_MB
from dba_data_files
where tablespace_name in (select TABLESPACE_NAME from dba_tablespaces where CONTENTS='UNDO');

clear breaks;