--Generar el campo info_by_phone_lg

select 
	calls_ivr_id,
	max(case 
  		when step_name = 'CUSTOMERINFOBYPHONE.TX' and  step_result = 'OK' then 1 else 0
	end) as info_by_phone_lg
from keepcoding.ivr_detail
group by calls_ivr_id