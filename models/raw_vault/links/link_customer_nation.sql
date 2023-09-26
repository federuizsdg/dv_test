{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
{%- endif -%}
{%- set link_customer_nation_metadata -%}
source_models:
  - 'v_stg_orders'
src_pk:
  - 'LINK_CUSTOMER_NATION_PK'
src_fk:
  - 'CUSTOMER_PK'
  - 'NATION_PK'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set customer_nation_metadata = fromyaml(link_customer_nation_metadata) -%}
{{ generate_dependencies( customer_nation_metadata['source_models'] ) }}
{{ generate_link(customer_nation_metadata) }}
