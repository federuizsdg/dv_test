{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
{%- endif -%}
{%- set sat_order_customer_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'CUSTOMER_PK'
src_hashdiff:
  - 'CUSTOMER_HASHDIFF'
src_payload:
  - 'CUSTOMER_NAME'
  - 'CUSTOMER_ADDRESS'
  - 'CUSTOMER_PHONE'
  - 'CUSTOMER_ACCBAL'
  - 'CUSTOMER_MKTSEGMENT'
  - 'CUSTOMER_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set order_customer_metadata = fromyaml(sat_order_customer_metadata) -%}
{{ generate_dependencies( order_customer_metadata['source_models'] ) }}
{{ generate_satellite(order_customer_metadata) }}