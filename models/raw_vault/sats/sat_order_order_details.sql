{%- set sat_order_order_details_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'ORDER_PK'
src_hashdiff:
  - 'ORDER_HASHDIFF'
src_payload:
  - 'ORDERSTATUS'
  - 'TOTALPRICE'
  - 'ORDERDATE'
  - 'ORDERPRIORITY'
  - 'CLERK'
  - 'SHIPPRIORITY'
  - 'ORDER_COMMENT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set order_order_details_metadata = fromyaml(sat_order_order_details_metadata) -%}
{{ generate_dependencies( order_order_details_metadata['source_models'] ) }}
{{ generate_satellite(order_order_details_metadata) }}