set lines 180 pages 100 verify off
col owner for a12
col object_name for a32
col object_type for a16
col SUBOBJECT_NAME for a32


select OBJECT_ID, OWNER, OBJECT_NAME, SUBOBJECT_NAME,
OBJECT_TYPE, STATUS , CREATED, LAST_DDL_TIME
from dba_objects
where lower(object_name) like lower('%&1%')
and lower(object_type) like lower('%&2%')
and object_name not like '%/%'
order by 1,2,3
/



