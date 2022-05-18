{{
  config(
    materialized = 'table',
    as_columnstore = false,
    sort = ['contractor_name','SUM_SAL desc']
    )
}}


select a.id_contractor, a.contractor_name, a.NM, a.SUM_QUANTITY, a.SUM_DISCOUNT, a.SUM_SUPPLIER,a.SUM_SAL,
sum_goods_nakop = sum (sum_sal) over (partition by id_contractor, contractor_name order by sum_sal desc rows  unbounded preceding),
sm_percent = sum_sal/ sum (sum_sal) over (partition by id_contractor, contractor_name order by sum_sal desc rows between unbounded preceding and  unbounded following)*100 ,
sm_percent_nakop = (sum (sum_sal) over (partition by id_contractor, contractor_name order by sum_sal desc rows  unbounded preceding))/ sum (sum_sal) over (partition by id_contractor, contractor_name order by sum_sal desc rows between unbounded preceding and  unbounded following)*100, 
summa_apteka =  sum (sum_sal) over (partition by id_contractor, contractor_name order by sum_sal desc rows between unbounded preceding and  unbounded following),
case
    when {{smpnkl()}} >{{ABC_SETTINGS('ABC','A','MIN_ABC')}} and {{smpnkl()}} <={{ABC_SETTINGS('ABC','A','MAX_ABC')}} then 'A'
    when {{smpnkl()}} >{{ABC_SETTINGS('ABC','A1','MIN_ABC')}} and {{smpnkl()}} <={{ABC_SETTINGS('ABC','A1','MAX_ABC')}} then 'A1'
    when {{smpnkl()}} >{{ABC_SETTINGS('ABC','B','MIN_ABC')}} and {{smpnkl()}} <={{ABC_SETTINGS('ABC','B','MAX_ABC')}} then 'B'
    when {{smpnkl()}} >{{ABC_SETTINGS('ABC','C','MIN_ABC')}} and {{smpnkl()}} <={{ABC_SETTINGS('ABC', 'C','MAX_ABC')}} then 'C'
    when {{smpnkl()}} >{{ABC_SETTINGS('ABC','C1','MIN_ABC')}} then 'C1'
else 'UNDEFINED'
end as ABC_GROUP,
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
  
