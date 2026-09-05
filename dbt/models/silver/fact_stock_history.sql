{{ config(materialized='table') }}

select
    {{ generate_surrogate_key([
        'date',
        'open',
        'close'
    ]) }} as stock_date_key,
    date,
    open,
    high,
    low,
    close,
    volume,
    dividends,
    stock_splits,
    ingest_dt,
    _ingestion_timestamp
from {{ ref('stg_netflix_stock_history') }}
