set long 100000 longc 100000 lines 1000 pages 0 trims on
select sql_fulltext
from v$sql
where sql_id='&sqlid'
and rownum = 1
/


set lines 180 pages 100
