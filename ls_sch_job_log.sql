col LOG_DATE for a18
col JOB_NAME for a32
col RUN_DURATION for a14
col SID_SR for a12
col ADDITIONAL_INFO for a24
col SLAVE_PID for a12
col JOB_SUBNAME for a2 trunc
col STATUS for a12
col INST for 9999

select
--      LOG_ID,
        substr(LOG_DATE, 0, 18) LOG_DATE,
        OWNER || '.' || JOB_NAME JOB_NAME,
        JOB_SUBNAME,
        STATUS,
        ERROR#,
        substr(REQ_START_DATE, 0, 18) REQ_START_DATE,
        substr(ACTUAL_START_DATE, 0, 18) ACTUAL_START_DATE,
        RUN_DURATION,
        INSTANCE_ID INST,
        SESSION_ID SID_SR,
        SLAVE_PID --,
--      CPU_USED,
--      ADDITIONAL_INFO
from
 DBA_SCHEDULER_JOB_RUN_DETAILS
where job_name='&job_name'
order by LOG_ID;