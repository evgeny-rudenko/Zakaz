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
    when {{smpnkl()}} >0 and {{smpnkl()}} <=40 then 'A'
    when {{smpnkl()}} >40 and {{smpnkl()}} <=60 then 'A1'
    when {{smpnkl()}} >60 and {{smpnkl()}} <=75 then 'B'
    when {{smpnkl()}} >75 and {{smpnkl()}} <=94 then 'C'
    when {{smpnkl()}} >94 then 'C1'
else 'UNDEFINED'
end as MARGIN_ABC_GROUP,
max_date_cheque

from (
  select id_contractor, contractor_name, NM , 
sum (QUANTITY) as SUM_QUANTITY, 
sum(SUMM_DISCOUNT) as SUM_DISCOUNT,
sum (SUM_SUPPLIER) as SUM_SUPPLIER,
sum (SUM_SAL)-sum(SUMM_DISCOUNT)-sum(SUM_SUPPLIER) as SUM_SAL ,
max (date_cheque) as max_date_cheque
 from {{ ref('sales') }}
 where DATE_CHEQUE > GETDATE() - {{ var('analysis_days') }}
 group by id_contractor, contractor_name, NM
 ) as a
  
