alter table pis_storitve_pos.callback_posiljanje
    add constraint fk_callback_pos_odgovor
        foreign key ( odgovor_id )
            references pis_storitve_pos.odgovor ( id )
                on delete cascade
        enable;


-- sqlcl_snapshot {"hash":"cb449f583d806d5fa7ed10d8b51b6b784c19c404","type":"REF_CONSTRAINT","name":"FK_CALLBACK_POS_ODGOVOR","schemaName":"PIS_STORITVE_POS","sxml":""}