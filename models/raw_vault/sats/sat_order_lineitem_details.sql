{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
{%- endif -%}
{%- set sat_order_lineitem_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'LINEITEM_PK'
src_hashdiff:
  - 'LINEITEM_HASHDIFF'
src_payload:
  - 'COMMITDATE'
  - 'DISCOUNT'
  - 'EXTENDEDPRICE'
  - 'LINE_COMMENT'
  - 'QUANTITY'
  - 'RECEIPTDATE'
  - 'RETURNFLAG'
  - 'SHIPDATE'
  - 'SHIPINSTRUCT'
  - 'SHIPMODE'
  - 'TAX'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}

{%- set order_lineitem_metadata = fromyaml(sat_order_lineitem_metadata) -%}
{{ generate_dependencies( order_lineitem_metadata['source_models'] ) }}
{{ generate_satellite(order_lineitem_metadata) }}