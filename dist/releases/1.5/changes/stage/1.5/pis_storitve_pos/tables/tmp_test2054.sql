-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784197510047 stripComments:false  logicalFilePath:stage\1.5\pis_storitve_pos\tables\tmp_test2054.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2054.sql:713ae1e693c987ab0128701d714c8520c5d84712:9c2289c40647384b0fdd528f39aeb48757fdc03c:alter

alter table pis_storitve_pos.tmp_test2054 add (
    naslov varchar2(200 char)
)
/

alter table pis_storitve_pos.tmp_test2054 add (
    naselje varchar2(200 char)
)
/

