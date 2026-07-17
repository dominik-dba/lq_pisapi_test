-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784273507987 stripComments:false  logicalFilePath:stage\1.9\pis_storitve_pos\tables\tmp_test2061.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2061.sql:null:9fd8be33a23236c627b450e56ff441aae5cff87b:create

create table pis_storitve_pos.tmp_test2061 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number,
    naslov  varchar2(200 char),
    naselje varchar2(200 char)
);

