{{ config(materialized='view', schema='staging') }}

select
cast(title AS STRING) as title,
try_cast(year AS INTEGER) as year,
cast(certificate AS STRING) as certificate,
cast(duration AS STRING) as duration,
cast(genre AS STRING) as genre,
try_cast(rating AS DOUBLE) as rating,
cast(description AS STRING) as description,
cast(stars AS STRING) as stars,
try_cast(votes AS BIGINT) as votes,
try_cast(ingest_dt AS TIMESTAMP) as ingest_dt,
cast(_rescued_data AS STRING) as _rescued_data,
cast(_source_name AS STRING) as _source_name,
cast(_dataset_name AS STRING) as _dataset_name,
cast(_source_file_name AS STRING) as _source_file_name,
try_cast(_ingestion_timestamp AS TIMESTAMP) as _ingestion_timestamp,
try_cast(_ingestion_date AS DATE) as _ingestion_date,
cast(_run_id AS STRING) as _run_id,
cast(_source_file_path AS STRING) as _source_file_path

from {{ source('bronze','netflix_movies') }}
