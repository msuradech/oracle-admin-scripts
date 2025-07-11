col PROFILE for a18
col RESOURCE_NAME for a28
col LIMIT for a30

select * from dba_profiles
order by PROFILE, RESOURCE_TYPE, RESOURCE_NAME;