-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784274068359 stripComments:false  logicalFilePath:stage\1.10\pis_storitve_pos\tables\tmp_test2062.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2062.sql:null:089bf6d7a149b11976ca4f585e08e3ee58a80a99:create

create table pis_storitve_pos.tmp_test2062 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number,
    naslov  varchar2(200 char),
    naselje varchar2(200 char)
);

