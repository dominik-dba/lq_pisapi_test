create index pis_storitve_pos.idx_odgovor_publicid on
    pis_storitve_pos.odgovor (
        public_id
    );


-- sqlcl_snapshot {"hash":"7534604a9efeef462ff60964084bd6a219da08e8","type":"INDEX","name":"IDX_ODGOVOR_PUBLICID","schemaName":"PIS_STORITVE_POS","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n   <NAME>IDX_ODGOVOR_PUBLICID</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n         <NAME>ODGOVOR</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>PUBLIC_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}