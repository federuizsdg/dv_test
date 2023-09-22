{%- macro generate_where_from_list(param_fields_list, param_alias) -%}
    {%- set fields_list = param_fields_list -%}
    {%- set source_alias = param_alias -%}
    {%- set field_template = namespace(value='') -%}
    {%- set list_result = namespace(value='') -%}
    {%- set temp_field = namespace(value='') -%}
    {%- set field_template.value = '<WOA> <ALIAS>.<FIELD> IS NOT NULL' -%}
    {%- for field in fields_list -%}
        {%- set temp_field.value = field_template.value -%}
        {%- if loop.first -%}
            {%- set temp_field.value = temp_field.value.replace('<WOA>', 'WHERE') -%}
        {%- else -%}
            {%- set temp_field.value = temp_field.value.replace('<WOA>', '  AND') -%}
        {%- endif -%}
        {%- set temp_field.value = temp_field.value.replace('<ALIAS>', source_alias) -%}
        {%- set temp_field.value = temp_field.value.replace('<FIELD>', field) -%}
        {%- set list_result.value = list_result.value ~ temp_field.value ~ '\n' -%}
    {%- endfor -%}
    {{ list_result['value'] }}
{%- endmacro %}
