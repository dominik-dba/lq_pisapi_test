-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784277733221 stripComments:false  logicalFilePath:stage\1.14\pis_storitve_pos\tables\tmp_test2066.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2066.sql:null:4837e022203eb61feda3b8c499bfdd9387e702c9:create

create table pis_storitve_pos.tmp_test2066 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char)
);

