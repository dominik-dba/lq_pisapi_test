create unique index pis_storitve_pos.task_uq on
    pis_storitve_pos.task (
        case
            unique_flag
            when 0 then
                null
            else
                context
        end,
        case
            unique_flag
            when 0 then
                null
            else
                nvl(context_id, '')
        end
    );


-- sqlcl_snapshot {"hash":"6642382463fd51af0b9aae00efad9e560c0ced58","type":"INDEX","name":"TASK_UQ","schemaName":"PIS_STORITVE_POS","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <UNIQUE></UNIQUE>\n   <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n   <NAME>TASK_UQ</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>PIS_STORITVE_POS</SCHEMA>\n         <NAME>TASK</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE \"UNIQUE_FLAG\" WHEN 0 THEN NULL ELSE \"CONTEXT\" END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n         <COL_LIST_ITEM>\n            <DEFAULT_EXPRESSION>CASE \"UNIQUE_FLAG\" WHEN 0 THEN NULL ELSE NVL(\"CONTEXT_ID\",'') END </DEFAULT_EXPRESSION>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}