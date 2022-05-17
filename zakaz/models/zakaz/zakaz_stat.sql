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
remains_days =(isnull (ra.quantity, 0)+isnull (otw.quantity,0))/saa.sum_quantity*30,  
sold_per_day = saa.sum_quantity/{{ var('analysis_days') }}, --- параметр из проекта
on_the_way = isnull (otw.quantity,0), 
saa.abc_group,
qtyabc.QTY_ABC_GROUP,
discountabc.DISCOUNT_ABC_GROUP,
marginabc.MARGIN_ABC_GROUP

from {{ ref('sales_abc_apteki') }} saa 
left outer join {{ ref('remains_apteka') }} ra on ra.id_contractor = saa.id_contractor and ra.nm = saa.nm
left outer join {{ ref('on_the_way') }} otw on otw.id_contractor = saa.id_contractor and otw.nm = saa.NM 
left outer join {{ ref('qty_abc_apteki')}} qtyabc on saa.id_contractor = qtyabc.id_contractor and saa.nm = qtyabc.nm
left outer join {{ ref('discount_abc_apteki')}} discountabc on discountabc.id_contractor = saa.id_contractor and discountabc.nm = saa.NM
left outer join {{ ref('margin_abc_apteki')}} marginabc on marginabc.id_contractor = saa.id_contractor and marginabc.nm = saa.NM