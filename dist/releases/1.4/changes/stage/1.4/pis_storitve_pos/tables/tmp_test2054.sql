-- liquibase formatted sql
-- changeset PIS_STORITVE_POS:1784195915370 stripComments:false  logicalFilePath:stage\1.4\pis_storitve_pos\tables\tmp_test2054.sql
-- sqlcl_snapshot src/database/pis_storitve_pos/tables/tmp_test2054.sql:4e0b17b3b69b1770bba8e81ef23cff7ad796c469:a7e1c4c511131f429fd321b42f73d5ee43d0d4ff:alter

alter table pis_storitve_pos.tmp_test2054 add (
    newage number
)
/

