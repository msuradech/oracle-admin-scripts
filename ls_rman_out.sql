set pages 0

select output 
from v$rman_output 
where session_recid=&1
order by RECID;

set pages 100