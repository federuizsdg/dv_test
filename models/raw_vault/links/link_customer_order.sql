{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
{%- endif -%}
{%- set link_customer_order_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'ORDER_CUSTOMER_PK'
src_fk:
  - 'CUSTOMER_PK'
  - 'ORDER_PK'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set customer_order_metadata = fromyaml(link_customer_order_metadata) -%}
{{ generate_dependencies( customer_order_metadata['source_models'] ) }}
{{ generate_link(customer_order_metadata) }}