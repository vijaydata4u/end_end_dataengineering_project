{{ config(materialized='table') }}

select
    {{ generate_surrogate_key([
        'title',
        'year',
        'genre'
    ]) }} as movie_key,
    title,
    year,
    certificate,
    duration,
    genre,
    rating,
    description,
    stars,
    votes,
    ingest_dt,
    _ingestion_timestamp
from {{ ref('stg_neflix_movies') }}
