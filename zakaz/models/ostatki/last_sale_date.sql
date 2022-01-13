{{
  config(
    materialized = 'table',
    as_columnstore = false
    
    )
}}

--- дата последней продажи
SELECT id_contractor, contractor_name, nm , 
max (date_cheque) as last_sale_date 
from {{ ref('sales') }} s
group by id_contractor, contractor_name , nm