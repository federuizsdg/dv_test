{%- set link_inventory_allocation_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'INVENTORY_ALLOCATION_PK'
src_fk:
  - 'PART_PK'
  - 'SUPPLIER_PK'
  - 'LINEITEM_PK'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set inventory_allocation_metadata = fromyaml(link_inventory_allocation_metadata) -%}
{{ generate_dependencies( inventory_allocation_metadata['source_models'] ) }}
{{ generate_link(inventory_allocation_metadata) }}
