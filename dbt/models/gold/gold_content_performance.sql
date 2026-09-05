{{ config(materialized='table', schema='gold') }}

with content as (

    select
        content_key,
        title,
        type,
        director,
        country,
        release_year,
        rating,
        duration,
        genres
    from {{ ref('dim_content') }}

),

metrics as (

    select
        content_key,
        imdb_id,
        imdb_score,
        imdb_votes,
        runtime
    from {{ ref('fact_content_metrics') }}
    where data_quality_status = 'VALID'

),

popularity as (

    select
        content_key,
        popularity,
        vote_count,
        vote_average
    from {{ ref('fact_content_popularity') }}
    where data_quality_status = 'VALID'

)

select
    d.content_key,
    d.title,
    d.type,
    d.director,
    d.country,
    d.release_year,
    d.rating,
    d.duration,
    d.genres,

    m.imdb_id,
    m.imdb_score,
    m.imdb_votes,
    m.runtime,

    p.popularity,
    p.vote_count,
    p.vote_average

from content d

left join metrics m
    on d.content_key = m.content_key

left join popularity p
    on d.content_key = p.content_key