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
{{ generate_link(inventory_metadata) }}
