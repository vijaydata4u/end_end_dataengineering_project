{{ config(materialized='table', schema='gold') }}

with metrics_quality as (

    select
        'CONTENT_METRICS' as source_area,
        data_quality_status,
        count(*) as row_count
    from {{ ref('fact_content_metrics') }}
    group by data_quality_status

),

popularity_quality as (

    select
        'CONTENT_POPULARITY' as source_area,
        data_quality_status,
        count(*) as row_count
    from {{ ref('fact_content_popularity') }}
    group by data_quality_status

)

select * from metrics_quality

union all

select * from popularity_quality



select * from popularity_quality

select * from popularity_quality

