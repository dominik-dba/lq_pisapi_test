-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784279853331 stripComments:false  logicalFilePath:stage\1.15\pis_storitve_pos\tables\tmp_test2067.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2067.sql:null:ef00564e2a5262a68b64db1b165546d1e160809a:create

create table pis_storitve_pos.tmp_test2067 (
    id      number,
    ime     varchar2(200 char),
    priimek varchar2(200 char)
);

