col OS_USERNAME for a11 truncate
col USERNAME for a8 truncate
col USERHOST for a20
col ACTION_NAME for a20
col OBJ_NAME for a34
col PRIV_USED for a18
col SCN for 9999999999999

select 
	TIMESTAMP,
	OS_USERNAME,
    USERNAME,
    USERHOST,
    ACTION_NAME,
	decode(OWNER,
			null, null,
			OWNER || '.' || OBJ_NAME) "OBJ_NAME",
    RETURNCODE,
    PRIV_USED,
	SCN
from DBA_AUDIT_TRAIL
where TIMESTAMP > sysdate-1/24
and action not in (100,101,102)
order by TIMESTAMP
/