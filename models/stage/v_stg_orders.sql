{%- set raw_orders_metadata -%}
raw_table: 'RAW_ORDERS'
derived_columns:
  CUSTOMER_KEY: 'CUSTOMERKEY'
  NATION_KEY: 'CUSTOMER_NATION_KEY'
  REGION_KEY: 'CUSTOMER_REGION_KEY'
  RECORD_SOURCE: '*TPCH-ORDERS'
  EFFECTIVE_FROM: 'ORDERDATE'
hashed_columns:
  CUSTOMER_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_KEY'
  LINK_CUSTOMER_NATION_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_KEY'
      - 'CUSTOMER_NATION_KEY'
  CUSTOMER_NATION_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_NATION_KEY'
  CUSTOMER_REGION_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_REGION_KEY'
  NATION_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_NATION_KEY'
  REGION_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_REGION_KEY'
  NATION_REGION_PK:
    hashdiff: false
    columns:
    - 'CUSTOMER_NATION_KEY'
    - 'CUSTOMER_REGION_KEY'
  ORDER_PK:
    hashdiff: false
    columns:
      - 'ORDERKEY'
  ORDER_CUSTOMER_PK:
    hashdiff: false
    columns:
      - 'CUSTOMER_KEY'
      - 'ORDERKEY'
  LINEITEM_PK:
    hashdiff: false
    columns:
      - 'ORDERKEY'
      - 'LINENUMBER'
  LINK_LINEITEM_ORDER_PK:
    hashdiff: false
    columns:
      - 'ORDERKEY'
      - 'ORDERKEY'
      - 'LINENUMBER'
  PART_PK:
    hashdiff: false
    columns:
      - 'PARTKEY'
  SUPPLIER_PK:
    hashdiff: false
    columns:
      - 'SUPPLIERKEY'
  INVENTORY_PK:
    hashdiff: false
    columns:
      - 'PARTKEY'
      - 'SUPPLIERKEY'
  INVENTORY_ALLOCATION_PK:
    hashdiff: false
    columns:
      - 'LINENUMBER'
      - 'PARTKEY'
      - 'SUPPLIERKEY'
  CUSTOMER_HASHDIFF:
    hashdiff: true
    columns:
      - 'CUSTOMER_KEY'
      - 'CUSTOMER_NAME'
      - 'CUSTOMER_ADDRESS'
      - 'CUSTOMER_PHONE'
      - 'CUSTOMER_ACCBAL'
      - 'CUSTOMER_MKTSEGMENT'
      - 'CUSTOMER_COMMENT'
  CUSTOMER_NATION_HASHDIFF:
    hashdiff: true
    columns:
      - 'CUSTOMER_NATION_NAME'
      - 'CUSTOMER_NATION_COMMENT'
      - 'CUSTOMER_NATION_KEY'
  CUSTOMER_REGION_HASHDIFF:
    hashdiff: true
    columns:
      - 'CUSTOMER_REGION_NAME'
      - 'CUSTOMER_REGION_COMMENT'
      - 'CUSTOMER_REGION_KEY'
  LINEITEM_HASHDIFF:
    hashdiff: true
    columns:
      - 'ORDERKEY'
      - 'LINENUMBER'
      - 'COMMITDATE'
      - 'DISCOUNT'
      - 'EXTENDEDPRICE'
      - 'LINESTATUS'
      - 'LINE_COMMENT'
      - 'QUANTITY'
      - 'RECEIPTDATE'
      - 'RETURNFLAG'
      - 'SHIPDATE'
      - 'SHIPINSTRUCT'
      - 'SHIPMODE'
      - 'TAX'
  ORDER_HASHDIFF:
    hashdiff: true
    columns:
      - 'ORDERKEY'
      - 'CLERK'
      - 'ORDERDATE'
      - 'ORDERPRIORITY'
      - 'ORDERSTATUS'
      - 'ORDER_COMMENT'
      - 'SHIPPRIORITY'
      - 'TOTALPRICE'
{%- endset -%}

{% set orders_dict = fromyaml(raw_orders_metadata) %}
{% set raw_table = orders_dict['raw_table'] %}
{% set derived_columns = orders_dict['derived_columns'] %}
{% set hashed_columns = orders_dict['hashed_columns'] %}

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

SELECT *,
       TO_DATE('{{ var('load_date') }}') AS LOAD_DATE
FROM staging
