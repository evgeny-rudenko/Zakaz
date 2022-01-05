{{
  config(
    materialized = 'table',
    as_columnstore = false
    )
}}

-- Остатки по отделам с минимальным ассортиментом
select 
s.id_contractor,
s.contractor_name,
r.id_store ,
s.store_name, 
r.nm,
sum (r.quantity) as quantity,
sum (r.sum_supplier) as sum_supplier,
sum (r.sum_sal) as sum_sal

from 
{{ ref('remains') }} as r,
{{ ref('store') }} as s 

where  r.id_store = s.id_store
and s.store_name like '%минасс%'
group by 
s.id_contractor,
s.contractor_name,
r.id_store ,
s.store_name, 
r.nm