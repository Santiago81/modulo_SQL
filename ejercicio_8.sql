--Generar el campo masiva_lg

select 
  calls_ivr_id,
  max(case 
    	when calls_module_aggregation like '%AVERIA_MASIVA%' then 1 else 0
	  end) as masiva_lg
from keepcoding.ivr_detail
group by calls_ivr_id
