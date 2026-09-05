{{ config(materialized='view', schema='staging') }}

select
cast(date AS DATE) as date,
cast(open AS DOUBLE) as open,
cast(high AS DOUBLE) as high,
cast(low AS DOUBLE) as low,
cast(close AS DOUBLE) as close,
cast(volume AS BIGINT) as volume,
cast(dividends AS DOUBLE) as dividends,
cast(stock_splits AS DOUBLE) as stock_splits,
cast(ingest_dt AS TIMESTAMP) as ingest_dt,
cast(_rescued_data AS STRING) as _rescued_data,
cast(_source_name AS STRING) as _source_name,
cast(_dataset_name AS STRING) as _dataset_name,
cast(_source_file_path AS STRING) as _source_file_path,
cast(_ingestion_timestamp AS TIMESTAMP) as _ingestion_timestamp,
cast(_ingestion_date AS DATE) as _ingestion_date,
cast(_run_id AS STRING) as _run_id

from {{ source('bronze','netflix_stock_history') }}