-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784274342965 stripComments:false  logicalFilePath:stage\1.11\pis_storitve_pos\tables\tmp_test2063.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2063.sql:null:4d7852650705ff0759e59cd7303fd71d8df69830:create

create table pis_storitve_pos.tmp_test2063 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number,
    naslov  varchar2(200 char),
    naselje varchar2(200 char)
);

