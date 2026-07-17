set echo on
set feedback on
set define on

lb diff-changelog -changelog-file &1 -reference-url &2 -reference-username &3 -reference-password &4 -default-schema-name &5 -include-schema false -diff-types=columns,foreignkeys,indexes,primarykeys,tables,sequences,uniqueconstraints,views -include-tablespace false -output-default-schema false
exit
