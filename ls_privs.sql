set verify off pages 100
col GRANTEE for a12
col GRANTOR for a12
col TABLE_NAME for a42

select * from dba_sys_privs where upper(grantee) = upper('&&1')
order by PRIVILEGE
/

select * from dba_role_privs where upper(grantee) = upper('&&1')
order by GRANTED_ROLE
/

select * from dba_tab_privs where upper(grantee) = upper('&&1')
order by OWNER, TABLE_NAME, PRIVILEGE
/

undef 1
