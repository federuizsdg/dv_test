{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_inventory') }}
{%- endif -%}
{%- set link_inventory_metadata -%}
source_models:
  - 'v_stg_inventory'
src_pk:
  - 'INVENTORY_PK'
src_fk:
  - 'SUPPLIER_PK'
  - 'PART_PK'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}


{%- set inventory_metadata = fromyaml(link_inventory_metadata) -%}
{{ generate_dependencies( inventory_metadata['source_models'] ) }}
{{ generate_link(inventory_metadata) }}
