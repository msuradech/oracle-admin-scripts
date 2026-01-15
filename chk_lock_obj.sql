col OWNER for a10
col OBJECT_NAME for a28 trunc
col MACHINE for a20 trunc
col OSUSER for a18 trunc
col PROGRAM for a20 trunc
col OBJECT_TYPE for a12 trunc
col SESSION for a14


select
   a.inst_id,
   c.owner,
   c.object_name,
   c.object_type,
   b.sid || ',' || b.serial# "SESSION",
   b.status,
   b.osuser,
   b.machine,
   b.program,
   b.logon_time
from
   gv$locked_object a ,
   gv$session b,
   dba_objects c
where
a.inst_id = b.inst_id
and b.sid = a.session_id
and a.object_id = c.object_id;