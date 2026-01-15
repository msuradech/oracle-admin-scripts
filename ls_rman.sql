col "recid/parent/rlevel" for a16
col DEVICE_TYPE for a10
col operation for a12
col row_type for a12
col object_type for a16
col status for a14
col "ROW_TYPE/OPERATION/OBJECT_TYPE" for a42
col MBYTES_PROC for 99,999,999
col "input/output mbytes" for a24

select recid||'/'||parent_recid||'/'||row_level as "recid/parent/rlevel",
        OUTPUT_DEVICE_TYPE DEVICE_TYPE,
        row_type || '/' || operation || '/' || object_type "ROW_TYPE/OPERATION/OBJECT_TYPE",
        decode(status,'COMPLETED WITH ERRORS','COMP WITH ERR',status) STATUS,
        mbytes_processed MBYTES_PROC,
        start_time, end_time,
        to_char(input_bytes/1024/1024,'999,999.99') || '/' || to_char(output_bytes/1024/1024,'999,999.99') "input/output mbytes"
from v$rman_status
order by recid;