{{
  config(
    materialized = 'table',
    as_columnstore = false
    )
}}
select 
stg_store.id_store,
stg_store.store_name,
stg_store.id_contractor,
stg_contractor.contractor_name
from stg_store, stg_contractor
where stg_store.id_contractor = stg_contractor.id_contractor
