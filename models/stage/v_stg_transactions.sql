{%- if not execute -%}
    -- depends_on: {{ ref('raw_transactions') }}
{%- endif -%}
{%- set raw_transactions_metadata -%}
raw_table:
  - 'RAW_TRANSACTIONS'
derived_columns:
  RECORD_SOURCE: '*RAW_TRANSACTIONS'
  LOAD_DATE: DATEADD(DAY, 1, TRANSACTION_DATE)
  EFFECTIVE_FROM: 'TRANSACTION_DATE'
hashed_columns:
  TRANSACTION_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_ID'
      - 'TRANSACTION_NUMBER'
  CUSTOMER_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_ID'
  ORDER_PK:
    hashdiff: false
    columns:
      - 'ORDER_ID'
{%- endset -%}

{% set metadata_dict = fromyaml(raw_transactions_metadata) %}

{% set raw_table = metadata_dict['raw_table'][0] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

WITH staging AS (



WITH raw_columns AS (

  SELECT

    {{get_table_columns(raw_table)}}

  FROM {{ raw_table }}

),

{%- set from_last_cte %}
    {{get_table_columns(raw_table)}}
{%- endset %}

add_derived_columns AS(

    SELECT

    {{ from_last_cte }},
    {{ generate_derived_columns(derived_columns, True) }}

    FROM raw_columns
),

{%- set from_last_cte %}
    {{ get_table_columns(raw_table) }},
    {{ generate_derived_columns(derived_columns, False) }}
{%- endset %}

add_hashed_columns AS (
    SELECT

    {{ from_last_cte }},
    {{ generate_hashdiff_columns( hashed_columns ) }}

    FROM add_derived_columns
)

  SELECT * FROM add_hashed_columns

)

SELECT * FROM staging