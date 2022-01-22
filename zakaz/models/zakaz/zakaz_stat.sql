{{
  config(
    materialized = 'table',
    as_columnstore = false,
    sort = ['contractor_name', 'abc_group']
    )
}}
select 
saa.id_contractor,
saa.contractor_name,
saa.nm,
saa.sum_quantity as prodano,
remains_qty = isnull (ra.quantity, 0) ,
remains_days =round( (isnull (ra.quantity, 0)+isnull (otw.quantity,0))/saa.sum_quantity*30,2),  
sold_per_day = ROUND( saa.sum_quantity/{{ var('analysis_days') }},2), --- параметр из проекта
on_the_way = isnull (otw.quantity,0), 
saa.abc_group
from {{ ref('sales_abc_apteki') }} saa 
left outer join {{ ref('remains_apteka') }} ra on ra.id_contractor = saa.id_contractor and ra.nm = saa.nm
left outer join {{ ref('on_the_way') }} otw on otw.id_contractor = saa.id_contractor and otw.nm = saa.NM 
