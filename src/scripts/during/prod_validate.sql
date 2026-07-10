set echo on
set feedback on

prompt ===== VALIDATION START =====
select global_name from global_name;

prompt --- Object counts for PIS_STORITVE_POS ---
select object_type, count(*) as cnt
from all_objects
where owner = 'PIS_STORITVE_POS'
group by object_type
order by object_type;

prompt --- Object counts for PIS_STORITVE_APP ---
select object_type, count(*) as cnt
from all_objects
where owner = 'PIS_STORITVE_APP'
group by object_type
order by object_type;

prompt --- Check LB_CHANGES table presence in both schemas ---
select owner, table_name
from all_tables
where table_name = 'LB_CHANGES'
  and owner in ('PIS_STORITVE_POS', 'PIS_STORITVE_APP')
order by owner;

prompt ===== VALIDATION END =====
