--Generar el campo vdn_aggregation

select 
  calls_ivr_id,
  max(case 
        when calls_vdn_label like 'ATC%' then 'FRONT'
        when calls_vdn_label like 'TECH%' then 'TECH'
        when calls_vdn_label = 'ABSORPTION' then 'ABSORPTION'
        else 'RESTO'
      end
  )
      as vdn_aggregation
from keepcoding.ivr_detail
group by  calls_ivr_id;