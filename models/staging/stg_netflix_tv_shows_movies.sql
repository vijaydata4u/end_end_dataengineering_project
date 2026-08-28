{{ config(materialized='view', schema='staging') }}

select
try_cast(index AS INT) as index,
cast(id AS STRING) as id,
cast(title AS STRING) as title,
cast(type AS STRING) as type,
cast(description AS STRING) as description,
try_cast(release_year AS INT) as release_year,
cast(age_certification AS STRING) as age_certification,
try_cast(runtime AS INT) as runtime,
cast(imdb_id AS STRING) as imdb_id,
try_cast(imdb_score AS DOUBLE) as imdb_score,
try_cast(imdb_votes AS INT) as imdb_votes,
try_cast(ingest_dt AS TIMESTAMP) as ingest_dt,
cast(_rescued_data AS STRING) as _rescued_data,
cast(_source_name AS STRING) as _source_name,
cast(_dataset_name AS STRING) as _dataset_name,
cast(_source_file_path AS STRING) as _source_file_path,
try_cast(_ingestion_timestamp AS TIMESTAMP) as _ingestion_timestamp,
try_cast(_ingestion_date AS DATE) as _ingestion_date,
cast(_run_id AS STRING) as _run_id

from {{ source('bronze','netflix_tv_shows_movies') }}
