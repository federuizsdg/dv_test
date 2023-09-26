{%- set link_nation_region_metadata -%}
source_models:
  - 'v_stg_orders'
  - 'v_stg_inventory'
src_pk:
  - 'NATION_REGION_PK'
src_fk:
  - 'NATION_PK'
  - 'REGION_PK'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set nation_region_metadata = fromyaml(link_nation_region_metadata) -%}
{{ generate_dependencies( nation_region_metadata['source_models'] ) }}
{{ generate_link(nation_region_metadata) }}