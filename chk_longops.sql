set lines 200
col SESSION_ID for a12
col opname for a20
col message for a74
col SQL_PLAN_OPTIONS for a18
col UNITS for a8
col TARGET for a32
col "ELAPSE" for 99999999 heading "Elapse Time|In Second"
col "Estimate" for 99999999 heading "Est. Time|In Second"
col PCT for 999.99
undef sess_id

select
	SID||','||SERIAL# SESSION_ID,
	START_TIME,
	--LAST_UPDATE_TIME,
	(LAST_UPDATE_TIME - START_TIME)*60*60*24 as "ELAPSE",
	(((LAST_UPDATE_TIME - START_TIME)*60*60*24)/SOFAR)*(TOTALWORK-SOFAR) as "Estimate",
--	(((LAST_UPDATE_TIME - START_TIME)*60*60*24)*TOTALWORK)/(SOFAR*100) as "Estimate",
--	1/(TOTALWORK/SOFAR)*((LAST_UPDATE_TIME - START_TIME)*60*60*24) as "Estimate",
	OPNAME,
	SQL_ID,
	--SQL_PLAN_HASH_VALUE,
	--SQL_PLAN_OPERATION,
	--SQL_PLAN_OPTIONS,
	TARGET,
	SOFAR,
	TOTALWORK,
	UNITS,
	SOFAR/TOTALWORK*100 PCT
from v$session_longops
where sid=&&sess_id
--where sid=547
and sofar!=0
order by START_TIME
/

