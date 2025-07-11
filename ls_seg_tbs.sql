col segment_name for a42
col partition_name for a42


select owner,
	segment_name, 
	partition_name, 
	segment_type, 
	bytes/1024/1024 mb
from dba_segments
where tablespace_name = '&1'
order by mb
/
