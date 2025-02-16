--Generar los campos repeated_phone_24H, cause_recall_phone_24H

select 
  t1.calls_ivr_id,

  case 
    when max(case
              when t2.calls_start_date between t1.calls_start_date - interval 1 day and t1.calls_start_date then 1
              else 0
              end) = 1 then 1
            else 0
    end as repeated_phone_24H,

  case 
    when max(case
              when t2.calls_start_date between t1.calls_end_date and t1.calls_end_date + interval 1 day then 1
              else 0
              end) = 1 then 1
            else 0
    end as cause_recall_phone_24H

from keepcoding.ivr_detail t1
left join keepcoding.ivr_detail t2 
on t1.calls_phone_number = t2.calls_phone_number and t1.calls_ivr_id <> t2.calls_ivr_id 
group by t1.calls_ivr_id;
