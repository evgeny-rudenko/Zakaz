{{
  config(
    materialized = 'table',
    as_columnstore = false
    
    )
}}

select 
s.id_contractor ,
s.contractor_name ,
r.NM ,
QUANTITY = sum (r.QUANTITY),
SUM_SUPPLIER = sum (r.SUM_SUPPLIER) ,
SUM_SAL = SUM( r.SUM_SAL )
from {{ ref('remains') }} r , {{ ref('store') }} s 
where r.ID_STORE =s.id_store 
group by s.id_contractor , s.contractor_name ,
r.NM 