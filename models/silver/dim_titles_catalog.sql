{{ config(materialized='table') }}

select
    {{ generate_surrogate_key([
        'id',
        'title',
        'release_year'
    ]) }} as catalog_title_key,
    id,
    title,
    type,
    description,
    release_year,
    age_certification,
    runtime,
    imdb_id,
    imdb_score,
    imdb_votes,
    ingest_dt,
    _ingestion_timestamp
from {{ ref('stg_netflix_tv_shows_movies') }}
