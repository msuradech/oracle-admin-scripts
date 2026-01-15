col "recid/parent/rlevel" for a16
col duration_min for 9999999.99
col DEVICE_TYPE for a10
col operation for a12
col row_type for a12
col object_type for a16
col status for a14
col "ROW_TYPE/OPERATION/OBJECT_TYPE" for a32
col MBYTES_PROC for 99,999,999
col "input/output gbytes" for a28

select a.recid||'/'||a.parent_recid||'/'||a.row_level as "recid/parent/rlevel",
    a.OUTPUT_DEVICE_TYPE DEVICE_TYPE,
    a.row_type || '/' || a.operation || '/' || a.object_type "ROW_TYPE/OPERATION/OBJECT_TYPE",
    decode(a.status,'COMPLETED WITH ERRORS','COMP WITH ERR',status) STATUS,
    a.mbytes_processed MBYTES_PROC,
    a.start_time, a.end_time,
	(a.end_time - a.start_time)*24*60 duration_min,
    to_char(a.input_bytes/1024/1024/1024,'99,999.99') || '/' || 
	to_char(a.output_bytes/1024/1024/1024,'99,999.99') "input/output gbytes"
from v$rman_status a
where a.OBJECT_TYPE='DB INCR'
order by a.recid;