{%- set sat_inv_inventory_details_metadata -%}
source_models:
  - 'v_stg_inventory'
src_pk:
  - 'INVENTORY_PK'
src_hashdiff:
  - 'INVENTORY_HASHDIFF'
src_payload:
  - 'AVAILQTY'
  - 'SUPPLYCOST'
  - 'PART_SUPPLY_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set inv_inventory_details_metadata = fromyaml(sat_inv_inventory_details_metadata) -%}
{{ generate_satellite(inv_inventory_details_metadata) }}