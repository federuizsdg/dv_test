{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
    -- depends_on: {{ ref('v_stg_inventory') }}
{%- endif -%}
{%- set hub_region_metadata -%}
source_models:
  - 'v_stg_orders'
  - 'v_stg_inventory'
src_pk: 'REGION_PK'
src_nk:
  - 'REGION_KEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_region_metadata = fromyaml(hub_region_metadata) -%}
{{ generate_dependencies( hub_region_metadata['source_models'] ) }}
{{ generate_hub(hub_region_metadata) }}