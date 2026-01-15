col member for a64
select
        l.group#,
        l.thread#,
        l.sequence#,
		lf.TYPE,
        lf.member,
        l.bytes/1024/1024 mb,
        l.ARCHIVED,
        l.STATUS,
        l.FIRST_TIME
from v$log l, v$logfile lf
where l.group# = lf.group#
union
select
        l.group#,
        l.thread#,
        l.sequence#,
		lf.TYPE,
        lf.member,
        l.bytes/1024/1024 mb,
        l.ARCHIVED,
        l.STATUS,
        l.FIRST_TIME
from v$standby_log l, v$logfile lf
where l.group# = lf.group#
order by group#, member;