set lines 180 verify off
col TABLESPACE_NAME for a30 trunc
col FILE_NAME for a52
col db_block new_val db_block_size for a16
col MB for 999,999,999.99
col INCRE_MB for 999,999,999.99
col MAX_MB for 999,999,999.99

select value as db_block from v$parameter where name='db_block_size';

select a.TABLESPACE_NAME, a.FILE_NAME, 
a.BYTES/1024/1024 MB, a.STATUS,
b.creation_time, a.AUTOEXTENSIBLE,
(a.INCREMENT_BY*&&db_block_size)/1024/1024 INCRE_MB, a.MAXBYTES/1024/1024 MAX_MB
from dba_temp_files a, v$datafile b
where a.file_id = b.file#
and a.TABLESPACE_NAME = '&1'
order by a.FILE_NAME;

set verify on