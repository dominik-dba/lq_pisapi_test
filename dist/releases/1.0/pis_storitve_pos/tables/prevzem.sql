create table pis_storitve_pos.prevzem (
    id              number(19, 0) not null enable,
    version         number(19, 0) not null enable,
    zahteva_id      number(19, 0) not null enable,
    prevzem_obdelan number(1, 0) not null enable,
    datum_obvestila timestamp(6) not null enable,
    datum_cre       timestamp(6) not null enable,
    datum_mod       timestamp(6),
    odgovor_id      number(19, 0)
);

create unique index pis_storitve_pos.pk_prevzem on
    pis_storitve_pos.prevzem (
        id
    );

alter table pis_storitve_pos.prevzem
    add constraint pk_prevzem
        primary key ( id )
            using index pis_storitve_pos.pk_prevzem enable;


-- sqlcl_snapshot {"hash":"97df3636c153a297a6454d614f575cee2ff98cc8","type":"TABLE","name":"PREVZEM","schemaName":"PIS_STORITVE_POS","sxml":"\n  <TABLE xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n   <NAME>PREVZEM</NAME>\n   <RELATIONAL_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>19</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>VERSION</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>19</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ZAHTEVA_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>19</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>PREVZEM_OBDELAN</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>1</PRECISION>\n            <SCALE>0</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM_OBVESTILA</NAME>\n            <DATATYPE>TIMESTAMP</DATATYPE>\n            <SCALE>6</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM_CRE</NAME>\n            <DATATYPE>TIMESTAMP</DATATYPE>\n            <SCALE>6</SCALE>\n            <NOT_NULL></NOT_NULL>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>DATUM_MOD</NAME>\n            <DATATYPE>TIMESTAMP</DATATYPE>\n            <SCALE>6</SCALE>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <NAME>ODGOVOR_ID</NAME>\n            <DATATYPE>NUMBER</DATATYPE>\n            <PRECISION>19</PRECISION>\n            <SCALE>0</SCALE>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n      <PRIMARY_KEY_CONSTRAINT_LIST>\n         <PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n            <NAME>PK_PREVZEM</NAME>\n            <COL_LIST>\n               <COL_LIST_ITEM>\n                  <NAME>ID</NAME>\n               </COL_LIST_ITEM>\n            </COL_LIST>\n            <USING_INDEX></USING_INDEX>\n         </PRIMARY_KEY_CONSTRAINT_LIST_ITEM>\n      </PRIMARY_KEY_CONSTRAINT_LIST>\n      <DEFAULT_COLLATION>USING_NLS_COMP</DEFAULT_COLLATION>\n      <PHYSICAL_PROPERTIES>\n         <HEAP_TABLE></HEAP_TABLE>\n      </PHYSICAL_PROPERTIES>\n   </RELATIONAL_TABLE>\n</TABLE>"}