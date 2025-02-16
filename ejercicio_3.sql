--Crear tavbla ivr_detail.

create table keepcoding.ivr_detail as
select 
    ca.ivr_id as calls_ivr_id,
    ca.phone_number as calls_phone_number,
    ca.ivr_result as calls_ivr_result,
    ca.vdn_label as calls_vdn_label,
    ca.start_date as calls_start_date,
    format_date('%Y%m%d', date(ca.start_date)) as calls_start_date_id,
    ca.end_date as calls_end_date,
    format_date('%Y%m%d', date(ca.end_date)) as calls_end_date_id,
    ca.total_duration as calls_total_duration,
    ca.customer_segment as calls_customer_segment,
    ca.ivr_language as calls_ivr_language,
    ca.steps_module as calls_steps_module,
    ca.module_aggregation as calls_module_aggregation,
    mo.module_sequece,
    mo.module_name,
    mo.module_duration,
    mo.module_result,
    st.step_sequence,
    st.step_name,
    st.step_result,
    st.step_description_error,
    st.document_type,
    st.document_identification,
    st.customer_phone,
    st.billing_account_id
from keepcoding.ivr_calls ca
left join keepcoding.ivr_modules mo
    on ca.ivr_id = mo.ivr_id
left join keepcoding.ivr_steps st
    on mo.ivr_id = st.ivr_id and mo.module_sequece = st.module_sequece;