{{
  config(
    materialized = 'table',
    as_columnstore = false , 
    sort = ['contractor_name', 'nm']
    
    )
}}

select {{dbt_utils.star( ref('zakaz_stat') )}},
overstock_qty = FLOOR( sold_per_day * (remains_days -{{ var('analysis_days') }})),
overstock_qty_apteki = SUM(FLOOR( sold_per_day * (remains_days -{{ var('analysis_days') }})))  over (partition by nm ORDER by nm )
from {{ ref('zakaz_stat') }} 
where remains_days > {{ var('analysis_days') }}
and remains_qty >10 --- не выбирать товар с маленьким количеством. Это сократит количество строк
and FLOOR( sold_per_day * (remains_days -{{ var('analysis_days') }}))>0 
