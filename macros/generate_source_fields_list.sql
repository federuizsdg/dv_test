{%- macro generate_source_fields_list(param_fields_list, param_alias) -%}
    {%- set fields_list = param_fields_list -%}
    {%- set source_alias = param_alias -%}
    {%- set field_template = namespace(value='') -%}
    {%- set field_template.value = '<ALIAS>.<FIELD>' -%}
    {%- set list_result = namespace(value='') -%}
    {%- set temp_field = namespace(value='') -%}
    {%- for field in fields_list -%}
        {%- set temp_field.value = field_template.value -%}
        {%- set temp_field.value = temp_field.value.replace('<ALIAS>', source_alias) -%}
        {%- set temp_field.value = temp_field.value.replace('<FIELD>', field) -%}
        {%- set list_result.value = list_result.value ~ temp_field.value  -%}
        {%- if not loop.last -%}
            {%- set list_result.value = list_result.value ~ ', ' -%}
        {%- endif -%}
    {%- endfor -%}
    {{ list_result['value'] }}
{%- endmacro %}