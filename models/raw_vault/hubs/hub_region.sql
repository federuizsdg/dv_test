{%- set hub_region_metadata -%}
source_models:
  - 'v_stg_orders'
  - 'v_stg_inventory'
src_pk: 'REGION_PK'
src_nk:
  - 'REGIONKEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_region_metadata = fromyaml(hub_region_metadata) -%}
{{ generate_hub(hub_region_metadata) }}