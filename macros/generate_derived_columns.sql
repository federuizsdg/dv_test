{% macro generate_derived_columns(dict_to_extract, with_as) %}
  {%- set list_to_print = [] -%}
  {%- set list_values = [] -%}
  {%- for key, value in dict_to_extract.items() -%}
    {{- list_to_print.append(key) or "" -}}
  {%- endfor -%}
  {% for col_name in list_to_print %}
    {%- if with_as -%}
      {%- set adhoc_col_name = dict_to_extract[col_name] -%}
      {%- if adhoc_col_name.startswith('*') -%}
        {{ "    " if not loop.first}}{{- "'" ~ adhoc_col_name.replace('*','') ~ "'" ~ ' AS ' ~ col_name -}}{{ ",\n" if not loop.last }}
      {%- else -%}
        {{ "    " if not loop.first}}{{- adhoc_col_name ~ ' AS ' ~ col_name -}}{{ ",\n" if not loop.last }}
      {%- endif -%}
    {%- else -%}
      {{ "    " if not loop.first}}{{- col_name -}}{{ ",\n" if not loop.last }}
    {%- endif -%}
  {%- endfor -%}
{%- endmacro %}