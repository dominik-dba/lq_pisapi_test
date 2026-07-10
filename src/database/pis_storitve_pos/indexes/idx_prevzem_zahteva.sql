create index pis_storitve_pos.idx_prevzem_zahteva on
    pis_storitve_pos.prevzem (
        zahteva_id
    );


-- sqlcl_snapshot {"hash":"52c608e7739392a1ac1c1f9c79965283dc0be30b","type":"INDEX","name":"IDX_PREVZEM_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n   <NAME>IDX_PREVZEM_ZAHTEVA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n         <NAME>PREVZEM</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZAHTEVA_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}