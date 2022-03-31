{% macro qty_smpnkl() %}
    (sum (SUM_QUANTITY) over (partition by id_contractor, contractor_name order by SUM_QUANTITY desc rows  unbounded preceding))/ sum (SUM_QUANTITY) over (partition by id_contractor, contractor_name order by SUM_QUANTITY desc rows between unbounded preceding and  unbounded following)*100
{% endmacro %}