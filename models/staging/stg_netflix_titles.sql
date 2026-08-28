{{ config(materialized='view', schema='staging') }}

select
show_id,
cast(type AS STRING) as type,
cast(title AS STRING) as title,
cast(director AS STRING) as director,
cast(cast AS STRING) as cast,
cast(country AS STRING) as country,
try_cast(date_added AS DATE) as date_added,
try_cast(release_year AS INT) as release_year,
cast(rating AS STRING) as rating,
cast(duration AS STRING) as duration,
cast(listed_in AS STRING) as listed_in,
cast(description AS STRING) as description,
try_cast(ingest_dt AS TIMESTAMP) as ingest_dt,
cast(_rescued_data AS STRING) as _rescued_data,
cast(_source_name AS STRING) as _source_name,
cast(_dataset_name AS STRING) as _dataset_name,
cast(_source_file_path AS STRING) as _source_file_path,
try_cast(_ingestion_timestamp AS TIMESTAMP) as _ingestion_timestamp,
try_cast(_ingestion_date AS DATE) as _ingestion_date,
cast(_run_id AS STRING) as _run_id

from {{ source('bronze','netflix_titles') }}
