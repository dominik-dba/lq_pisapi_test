-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784276432729 stripComments:false  logicalFilePath:stage\1.13\pis_storitve_pos\tables\tmp_test2065.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2065.sql:null:078db79e9510a969b90a6c6b001561fa3ea3c4a7:create

create table pis_storitve_pos.tmp_test2065 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char)
);

