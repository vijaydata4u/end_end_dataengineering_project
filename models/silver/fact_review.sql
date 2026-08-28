{{ config(materialized='table') }}

select
    {{ generate_surrogate_key([
        'review_id',
        'user_name',
        'at'
    ]) }} as review_key,
    review_id,
    user_name,
    content,
    score,
    thumbs_up_count,
    review_created_version,
    at,
    app_version,
    ingest_dt,
    _ingestion_timestamp
from {{ ref('stg_netflix_reviews') }}
