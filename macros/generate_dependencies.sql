{%- macro generate_dependencies(list_of_sources) -%}
    {%- set customStringTemplate = namespace(value='') -%}
    {%- set customStringTemplate.value = '-- depends_on: {{ ref(' ~ "'" ~ '<SOURCE>' ~ "'" ~ ') }}' ~ '\n'-%}
    {%- for source_name in list_of_sources -%}
        {%- set customString = namespace(value='') -%}
        {%- set customString.value = customStringTemplate.value -%}
        {%- set customString.value = customString.value.replace('<SOURCE>', source_name) -%}
        {{customString['value']}}
    {%- endfor -%}
{%- endmacro -%}