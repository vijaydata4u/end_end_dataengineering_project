{{ config(materialized='table') }}

select
    {{ generate_surrogate_key([
        'show_id',
        'title',
        'release_year'
    ]) }} as tv_show_key,
    show_id,
    type,
    title,
    director,
    cast,
    country,
    date_added,
    release_year,
    rating,
    duration,
    genres,
    language,
    description,
    popularity,
    vote_count,
    vote_average,
    ingest_dt,
    _ingestion_timestamp
from {{ ref('stg_netflix_tv_shows_details') }}
