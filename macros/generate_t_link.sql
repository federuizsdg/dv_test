{% macro generate_t_link(metadata_dict) %}
    {%- set models_to_link = metadata_dict['source_models'] -%}
    {%- set merged_keys_for_where = metadata_dict['src_pk'] + metadata_dict['src_fk'] -%}
    {%- set merged_values_for_columns = metadata_dict['src_pk'] + metadata_dict['src_fk'] + metadata_dict['src_payload'] + metadata_dict['src_eff']  + metadata_dict['src_ldts']  + metadata_dict['src_source']-%}
    {%- set ctes_template = namespace(value='') -%}
    {%- set ctes_template.value = ctes_template.value ~ 'WITH stage AS (' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'SELECT <COLUMNS_STAGE>' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'FROM <SOURCE> AS a' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ '<WHERE>' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ '),' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ '' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'records_to_insert AS (' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'SELECT DISTINCT <COLUMNS_STG>' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'FROM stage AS stg' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ ')' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ '' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'SELECT * FROM records_to_insert' ~ '\n' -%}

    {%- set records_to_insert = namespace(value='') -%}
    {%- set records_to_insert.value = ctes_template.value -%}

    {%- set records_to_insert.value = records_to_insert.value.replace('<COLUMNS_STAGE>', generate_source_fields_list(  merged_values_for_columns , 'a' ) ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<SOURCE>', metadata_dict['source_models'][0] ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<WHERE>', generate_where_from_list(  merged_keys_for_where , 'a' ) ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<COLUMNS_STG>', generate_source_fields_list(  merged_values_for_columns , 'stg' ) ) -%}

    {{ records_to_insert['value'] }}
{%- endmacro %}