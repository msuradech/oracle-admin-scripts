col TABLE_NAME for a42
col COLUMN_NAME for a42
col DATA_TYPE for a12

select OWNER, TABLE_NAME, COLUMN_ID, COLUMN_NAME, DATA_TYPE, NUM_DISTINCT
from DBA_TAB_COLUMNS
where column_name like upper('%&1%')
and table_name not like 'BIN$%==$0'
order by OWNER, TABLE_NAME, COLUMN_ID;