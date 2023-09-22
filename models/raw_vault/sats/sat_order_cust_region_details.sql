{%- set sat_order_cust_region_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'CUSTOMER_PK'
src_hashdiff:
  - 'CUSTOMER_REGION_HASHDIFF'
src_payload:
  - 'CUSTOMER_REGION_NAME'
  - 'CUSTOMER_REGION_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set order_cust_region_metadata = fromyaml(sat_order_cust_region_metadata) -%}
{{ generate_satellite(order_cust_region_metadata) }}
