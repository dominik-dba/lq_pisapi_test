-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784271919416 stripComments:false  logicalFilePath:stage\1.8\pis_storitve_pos\tables\tmp_test2060.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2060.sql:null:4949b3216532888abca0ae52dcf9141f26ecd48b:create

create table pis_storitve_pos.tmp_test2060 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number,
    naslov  varchar2(200 char),
    naselje varchar2(200 char)
);

