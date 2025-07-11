col owner for a12
col table_name for a24
col column_name for a24
col data_type for a24
col data_default for a24
select owner, table_name, column_name, DATA_TYPE, DATA_DEFAULT 
from dba_tab_columns 
where owner='&1' 
and table_name='&2' 
order by COLUMN_ID;