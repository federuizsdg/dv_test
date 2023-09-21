{%- set hub_part_metadata -%}
source_models:
  - 'v_stg_orders'
  - 'v_stg_inventory'
src_pk: 'PART_PK'
src_nk:
  - 'PARTKEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_part_metadata = fromyaml(hub_part_metadata) -%}
{{ generate_hub(hub_part_metadata) }}