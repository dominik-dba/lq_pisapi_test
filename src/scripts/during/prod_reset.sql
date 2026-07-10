   set echo on
set feedback on
whenever sqlerror exit sql.sqlcode

select global_name
  from global_name;

begin
   execute immediate 'drop user PIS_STORITVE_POS cascade';
exception
   when others then
      if sqlcode != -1918 then
         raise;
      end if;
end;
/

begin
   execute immediate 'drop user PIS_STORITVE_APP cascade';
exception
   when others then
      if sqlcode != -1918 then
         raise;
      end if;
end;
/

@namesti_dba.sql
@parameters_prod.sql

commit;