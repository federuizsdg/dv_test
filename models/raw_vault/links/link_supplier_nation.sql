{%- set link_supplier_nation_metadata -%}
source_models:
  - 'v_stg_inventory'
src_pk:
  - 'LINK_SUPPLIER_NATION_PK'
src_fk:
  - 'SUPPLIER_PK'
  - 'NATION_PK'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set supplier_nation_metadata = fromyaml(link_supplier_nation_metadata) -%}
{{ generate_dependencies( supplier_nation_metadata['source_models'] ) }}
{{ generate_link(supplier_nation_metadata) }}