create index pis_storitve_pos.idx_odgovor_zahteva on
    pis_storitve_pos.odgovor (
        zahteva_id
    );


-- sqlcl_snapshot {"hash":"912f6cc5c71b2ff3081d22a9e6bd956611ee3bd5","type":"INDEX","name":"IDX_ODGOVOR_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n   <NAME>IDX_ODGOVOR_ZAHTEVA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n         <NAME>ODGOVOR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZAHTEVA_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}