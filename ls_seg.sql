select owner, segment_name, segment_type, tablespace_name, bytes/1024/1024 mb
from dba_segments
where segment_name='&1';
