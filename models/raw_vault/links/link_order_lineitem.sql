{%- set link_order_lineitem_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'LINK_LINEITEM_ORDER_PK'
src_fk:
  - 'ORDER_PK'
  - 'LINEITEM_PK'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set order_lineitem_metadata = fromyaml(link_order_lineitem_metadata) -%}
{{ generate_link(order_lineitem_metadata) }}