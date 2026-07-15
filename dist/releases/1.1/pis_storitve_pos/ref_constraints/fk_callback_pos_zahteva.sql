alter table pis_storitve_pos.callback_posiljanje
    add constraint fk_callback_pos_zahteva
        foreign key ( zahteva_id )
            references pis_storitve_pos.zahteva ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"995fd507a735d7fc23238d26f6e6e3f693ee2a08","type":"REF_CONSTRAINT","name":"FK_CALLBACK_POS_ZAHTEVA","schemaName":"PIS_STORITVE_POS","sxml":""}