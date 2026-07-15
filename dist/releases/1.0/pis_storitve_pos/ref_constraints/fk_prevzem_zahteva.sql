alter table pis_storitve_pos.prevzem
    add constraint fk_prevzem_zahteva
        foreign key ( zahteva_id )
            references pis_storitve_pos.zahteva ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"8b33329d79911634050611d16dac9124f79d418a","type":"REF_CONSTRAINT","name":"FK_PREVZEM_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":""}