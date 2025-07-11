col USER_NAME for a18
col VALUE for a6
col COMMENT for a44

select
	apriv.USER_NAME,
	amap.name PRIVILEGE,
	decode(apriv.SUCCESS,
			'BY ACCESS', 'A',
			'BY SESSION', 'S',
			null, '-',
			apriv.SUCCESS) || '/' ||
	decode(apriv.FAILURE,
			'BY ACCESS', 'A',
			'BY SESSION', 'S',
			null, '-',
			apriv.FAILURE) "VALUE",
	case	when amap.name = 'CREATE JOB' then 'JOB'
			when amap.name like '%ANY%' then 'Recommend to audit(except SELECT statement)'
			when amap.name like 'ALTER SYSTEM' then 'Recommend to audit'
	end as "COMMENT"
from STMT_AUDIT_OPTION_MAP amap
left outer join DBA_PRIV_AUDIT_OPTS apriv
on amap.name = apriv.PRIVILEGE
where amap.name not in(
'ALTER SEQUENCE',
'ALTER TABLE',
'DATABASE LINK',
'DIRECTORY',
'GRANT DIRECTORY',
'GRANT PROCEDURE',
'GRANT SEQUENCE',
'GRANT TABLE',
'GRANT TYPE',
'INDEX',
'PROCEDURE',
'PROFILE',
'PUBLIC DATABASE LINK',
'ROLE',
'ROLLBACK SEGMENT',
'SYSTEM AUDIT',
'SYSTEM GRANT',
'TABLESPACE',
'USER',
'CLUSTER',
'CONTEXT',
'DIMENSION',
'MATERIALIZED VIEW',
'NOT EXISTS',
'PUBLIC SYNONYM',
'SEQUENCE',
'SESSION',
'SYNONYM',
'TABLE',
'TRIGGER',
'TYPE',
'VIEW',
'COMMENT TABLE',
'DELETE TABLE',
'EXECUTE PROCEDURE',
'INSERT TABLE',
'LOCK TABLE',
'SELECT SEQUENCE',
'SELECT TABLE',
'UPDATE TABLE')
order by amap.name;


select
	astmt.USER_NAME,
	amap.name AUDIT_OPTION,
	decode(astmt.SUCCESS,
			'BY ACCESS', 'A',
			'BY SESSION', 'S',
			null, '-',
			astmt.SUCCESS) || '/' ||
	decode(astmt.FAILURE,
			'BY ACCESS', 'A',
			'BY SESSION', 'S',
			null, '-',
			astmt.FAILURE) "VALUE",
	case	when amap.name like 'GRANT%' then 'Recommend to audit'
	end as "COMMENT"
from STMT_AUDIT_OPTION_MAP amap
left outer join DBA_STMT_AUDIT_OPTS astmt
on amap.name = astmt.AUDIT_OPTION
where amap.name in(
'ALTER SEQUENCE',
'ALTER TABLE',
'DATABASE LINK',
'DIRECTORY',
'GRANT DIRECTORY',
'GRANT PROCEDURE',
'GRANT SEQUENCE',
'GRANT TABLE',
'GRANT TYPE',
'INDEX',
'PROCEDURE',
'PROFILE',
'PUBLIC DATABASE LINK',
'ROLE',
'ROLLBACK SEGMENT',
'SYSTEM AUDIT',
'SYSTEM GRANT',
'TABLESPACE',
'USER',
'CLUSTER',
'CONTEXT',
'DIMENSION',
'MATERIALIZED VIEW',
'NOT EXISTS',
'PUBLIC SYNONYM',
'SEQUENCE',
'SESSION',
'SYNONYM',
'TABLE',
'TRIGGER',
'TYPE',
'VIEW',
'COMMENT TABLE',
'DELETE TABLE',
'EXECUTE PROCEDURE',
'INSERT TABLE',
'LOCK TABLE',
'SELECT SEQUENCE',
'SELECT TABLE',
'UPDATE TABLE')
order by amap.name;

show parameter audit