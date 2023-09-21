{%- set hub_nation_metadata -%}
source_models:
  - 'v_stg_orders'
  - 'v_stg_inventory'
src_pk: 'NATION_PK'
src_nk:
  - 'NATION_KEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_nation_metadata = fromyaml(hub_nation_metadata) -%}
{{ generate_hub(hub_nation_metadata) }}
