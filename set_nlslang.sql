col command for a64

select 'export NLS_LANG='||lang.value||'_'||terr.value||'.'||cset.value command
from
(select VALUE from v$nls_parameters where PARAMETER='NLS_LANGUAGE') lang,
(select VALUE from v$nls_parameters where PARAMETER='NLS_TERRITORY') terr,
(select VALUE from v$nls_parameters where PARAMETER='NLS_CHARACTERSET') cset
/