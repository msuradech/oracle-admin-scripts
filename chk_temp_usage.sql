set lines 170
col username for a12
col session_id for a12
col TABLESPACE for a18

select
        a.USERNAME,
        c.SID||','||c.SERIAL# session_id,
        c.STATUS,
        a.SQL_ID,
        a.TABLESPACE,
        a.CONTENTS,
        a.SEGTYPE,
        a.SEGFILE#,
        a.SEGBLK#,
        a.EXTENTS,
        a.BLOCKS,
        a.SEGRFNO#,
        b.USED_BLOCKS
from V$SORT_USAGE a, V$SORT_SEGMENT b, V$SESSION c
where a.tablespace = b.tablespace_name
and a.SESSION_NUM = c.SERIAL#
order by TABLESPACE, USERNAME, SESSION_ID, SQL_ID, TABLESPACE, CONTENTS, SEGTYPE
/
