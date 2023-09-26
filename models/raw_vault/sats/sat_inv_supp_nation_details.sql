{%- set sat_inv_supp_nation_metadata -%}
source_models:
  - 'v_stg_inventory'
src_pk:
  - 'SUPPLIER_PK'
src_hashdiff:
  - 'SUPPLIER_NATION_HASHDIFF'
src_payload:
  - 'SUPPLIER_NATION_NAME'
  - 'SUPPLIER_NATION_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set inv_supp_nation_metadata = fromyaml(sat_inv_supp_nation_metadata) -%}
{{ generate_dependencies( inv_supp_nation_metadata['source_models'] ) }}
{{ generate_satellite(inv_supp_nation_metadata) }}