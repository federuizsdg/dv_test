{%- set hub_lineitem_metadata -%}
source_models:
  - 'v_stg_orders'
source_models_alias: 'rr'
src_pk: 'LINEITEM_PK'
src_nk:
  - 'LINENUMBER'
  - 'ORDERKEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_lineitem_metadata = fromyaml(hub_lineitem_metadata) -%}
{{ generate_hub(hub_lineitem_metadata) }}