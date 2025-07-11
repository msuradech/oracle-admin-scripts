col TABLE_NAME for a32
col CONSTRAINT_NAME for a32
col COLUMN_NAME for a24
col R_CONST for a32
col status for a12

SELECT a.table_name, 
       a.constraint_name,
	   a.position,
       a.column_name,
	   c2.table_name||'.'||c.R_CONSTRAINT_NAME R_CONST,
	   c.DELETE_RULE,
	   c.status
FROM DBA_CONS_COLUMNS A, DBA_CONSTRAINTS C, DBA_CONSTRAINTS C2
where A.CONSTRAINT_NAME = C.CONSTRAINT_NAME
  and c.R_CONSTRAINT_NAME = C2.constraint_name
  and a.owner='&1'
--  and a.table_name='SERVICE_STATUS'
  and C.CONSTRAINT_TYPE = 'R'
order by a.table_name, a.constraint_name, a.position;