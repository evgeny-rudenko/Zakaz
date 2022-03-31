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
QUANTITY = sum (r.QUANTITY ) ,
SUM_SUPPLIER = sum (r.SUM_SUPPLIER) ,
SUM_SAL = SUM( r.SUM_SAL )
from {{ ref('remains') }} r , {{ ref('store') }} s
-- исключаем остатки из отделлов с минимальным ассортиментом
-- там лежат товары для выполнения лицензионных требований и 
-- те товары, которые не нашли и вывели с остатков до инвентаризации
where r.ID_STORE =s.id_store and s.store_name not like '%минасс%' 
group by s.id_contractor , s.contractor_name ,
r.NM 