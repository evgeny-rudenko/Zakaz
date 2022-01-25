{{
  config(
    materialized = 'table',
    as_columnstore = false
    )
}}

-- Остатки по центральному складу
select 
s.id_contractor,
s.contractor_name,
r.nm,
sum (r.quantity) as sklad_qty,
sum (r.sum_supplier) as sum_supplier_sklad,
sum (r.sum_sal) as sum_sal_sklad

from 
{{ ref('remains') }} as r,
{{ ref('store') }} as s 

where r.id_store = s.id_store
and s.id_store in (1,7) -- склады основной и маркировка офиса

group by
s.id_contractor,
s.contractor_name,
r.nm 