{{
  config(
    materialized = 'table',
    as_columnstore = false,
    sort = ['contractor_name', 'abc_group']
    )
}}
select  {{ dbt_utils.star(from=ref('zakaz_stat')) }} ,
ORDER_QTY = 
case 
when (ABC_GROUP = 'A' 	and remains_days <= {{ var('A_days_remains') }}) 	then ROUND( sold_per_day * ({{ var('A_days') }}+{{ var('delivery_days') }}-remains_days),0)
when (ABC_GROUP = 'A1' 	and remains_days <= {{ var('A1_days_remains')}}) 	then ROUND( sold_per_day * ({{ var('A1_days') }}+{{ var('delivery_days') }}-remains_days),0)
when (ABC_GROUP = 'B' 	and remains_days <= {{ var('B_days_remains') }}) 	then ROUND( sold_per_day * ({{ var('B_days') }}+{{ var('delivery_days') }}-remains_days),0)
when (abc_group = 'C' 	and remains_days <= {{ var('C_days_remains') }}) 	then ROUND( sold_per_day * ({{ var('C_days') }}+{{ var('delivery_days') }}-remains_days),0)
-- Последнюю группу заказываем только когда товар полностью закончился 
when (abc_group = 'C1' 	and remains_qty=0) 	then ROUND( sold_per_day * ({{ var('C1_days') }}+{{ var('delivery_days') }}),0)
else 0
end,
overstock = isnull ( (select top 1 o.overstock_qty_apteki from {{ ref('overstock') }} o where o.nm = zakaz_stat.NM),0),
sklad_qty = isnull ( (select top 1 sklad.sklad_qty from {{ ref('remains_sklad')}} sklad where sklad.nm = zakaz_stat.nm ),0)
from {{ ref('zakaz_stat') }} as zakaz_stat
--WHERE remains_days <{{ var('remains_days') }} 
