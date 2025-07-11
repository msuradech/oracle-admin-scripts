set lines 180 pages 0 trims on

select * from table(dbms_xplan.display_cursor('&1',&2));

set pages 100