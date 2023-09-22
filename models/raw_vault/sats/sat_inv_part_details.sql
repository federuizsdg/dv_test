{%- set sat_inv_part_details_metadata -%}
source_models:
  - 'v_stg_inventory'
src_pk:
  - 'PART_PK'
src_hashdiff:
  - 'PART_HASHDIFF'
src_payload:
  - 'PART_NAME'
  - 'PART_MFGR'
  - 'PART_BRAND'
  - 'PART_TYPE'
  - 'PART_SIZE'
  - 'PART_CONTAINER'
  - 'PART_RETAILPRICE'
  - 'PART_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set inv_part_details_metadata = fromyaml(sat_inv_part_details_metadata) -%}
{{ generate_satellite(inv_part_details_metadata) }}
