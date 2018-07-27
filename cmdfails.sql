set headsep off
set head off
set pagesize 0
set trimspool on
set feed off
set linesize 2000
set verify off
set echo off

spool cmdfails.csv

select
'"' || JOB_NAME || '",' ||
'"' || JOB_GROUP || '",' ||
'"' || ASSIGN_GROUP || '",' ||
'"' || RUN_MACHINE || '",' ||
JOID || ',' ||
RUN_NUM || ',' ||
NTRY || ',' ||
START_TIME || ',' ||
'"' || TO_CHAR(START_DATE, 'YYYY-MM-DD HH24:MI:SS') || '",' ||
END_TIME || ',' ||
'"' || TO_CHAR(END_DATE, 'YYYY-MM-DD HH24:MI:SS') || '",' ||
RUNTIME || ',' ||
'"' || END_STATUSTXT || '",' ||
'"' || EXIT_CODE || '",' || 
'"' || REFERENCE || '",' ||
'"' || TO_CHAR(PROC_DATE, 'YYYY-MM-DD') || '"' RUN_INFO
FROM REP_ASYS_JOB_RUNS
WHERE PROC_DATE >= SYSDATE - 365
AND END_STATUS IN (5,6)
AND JOB_TYPE = 'c'
AND ACTIVE = 1
AND REFERENCE LIKE 'INC%'
;

spool off
quit;


