{% macro generate_link (metadata_dict) %}
    {%- set models_to_link = metadata_dict['source_models'] -%}
    {%- set merged_keys_for_where = metadata_dict['src_pk'] + metadata_dict['src_fk'] -%}
    {%- set row_rank_template = namespace(value='') -%}
    {%- set row_rank_template.value = row_rank_template.value ~ 'WITH row_rank_<ITEM> AS ('~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '  SELECT <SOURCEALIAS>.<PK>, <FK>, <SOURCEALIAS>.<LDTS>, <SOURCEALIAS>.<SOURCE>,'~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '    ROW_NUMBER() OVER('~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '    PARTITION BY <SOURCEALIAS>.<PK>'~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '    ORDER BY <SOURCEALIAS>.<LDTS>'~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '  ) AS row_number'~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '  FROM <MODEL> AS <SOURCEALIAS>'~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '  <WHERE>'~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '  QUALIFY row_number = 1'~ '\n' -%}
    {%- set row_rank_template.value = row_rank_template.value ~ '),'~ '\n' -%}

    {%- set row_rank_union_template = namespace(value='') -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ 'row_rank_union AS (' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '    SELECT ru.*,' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '           ROW_NUMBER() OVER(' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '               PARTITION BY ru.<PK>' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '               ORDER BY ru.<LDTS>, ru.<SOURCE> ASC' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '           ) AS row_rank_number' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '    FROM stage_union AS ru' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '    <WHERE>' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '    QUALIFY row_rank_number = 1' ~ '\n' -%}
    {%- set row_rank_union_template.value = row_rank_union_template.value ~ '),' ~ '\n' -%}

    {%- set records_to_insert_template = namespace(value='') -%}
    {%- set records_to_insert_template.value = records_to_insert_template.value ~ 'records_to_insert AS (' ~ '\n' -%}
    {%- set records_to_insert_template.value = records_to_insert_template.value ~ 'SELECT <SOURCEALIAS>.<PK>, <FK>, a.<LDTS>, a.<SOURCE>' ~ '\n' -%}
    {%- set records_to_insert_template.value = records_to_insert_template.value ~ 'FROM <UNION> AS <SOURCEALIAS>' ~ '\n' -%}
    {%- set records_to_insert_template.value = records_to_insert_template.value ~ ')' ~ '\n' -%}
    {%- set records_to_insert_template.value = records_to_insert_template.value ~ '\n' -%}
    {%- set records_to_insert_template.value = records_to_insert_template.value ~ 'SELECT * FROM records_to_insert' ~ '\n' -%}

    {%- for model_name in models_to_link -%}

        {%- set row_rank_item = namespace(value='') -%}
        {%- set row_rank_item.value = row_rank_template.value -%}
        {%- if not loop.first-%}
            {%- set row_rank_item.value = row_rank_item.value.replace('WITH ', '' ) -%}
        {%- endif -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<ITEM>', loop.index|string ) -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<PK>', metadata_dict['src_pk'][0] ) -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<FK>', generate_source_fields_list( metadata_dict['src_fk'], 'rr' ) ) -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<SOURCEALIAS>', 'rr' ) -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<LDTS>', metadata_dict['src_ldts'] ) -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<SOURCE>', metadata_dict['src_source'] ) -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<MODEL>', metadata_dict['source_models'][loop.index0] ) -%}
        {%- set row_rank_item.value = row_rank_item.value.replace('<WHERE>', generate_where_from_list(  merged_keys_for_where , 'rr' ) ) -%}
        {{ row_rank_item['value'] }}
        {{ '\n' }}
    {%- endfor -%}
    {%- if models_to_link|length > 1 -%}
      {{'stage_union AS ('}}{{'\n'}}
      {%- for model_name in models_to_link -%}
        {{'  SELECT * FROM row_rank'}}_{{loop.index|string}}
        {{'UNION ALL' ~ '\n' if not loop.last}}
      {%- endfor -%}
      {{- '),' ~ '\n' ~ '\n' -}}

      {%- set row_rank_union = namespace(value='') -%}
      {%- set row_rank_union.value = row_rank_union_template.value -%}
      {%- set row_rank_union.value = row_rank_union.value.replace('<PK>', metadata_dict['src_pk'][0] ) -%}
      {%- set row_rank_union.value = row_rank_union.value.replace('<LDTS>', metadata_dict['src_ldts'] ) -%}
      {%- set row_rank_union.value = row_rank_union.value.replace('<SOURCE>', metadata_dict['src_source'] ) -%}
      {%- set row_rank_union.value = row_rank_union.value.replace('<WHERE>', generate_where_from_list(  merged_keys_for_where , 'ru' ) ) -%}
      {{ row_rank_union['value'] }}{{'\n'}}
    {%- endif -%}
    {%- set records_to_insert = namespace(value='') -%}
    {%- set records_to_insert.value = records_to_insert_template.value -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<PK>', metadata_dict['src_pk'][0] ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<FK>', generate_source_fields_list( metadata_dict['src_fk'] , 'a') ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<SOURCEALIAS>', 'a' ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<LDTS>', metadata_dict['src_ldts'] ) -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<SOURCE>', metadata_dict['src_source'] ) -%}
    {%- if models_to_link|length > 1 -%}
        {%- set union_type = 'row_rank_union' -%}
    {%- else -%}
        {%- set union_type = 'row_rank_1' -%}
    {%- endif -%}
    {%- set records_to_insert.value = records_to_insert.value.replace('<UNION>', union_type ) -%}
    {{ records_to_insert['value'] }}
{%- endmacro %}



