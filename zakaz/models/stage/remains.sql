{{
  config(
    materialized = 'table',
    as_columnstore = false
    )
}}

select 
STG_REMAINS.ID_STORE, 
NM,
--STG_REMAINS.QUANTITY_RES, 
--STG_REMAINS.QUANTITY_REM, 

QUANTITY = sum (CAST( STG_REMAINS.QUANTITY_REM as decimal)*STG_SCALING_RATIO.SCALING_K ) ,
SUM_SUPPLIER = sum (CAST( STG_REMAINS.QUANTITY_REM as decimal)* cast (STG_REMAINS.PRICE_SUP as decimal)  ),
SUM_SAL = sum (CAST( STG_REMAINS.QUANTITY_REM as decimal)* cast (STG_REMAINS.PRICE_SAL as decimal ) )
from STG_REMAINs
inner join STG_GOODS_NAMES on STG_GOODS_NAMES.ID_GOODS = STG_REMAINS.ID_GOODS
inner join STG_SCALING_RATIO on STG_REMAINS.ID_SCALING_RATIO = STG_SCALING_RATIO.ID_SCALING_RATIO
group by NM, STG_REMAINS.ID_STORE
