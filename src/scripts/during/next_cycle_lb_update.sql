set echo on
set feedback on
set define on

lb update-sql -changelog-file &1 -database-changelog-table-name &2 -liquibase-schema-name &3 -default-schema-name &4 -output-default-schema false -output-file &5 
exit
