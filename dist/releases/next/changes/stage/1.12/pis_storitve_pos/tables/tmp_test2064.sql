-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784274585159 stripComments:false  logicalFilePath:stage\1.12\pis_storitve_pos\tables\tmp_test2064.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2064.sql:null:661d38f241a6794d90882e138ae09b7e2a3ea936:create

create table pis_storitve_pos.tmp_test2064 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number,
    naslov  varchar2(200 char),
    naselje varchar2(200 char)
);

