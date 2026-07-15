create index pis_storitve_pos.idx_callback_pos_zahteva on
    pis_storitve_pos.callback_posiljanje (
        zahteva_id
    );


-- sqlcl_snapshot {"hash":"5f261aec95adfeab5119b544aee120244b661612","type":"INDEX","name":"IDX_CALLBACK_POS_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n   <NAME>IDX_CALLBACK_POS_ZAHTEVA</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n         <NAME>CALLBACK_POSILJANJE</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ZAHTEVA_ID</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}