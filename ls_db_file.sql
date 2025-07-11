set pages 0 feedback off
col file_name for a64
col name for a64
col member for a64
col MB for 999,999,999.99
select file_name, bytes/1024/1024 MB from dba_data_files order by 1;
select file_name, bytes/1024/1024 MB from dba_temp_files order by 1;
select name, BLOCK_SIZE*FILE_SIZE_BLKS/1024/1024 MB from v$controlfile order by 1;
select f.member, l.bytes/1024/1024 MB from v$logfile f, v$log l where l.group# = f.group#;
set pages 40 feedback on