col SCHEDULE_NAME for a32
col REPEAT_INTERVAL for a44

select
        owner,
        job_name,
        SCHEDULE_NAME,
        REPEAT_INTERVAL,
        job_type,
        ENABLED
from DBA_SCHEDULER_JOBS
order by owner, SCHEDULE_NAME, job_name
/
