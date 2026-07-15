alter table pis_storitve_pos.priponka
    add constraint fk_priponka_zahteva
        foreign key ( zahteva_id )
            references pis_storitve_pos.zahteva ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"ce3e79eb9e7a43a5b33dd78c4be71b0587837582","type":"REF_CONSTRAINT","name":"FK_PRIPONKA_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":""}