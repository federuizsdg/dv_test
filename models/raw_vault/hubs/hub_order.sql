{%- set hub_order_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk: 'ORDER_PK'
src_nk:
  - 'ORDERKEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_order_metadata = fromyaml(hub_order_metadata) -%}
{{ generate_dependencies( hub_order_metadata['source_models'] ) }}
{{ generate_hub(hub_order_metadata) }}