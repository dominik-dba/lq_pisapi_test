begin
  execute immediate 'drop table pis_storitve_pos.test_2066';
exception when others then
  null;
end;
/

begin
  execute immediate 'drop table pis_storitve_pos.tmp_test6';
exception when others then
  null;
end;
/

begin
  execute immediate 'drop table pis_storitve_pos.tmp_test2052';
exception when others then
  null;
end;
/
