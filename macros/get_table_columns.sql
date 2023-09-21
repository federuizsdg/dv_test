{% macro get_table_columns(table_name) %}
    {%- set columns_query %}
    select COLUMN_NAME
    from information_schema.columns
    where table_name='{{ table_name }}'
    order by ORDINAL_POSITION;
    {% endset %}

    {%- set raw_inventory_columns = run_query(columns_query) -%}
    {%- if execute -%}
    {%- set raw_inventory_columns_data = raw_inventory_columns.columns -%}
    {%- for column_data in raw_inventory_columns -%}
    {{ column_data[0] }}
    {%- if not loop.last -%},
    {% endif -%}
    {% endfor -%}
    {% endif -%}

{%- endmacro %}

