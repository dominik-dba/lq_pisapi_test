-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784283198583 stripComments:false  logicalFilePath:stage\1.16\pis_storitve_pos\tables\tmp_test2068.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2068.sql:null:7c6251f90ae3676d2572f0163f2dc94e8dab4e6c:create

create table pis_storitve_pos.tmp_test2068 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char)
);

