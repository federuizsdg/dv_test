{% macro generate_satellite(metadata_dict) %}
    {%- set models_to_link = metadata_dict['source_models'] -%}
    {%- set merged_keys_for_where = metadata_dict['src_pk'] + metadata_dict['src_hashdiff'] + metadata_dict['src_payload'] + metadata_dict['src_eff']  + metadata_dict['src_ldts']  + metadata_dict['src_source']-%}
    {%- set ctes_template = namespace(value='') -%}
    {%- set ctes_template.value = ctes_template.value ~ 'WITH source_data AS (' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'SELECT <COLUMNS_A>' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'FROM <SOURCE> AS a' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'WHERE a.<PK> IS NOT NULL' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ '),' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ '' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'records_to_insert AS (' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'SELECT DISTINCT <COLUMNS_R>' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'FROM source_data AS stage' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ ')' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ '' ~ '\n' -%}
    {%- set ctes_template.value = ctes_template.value ~ 'SELECT * FROM records_to_insert' ~ '\n' -%}

    {%- set records_to_insert = namespace(value='') -%}
    {%- set records_to_insert.value = ctes_template.value -%}

    {%- set records_to_insert.value = records_to_insert.value.replace('<COLUMNS_A>', generate_source_fields_list(  merged_keys_for_where , 'a' ) ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<SOURCE>', metadata_dict['source_models'][0] ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<PK>', metadata_dict['src_pk'][0] ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<COLUMNS_R>', generate_source_fields_list(  merged_keys_for_where , 'stage' ) ) -%}

    {{ records_to_insert['value'] }}

{%- endmacro %}