col NAME for a16
col BIND_VARIABLE_NAME for a16
col DATATYPE for a24
col VALUE_STRING for a24
col bind_value for a24
col LAST_CAPTURED for a24
	
SELECT 
    sql_id,
    name AS bind_variable_name,
    value_string AS bind_value,
    datatype_string AS datatype,
	MAX_LENGTH,
    position,
	last_captured
    --to_char(last_captured,'DD-MON-YYYY HH24:MI:SS') AS LAST_CAPTURED
FROM 
    v$sql_bind_capture
WHERE 
    sql_id = '&1'
order by POSITION;