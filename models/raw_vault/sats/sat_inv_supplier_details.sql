{%- set sat_inv_supplier_details_metadata -%}
source_models:
  - 'v_stg_inventory'
src_pk:
  - 'SUPPLIER_PK'
src_hashdiff:
  - 'SUPPLIER_HASHDIFF'
src_payload:
  - 'SUPPLIER_ADDRESS'
  - 'SUPPLIER_PHONE'
  - 'SUPPLIER_ACCTBAL'
  - 'SUPPLIER_NAME'
  - 'SUPPLIER_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set inv_supplier_details_metadata = fromyaml(sat_inv_supplier_details_metadata) -%}
{{ generate_dependencies( inv_supplier_details_metadata['source_models'] ) }}
{{ generate_satellite(inv_supplier_details_metadata) }}
