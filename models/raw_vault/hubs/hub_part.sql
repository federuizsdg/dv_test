{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
    -- depends_on: {{ ref('v_stg_inventory') }}
{%- endif -%}
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
{{ generate_dependencies( hub_part_metadata['source_models'] ) }}
{{ generate_hub(hub_part_metadata) }}