-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784197509441 stripComments:false  logicalFilePath:stage\1.5\pis_storitve_pos\tables\tmp_test2057.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2057.sql:null:b1ec24be6cf5dcd0a740071178271cf4770c80d1:create

create table pis_storitve_pos.tmp_test2057 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number
);

