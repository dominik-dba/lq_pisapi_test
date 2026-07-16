-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784205914817 stripComments:false  logicalFilePath:stage\1.7\pis_storitve_pos\tables\tmp_test2059.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2059.sql:null:1474379fc52e18d354efb07ca8268ac3469e8e03:create

create table pis_storitve_pos.tmp_test2059 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number,
    naslov  varchar2(200 char),
    naselje varchar2(200 char)
);

