{{ config(materialized='table') }}

select
    {{ generate_surrogate_key([
        'show_id',
        'title',
        'release_year'
    ]) }} as title_key,
    show_id,
    type,
    title,
    director,
    cast,
    country,
    release_year,
    rating,
    duration,
    listed_in as genres,
    description,
    ingest_dt,
    _ingestion_timestamp
from {{ ref('stg_netflix_titles') }}
