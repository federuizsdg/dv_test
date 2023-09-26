{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
{%- endif -%}
{%- set sat_order_cust_nation_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'CUSTOMER_PK'
src_hashdiff:
  - 'CUSTOMER_NATION_HASHDIFF'
src_payload:
  - 'CUSTOMER_NATION_NAME'
  - 'CUSTOMER_NATION_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set order_cust_nation_metadata = fromyaml(sat_order_cust_nation_metadata) -%}
{{ generate_dependencies( order_cust_nation_metadata['source_models'] ) }}
{{ generate_satellite(order_cust_nation_metadata) }}