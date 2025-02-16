--Crear tabla ivr_summary

create table keepcoding.ivr_summary as
select 
    de.calls_ivr_id as ivr_id,  -- identificador de la llamada
    max(de.calls_phone_number) as phone_number,  -- número de la llamada
    max(de.calls_ivr_result) as ivr_result,  -- resultado de la llamada
    max(vdn.vdn_aggregation) as vdn_aggregation ,  -- agregación de vdn calculada anteriormente
    max(de.calls_start_date )as start_date,  -- fecha inicio de la llamada
    max(de.calls_end_date) as end_date,  -- fecha fin de la llamada
    max(de.calls_total_duration) as total_duration,  -- duración total de la llamada
    max(de.calls_customer_segment) as customer_segment,  -- segmento del cliente
    max(de.calls_ivr_language)as ivr_language,  -- idioma de la ivr
    max(de.calls_steps_module) as steps_module,  -- número de módulos
    max(de.calls_module_aggregation) as module_aggregation,  -- lista de módulos
    max(doc.document_type[offset(0)]) as document_type,  -- tipo de documento calculado
    max(doc.document_identification[offset(0)]) as document_identification,  -- identificación del documento calculado
    max(cust.customer_phone[offset(0)]) as customer_phone,  -- teléfono del cliente calculado
    max(bill.billing_account_id[offset(0)]) as billing_account_id,  -- billing account id calculado
    max(mas.masiva_lg) as masiva_lg,  -- flag de llamada masiva calculado
    max(info_phone.info_by_phone_lg) as info_by_phone_lg,  -- flag info_by_phone calculado
    max(info_dni.info_by_dni_lg) as info_by_dni_lg,  -- flag info_by_dni calculado
    max(repeated.repeated_phone_24h) as repeated_phone_24h,  -- flag llamada repetida en las últimas 24 horas
    max(repeated.cause_recall_phone_24h ) as cause_recall_phone_24h-- flag causa recall en las últimas 24 horas
from keepcoding.ivr_detail de
left join (
    select 
        calls_ivr_id,
        max(case 
            when calls_vdn_label like 'ATC%' then 'FRONT'
            when calls_vdn_label like 'TECH%' then 'TECH'
            when calls_vdn_label = 'ABSORPTION' then 'ABSORPTION'
            else 'RESTO'
        end) as vdn_aggregation
    from keepcoding.ivr_detail
    group by calls_ivr_id
) vdn on de.calls_ivr_id = vdn.calls_ivr_id  

left join (
    select 
        calls_ivr_id,
        array_agg(document_type order by 
            case when document_type <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1) as document_type,
        array_agg(document_identification order by 
            case when document_type <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1) as document_identification
    from keepcoding.ivr_detail
    group by calls_ivr_id
) doc on de.calls_ivr_id = doc.calls_ivr_id 

left join (
    select 
        calls_ivr_id,
        array_agg(customer_phone order by 
            case when customer_phone <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1) as customer_phone
    from keepcoding.ivr_detail
    group by calls_ivr_id
) cust on de.calls_ivr_id = cust.calls_ivr_id 

left join (
    select 
        calls_ivr_id,
        array_agg(billing_account_id order by 
            case when billing_account_id <> 'UNKNOWN' then 0 else 1 end,
            step_sequence desc limit 1) as billing_account_id
    from keepcoding.ivr_detail
    group by calls_ivr_id
) bill on de.calls_ivr_id = bill.calls_ivr_id  

left join (
    select 
        calls_ivr_id,
        max(case 
            when calls_module_aggregation like '%AVERIA_MASIVA%' then 1 
            else 0 
        end) as masiva_lg
    from keepcoding.ivr_detail
    group by calls_ivr_id
) mas on de.calls_ivr_id = mas.calls_ivr_id  
left join (
    select 
        calls_ivr_id,
        max(case 
            when step_name = 'CUSTOMERINFOBYPHONE.TX' and step_result = 'OK' then 1 
            else 0 
        end) as info_by_phone_lg
    from keepcoding.ivr_detail
    group by calls_ivr_id
) info_phone on de.calls_ivr_id = info_phone.calls_ivr_id 

left join (
    select 
        calls_ivr_id,
        max(case 
            when step_name = 'CUSTOMERINFOBYDNI.TX' and step_result = 'OK' then 1 
            else 0 
        end) as info_by_dni_lg
    from keepcoding.ivr_detail
    group by calls_ivr_id
) info_dni on de.calls_ivr_id = info_dni.calls_ivr_id  

left join (
    select 
        t1.calls_ivr_id,
        max(case 
            when t2.calls_start_date between t1.calls_start_date - interval 1 day and t1.calls_start_date then 1
            else 0
        end) as repeated_phone_24h,
        max(case 
            when t2.calls_start_date between t1.calls_end_date and t1.calls_end_date + interval 1 day then 1
            else 0
        end) as cause_recall_phone_24h
    from keepcoding.ivr_detail t1
    left join keepcoding.ivr_detail t2 
        on t1.calls_phone_number = t2.calls_phone_number 
        and t1.calls_ivr_id <> t2.calls_ivr_id
    group by t1.calls_ivr_id
) repeated on de.calls_ivr_id = repeated.calls_ivr_id
group by de.calls_ivr_id



