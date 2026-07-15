alter table pis_storitve_pos.prevzem
    add constraint fk_prevzem_odgovor
        foreign key ( odgovor_id )
            references pis_storitve_pos.odgovor ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"935934c9680fe95e9535ee9232d206dec852d917","type":"REF_CONSTRAINT","name":"FK_PREVZEM_ODGOVOR","schemaName":"PIS_STORITVE_POS","sxml":""}