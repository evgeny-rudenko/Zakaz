{{
  config(
    materialized = 'table',
    as_columnstore = false
    
    )
}}
-- Товары в пути до аптеки или склада
select 
id_contractor,
contractor_name,
nm,
quantity,
sum_supplier,
sum_sal
from {{ ref('invoice') }}
where DOCUMENT_STATE !='PROC'
