{{
  config(
    materialized = 'table',
    as_columnstore = false,
    sort = ['contractor_name','SUM_SAL desc']
    )
}}

select a.id_contractor, a.contractor_name, a.NM, a.SUM_QUANTITY, a.SUM_DISCOUNT, a.SUM_SUPPLIER,a.SUM_SAL,
sum_goods_nakop = sum (SUM_QUANTITY) over (partition by id_contractor, contractor_name order by SUM_QUANTITY desc rows  unbounded preceding),
sm_percent = SUM_QUANTITY/ sum (SUM_QUANTITY) over (partition by id_contractor, contractor_name order by SUM_QUANTITY desc rows between unbounded preceding and  unbounded following)*100 ,
sm_percent_nakop = (sum (SUM_QUANTITY) over (partition by id_contractor, contractor_name order by SUM_QUANTITY desc rows  unbounded preceding))/ sum (SUM_QUANTITY) over (partition by id_contractor, contractor_name order by SUM_QUANTITY desc rows between unbounded preceding and  unbounded following)*100, 
summa_apteka =  sum (SUM_QUANTITY) over (partition by id_contractor, contractor_name order by SUM_QUANTITY desc rows between unbounded preceding and  unbounded following),
case
    when {{qty_smpnkl()}} >{{ABC_SETTINGS('ABC_QTY','A','MIN_ABC')}} and {{qty_smpnkl()}} <={{ABC_SETTINGS('ABC_QTY','A','MAX_ABC')}}  then 'A'
    when {{qty_smpnkl()}} >{{ABC_SETTINGS('ABC_QTY','A1','MIN_ABC')}} and {{qty_smpnkl()}} <={{ABC_SETTINGS('ABC_QTY','A1','MAX_ABC')}} then 'A1'
    when {{qty_smpnkl()}} >{{ABC_SETTINGS('ABC_QTY','B','MIN_ABC')}} and {{qty_smpnkl()}} <={{ABC_SETTINGS('ABC_QTY','B','MAX_ABC')}} then 'B'
    when {{qty_smpnkl()}} >{{ABC_SETTINGS('ABC_QTY','C','MIN_ABC')}} and {{qty_smpnkl()}} <={{ABC_SETTINGS('ABC_QTY','C','MAX_ABC')}} then 'C'
    when {{qty_smpnkl()}} >{{ABC_SETTINGS('ABC_QTY','C1','MIN_ABC')}} then 'C1'
else 'UNDEFINED'
end as QTY_ABC_GROUP,
max_date_cheque

from (
  select id_contractor, contractor_name, NM , 
sum (QUANTITY) as SUM_QUANTITY, 
sum(SUMM_DISCOUNT) as SUM_DISCOUNT,
sum (SUM_SUPPLIER) as SUM_SUPPLIER,
sum (SUM_SAL) as SUM_SAL ,
max (date_cheque) as max_date_cheque
 from {{ ref('sales') }}
 where DATE_CHEQUE > GETDATE() - {{ var('analysis_days') }}
 group by id_contractor, contractor_name, NM
 ) as a
  
