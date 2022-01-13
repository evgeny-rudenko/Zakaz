{% macro smpnkl() %}
    (sum (sum_sal) over (partition by id_contractor, contractor_name order by sum_sal desc rows  unbounded preceding))/ sum (sum_sal) over (partition by id_contractor, contractor_name order by sum_sal desc rows between unbounded preceding and  unbounded following)*100
{% endmacro %}

