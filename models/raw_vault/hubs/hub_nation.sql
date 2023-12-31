{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
    -- depends_on: {{ ref('v_stg_inventory') }}
{%- endif -%}
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
{{ generate_dependencies( hub_nation_metadata['source_models'] ) }}
{{ generate_hub(hub_nation_metadata) }}
