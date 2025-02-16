--Generar el campo billing_account_id

select 
  calls_ivr_id, 
  array_agg(billing_account_id order by
            case when billing_account_id <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1 ) as billing_account_id,
from `keepcoding.ivr_detail`
group by calls_ivr_id;