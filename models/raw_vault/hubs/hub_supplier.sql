{%- if not execute -%}
    -- depends_on: {{ ref('v_stg_orders') }}
    -- depends_on: {{ ref('v_stg_inventory') }}
{%- endif -%}
{%- set hub_supplier_metadata -%}
source_models:
  - 'v_stg_orders'
  - 'v_stg_inventory'
src_pk: 'SUPPLIER_PK'
src_nk:
  - 'SUPPLIERKEY'
src_ldts: 'LOAD_DATE'
src_source: 'RECORD_SOURCE'
{%- endset -%}

{%- set hub_supplier_metadata = fromyaml(hub_supplier_metadata) -%}
{{ generate_dependencies( hub_supplier_metadata['source_models'] ) }}
{{ generate_hub(hub_supplier_metadata) }}