{{ config(materialized='table', schema='silver') }}

with content_union as (

    select
        cast(show_id as string) as source_content_id,
        trim(cast(title as string)) as title,
        lower(trim(cast(type as string))) as content_type,
        try_cast(release_year as int) as release_year,
        cast(director as string) as director,
        cast(country as string) as country,
        cast(rating as string) as rating,
        cast(duration as string) as duration,
        cast(listed_in as string) as genres,
        cast(description as string) as description,
        1 as source_priority,
        'stg_netflix_titles' as source_model

    from {{ ref('stg_netflix_titles') }}

    union all

    select
        cast(show_id as string) as source_content_id,
        trim(cast(title as string)) as title,
        lower(trim(cast(type as string))) as content_type,
        try_cast(release_year as int) as release_year,
        cast(director as string) as director,
        cast(country as string) as country,
        cast(rating as string) as rating,
        cast(duration as string) as duration,
        cast(genres as string) as genres,
        cast(description as string) as description,
        2 as source_priority,
        'stg_netflix_tv_shows_details' as source_model

    from {{ ref('stg_netflix_tv_shows_details') }}

    union all

    select
        cast(id as string) as source_content_id,
        trim(cast(title as string)) as title,
        lower(trim(cast(type as string))) as content_type,
        try_cast(release_year as int) as release_year,
        null as director,
        null as country,
        cast(age_certification as string) as rating,
        cast(runtime as string) as duration,
        null as genres,
        cast(description as string) as description,
        3 as source_priority,
        'stg_netflix_tv_shows_movies' as source_model

    from {{ ref('stg_netflix_tv_shows_movies') }}

),

valid_content as (

    select *
    from content_union

    where title is not null
      and trim(title) <> ''
      and release_year is not null
      and content_type in ('movie', 'tv show')

),

deduplicated as (

    select
        *,
        row_number() over (
            partition by
                lower(trim(title)),
                release_year,
                content_type
            order by source_priority
        ) as rn

    from valid_content

)

select

    {{ generate_surrogate_key([
        "lower(trim(title))",
        "release_year",
        "content_type"
    ]) }} as content_key,

    source_content_id,
    title,
    content_type as type,
    director,
    country,
    release_year,
    rating,
    duration,
    genres,
    description,
    source_model

from deduplicated

where rn = 1