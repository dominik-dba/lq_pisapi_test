-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784195914529 stripComments:false  logicalFilePath:stage\1.4\pis_storitve_pos\tables\tmp_test2056.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2056.sql:null:c391e770b7e3dd0cb5863ca0c43af860c436adf2:create

create table pis_storitve_pos.tmp_test2056 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number
);

