--Generar los campos document_type y document_identification

select 
  calls_ivr_id, 
  array_agg(document_type order by
            case when document_type <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1 ) as document_type,
  array_agg(document_identification order by 
            case when document_type <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1 ) as document_identification,
from `keepcoding.ivr_detail`
group by calls_ivr_id;
