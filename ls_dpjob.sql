col OWNER_NAME for a14
col JOB_NAME for a24
col OPERATION for a16
col STATE for a16
col JOB_MODE for a16
col CREATED for a22

SELECT dp.*, obj.created
FROM dba_datapump_jobs dp
left join dba_objects obj
on dp.owner_name = obj.owner
and dp.job_name = obj.object_name;


set pages 0
select 'drop table ' || dp.owner_name ||'.'|| dp.job_name ||' purge;'
from dba_datapump_jobs dp
where dp.state='NOT RUNNING';

set pages 100