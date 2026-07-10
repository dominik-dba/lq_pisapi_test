alter table pis_storitve_pos.odgovor
    add constraint fk_odgovor_zahteva
        foreign key ( zahteva_id )
            references pis_storitve_pos.zahteva ( id )
        enable;


-- sqlcl_snapshot {"hash":"d4bd4f4eb2e7a94ba2dbcf61923dd87f6b97c9a6","type":"REF_CONSTRAINT","name":"FK_ODGOVOR_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":""}