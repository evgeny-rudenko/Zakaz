{{
  config(
    materialized = 'table',
    as_columnstore = false
    
    )
}}
SELECT 
ID_CONTRACTOR = s2.id_contractor ,
CONTRACTOR_NAME = s2.contractor_name ,
si.DOCUMENT_STATE  ,
si.DOCUMENT_DATE  ,
sgn.NM, 
quantity = sum (quantity*ssr.SCALING_K) ,
SUM_SUPPLIER = sum (supplier_sum_vat),
SUM_SAL = sum (retail_sum_vat)
from STG_INVOICE si , STG_INVOICE_ITEM sii , STG_SCALING_RATIO ssr ,  
{{ ref('store') }} s2 ,STG_GOODS_NAMES sgn 
where si.ID_INVOICE_GLOBAL = sii.ID_INVOICE_GLOBAL 
and ssr.ID_SCALING_RATIO = sii.ID_SCALING_RATIO 
and sgn.ID_GOODS = sii.ID_GOODS 
and s2.id_store = si.ID_STORE 
and DOCUMENT_STATE != 'DEL'
group by 
DOCUMENT_STATE ,
DOCUMENT_DATE ,
sgn.NM ,
s2.id_contractor ,
s2.contractor_name 