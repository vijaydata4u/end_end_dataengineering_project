{{ config(materialized='table', schema='silver') }}

with content_metrics as (

    select
        cast(id as string) as source_content_id,
        trim(cast(title as string)) as title,
        lower(trim(cast(type as string))) as content_type,
        try_cast(release_year as int) as release_year,
        cast(imdb_id as string) as imdb_id,
        try_cast(imdb_score as double) as imdb_score,
        try_cast(imdb_votes as bigint) as imdb_votes,
        try_cast(runtime as int) as runtime,
        ingest_dt,
        _ingestion_timestamp

    from {{ ref('stg_netflix_tv_shows_movies') }}

),

enriched as (

    select
        d.content_key,

        c.source_content_id,
        c.title,
        c.content_type,
        c.release_year,
        c.imdb_id,
        c.imdb_score,
        c.imdb_votes,
        c.runtime,
        c.ingest_dt,
        c._ingestion_timestamp,

        case
            when c.title is null or trim(c.title) = ''
                then 'INVALID_TITLE'

            when c.release_year is null
                then 'INVALID_YEAR'

            when c.content_type not in ('movie', 'tv show')
                then 'INVALID_TYPE'

            when d.content_key is null
                then 'UNMATCHED_DIMENSION'

            else 'VALID'
        end as data_quality_status

    from content_metrics c

    left join {{ ref('dim_content') }} d
        on lower(trim(c.title)) = lower(trim(d.title))
       and c.release_year = d.release_year
       and c.content_type = lower(trim(d.type))

),

valid_ranked as (

    select
        *,
        row_number() over (
            partition by content_key
            order by
                _ingestion_timestamp desc,
                ingest_dt desc,
                source_content_id desc
        ) as rn

    from enriched

    where data_quality_status = 'VALID'

),

valid_rows as (

    select
        content_key,
        source_content_id,
        title,
        content_type,
        release_year,
        imdb_id,
        imdb_score,
        imdb_votes,
        runtime,
        ingest_dt,
        _ingestion_timestamp,
        data_quality_status

    from valid_ranked

    where rn = 1

),

invalid_rows as (

    select
        content_key,
        source_content_id,
        title,
        content_type,
        release_year,
        imdb_id,
        imdb_score,
        imdb_votes,
        runtime,
        ingest_dt,
        _ingestion_timestamp,
        data_quality_status

    from enriched

    where data_quality_status <> 'VALID'

)

select * from valid_rows

union all

select * from invalid_rows