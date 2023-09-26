{%- set t_link_transactions_metadata -%}
source_models:
  - 'v_stg_transactions'
src_pk:
  - 'TRANSACTION_PK'
src_fk:
  - 'CUSTOMER_PK'
  - 'ORDER_PK'
src_payload:
  - 'TRANSACTION_NUMBER'
  - 'TRANSACTION_DATE'
  - 'TYPE'
  - 'AMOUNT'
src_eff:
  - 'EFFECTIVE_FROM'
src_ldts:
  - 'LOAD_DATE'
src_source:
  - 'RECORD_SOURCE'
{%- endset -%}
    
{%- set transactions_metadata = fromyaml(t_link_transactions_metadata) -%}
{{ generate_dependencies( transactions_metadata['source_models'] ) }}
{{ generate_t_link(transactions_metadata) }}
