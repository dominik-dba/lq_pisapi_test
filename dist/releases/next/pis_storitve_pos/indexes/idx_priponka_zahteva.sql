create index pis_storitve_pos.idx_priponka_zahteva on
    pis_storitve_pos.priponka (
        zahteva_id
    );


-- sqlcl_snapshot {"hash":"9a3ea53e637e7594e1b734c4444f33d6a33268cb","type":"INDEX","name":"IDX_PRIPONKA_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n   <NAME>IDX_PRIPONKA_ZAHTEVA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n         <NAME>PRIPONKA</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZAHTEVA_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}