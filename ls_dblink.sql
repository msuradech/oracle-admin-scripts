col DB_LINK for a32
col HOST for a32

select * from dba_db_links
order by owner, db_link;