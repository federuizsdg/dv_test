{%- macro generate_hashdiff_columns(parent_dict) -%}
  {%- for key, column_subdict in parent_dict.items() -%}
    {%- set COLUMN_KEY = key -%}
    {%- set hashdiff_check = column_subdict['hashdiff'] -%}
    {%- set list_columns_hashdiff = column_subdict['columns'] -%}
    {%- set customString = namespace(value='') -%}
    {%- for col_name in list_columns_hashdiff -%}
      {%- set columns_hash_list = value -%}
      {%- if list_columns_hashdiff|length == 1 -%}
          {%- set COLUMN_LIST_ELEM = list_columns_hashdiff[0] -%}
          {%- set COLUMN_CONTENT = 'UPPER(TRIM(CAST(' ~ COLUMN_LIST_ELEM ~ ' AS VARCHAR)))'-%}
          {%- set customString.value = customString.value ~ COLUMN_CONTENT -%}
      {%- elif list_columns_hashdiff|length > 1 -%}
          {%- set COLUMN_LIST_ELEM = col_name -%}
          {%- set COLUMN_ELEM_CONTENT = '  ' ~ '  IFNULL(NULLIF(UPPER(TRIM(CAST(' ~ COLUMN_LIST_ELEM ~ ' AS VARCHAR)))' ~ ', ' ~ "'" ~ "'" ~ ')' ~ ',' ~ "'" ~ '^' ~ '^' ~ "'"  ~ ')'  -%}
          {%- set customString.value = customString.value ~ COLUMN_ELEM_CONTENT -%}
          {%- if not loop.last -%}
              {%- set customString.value = customString.value ~ ',' ~ "'" ~ '|' ~ '|' ~ "'" ~ ',' ~ '\n' -%}
          {%- endif -%}
      {%- endif -%}
    {%- endfor -%}
    {%- if list_columns_hashdiff|length > 1 -%}
      {%- set customString.value = 'CONCAT(' ~ '\n' ~ customString.value ~ '\n    )' -%}
    {%- endif -%}

    {%- if hashdiff_check -%}
      {%- set customString.value = 'CAST(MD5_BINARY(' ~ customString.value ~ ') AS BINARY(16)) AS ' ~ COLUMN_KEY -%}
    {%- else -%}
      {%- if list_columns_hashdiff|length == 1 -%}
        {%- set customString.value = 'CAST(MD5_BINARY(NULLIF(' ~ customString.value ~ ',' ~ "'" ~ "'" ~ ')) AS BINARY(16)) AS ' ~ COLUMN_KEY -%}
      {%- else -%}
        {%- set customString.value = 'CAST(MD5_BINARY(NULLIF(' ~ customString.value ~ ',' ~ "'" ~ '^' ~ '^' ~ '|' ~ '|' ~ '^' ~ '^' ~ "'" ~ ')) AS BINARY(16)) AS ' ~ COLUMN_KEY -%}
      {%- endif -%}
    {%- endif -%}

    {{ "    " if not loop.first}}{{ customString['value'] }}{{ ",\n\n" if not loop.last else "\n\n"}}
  {%- endfor -%}
{%- endmacro -%}