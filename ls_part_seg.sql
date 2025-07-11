select owner, segment_name, partition_name, segment_type, bytes/1024/1024 mb
from dba_segments
where upper(segment_name) like upper('%&1%')
order by owner, segment_name, partition_name;