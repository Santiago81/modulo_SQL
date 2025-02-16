--Generar el campo customer_phone

select 
  calls_ivr_id, 
  array_agg(customer_phone order by
            case when customer_phone <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1 ) as customer_phone,
from `keepcoding.ivr_detail`
group by calls_ivr_id;