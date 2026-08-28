{{ config(materialized='view', schema='staging') }}

select
cast(reviewId AS STRING) as review_id,
cast(userName AS STRING) as user_name,
cast(content AS STRING) as content,
try_cast(score AS DOUBLE) as score,
try_cast(thumbsUpCount AS BIGINT) as thumbs_up_count,
cast(reviewCreatedVersion AS STRING) as review_created_version,
try_cast(at AS TIMESTAMP) as at,
cast(appVersion AS STRING) as app_version,
try_cast(ingest_dt AS TIMESTAMP) as ingest_dt,
cast(_rescued_data AS STRING) as _rescued_data,
cast(_source_name AS STRING) as _source_name,
cast(_dataset_name AS STRING) as _dataset_name,
cast(_source_file_path AS STRING) as _source_file_path,
try_cast(_ingestion_timestamp AS TIMESTAMP) as _ingestion_timestamp,
try_cast(_ingestion_date AS DATE) as _ingestion_date,
cast(_run_id AS STRING) as _run_id

from {{ source('bronze','netflix_reviews') }}
