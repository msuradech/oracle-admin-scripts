col name for a12
col TOTAL_MB for 99,999,999
col FREE_MB for 99,999,999
col PCT_USED for 999.99
col PATH for a42

select
   group_number,
   name,
   STATE,
   TOTAL_MB,
   FREE_MB,
   (TOTAL_MB-FREE_MB)/TOTAL_MB*100 PCT_USED
from
   v$asm_diskgroup
order by group_number;

select
GROUP_NUMBER,
   mount_status,
   header_status,
   mode_status,
   state,
   total_mb,
   free_mb,
   name,
   path,
   label
from
   v$asm_disk
order by GROUP_NUMBER, name, path;