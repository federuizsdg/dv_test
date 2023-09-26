{%- set hub_customer_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk: 'CUSTOMER_PK'
src_nk:
  - 'CUSTOMERKEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_customer_metadata = fromyaml(hub_customer_metadata) -%}
{{ generate_dependencies( hub_customer_metadata['source_models'] ) }}
{{ generate_hub(hub_customer_metadata) }}