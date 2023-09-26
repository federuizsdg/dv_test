{%- if not execute -%}
    -- depends_on: {{ ref('raw_inventory') }}
{%- endif -%}
{%- set raw_inventory_metadata -%}
raw_table:
  - 'RAW_INVENTORY'
derived_columns:
  NATION_KEY: 'SUPPLIER_NATION_KEY'
  REGION_KEY: 'SUPPLIER_REGION_KEY'
  RECORD_SOURCE: '*TPCH-INVENTORY'
hashed_columns:
  SUPPLIER_PK:
    hashdiff: false
    columns:
      - 'SUPPLIERKEY'
  SUPPLIER_NATION_PK:
    hashdiff: false
    columns:
      - 'SUPPLIER_NATION_KEY'
  SUPPLIER_REGION_PK:
    hashdiff: false
    columns:
      - 'SUPPLIER_REGION_KEY'
  REGION_PK:
    hashdiff: false
    columns:
      - 'SUPPLIER_REGION_KEY'
  NATION_PK:
    hashdiff: false
    columns:
      - 'SUPPLIER_NATION_KEY'
  NATION_REGION_PK:
    hashdiff: false
    columns:
    - 'SUPPLIER_NATION_KEY'
    - 'SUPPLIER_REGION_KEY'
  LINK_SUPPLIER_NATION_PK:
    hashdiff: false
    columns:
    - 'SUPPLIERKEY'
    - 'SUPPLIER_NATION_KEY'
  PART_PK:
    hashdiff: false
    columns:
      - 'PARTKEY'
  INVENTORY_PK:
    hashdiff: false
    columns:
    - 'PARTKEY'
    - 'SUPPLIERKEY'
  SUPPLIER_HASHDIFF:
    hashdiff: true
    columns:
      - 'SUPPLIERKEY'
      - 'SUPPLIER_ACCTBAL'
      - 'SUPPLIER_ADDRESS'
      - 'SUPPLIER_PHONE'
      - 'SUPPLIER_COMMENT'
      - 'SUPPLIER_NAME'
  PART_HASHDIFF:
    hashdiff: true
    columns:
      - 'PARTKEY'
      - 'PART_BRAND'
      - 'PART_COMMENT'
      - 'PART_CONTAINER'
      - 'PART_MFGR'
      - 'PART_NAME'
      - 'PART_RETAILPRICE'
      - 'PART_SIZE'
      - 'PART_TYPE'
  SUPPLIER_REGION_HASHDIFF:
    hashdiff: true
    columns:
      - 'SUPPLIER_REGION_KEY'
      - 'SUPPLIER_REGION_COMMENT'
      - 'SUPPLIER_REGION_NAME'
  SUPPLIER_NATION_HASHDIFF:
    hashdiff: true
    columns:
      - 'SUPPLIER_NATION_KEY'
      - 'SUPPLIER_NATION_COMMENT'
      - 'SUPPLIER_NATION_NAME'
  INVENTORY_HASHDIFF:
    hashdiff: true
    columns:
      - 'PARTKEY'
      - 'SUPPLIERKEY'
      - 'AVAILQTY'
      - 'SUPPLYCOST'
      - 'PART_SUPPLY_COMMENT'
{%- endset -%}

{% set metadata_dict = fromyaml(raw_inventory_metadata) %}
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

SELECT *,
       TO_DATE('{{ var('load_date') }}') AS LOAD_DATE,
       TO_DATE('{{ var('load_date') }}') AS EFFECTIVE_FROM
FROM staging