-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784202119601 stripComments:false  logicalFilePath:stage\1.6\pis_storitve_pos\tables\tmp_test2058.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2058.sql:null:4beaa7447cbca8326e7c3920a0ac41894f360179:create

create table pis_storitve_pos.tmp_test2058 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char),
    age     number,
    newage  number
);

