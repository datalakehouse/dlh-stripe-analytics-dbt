{{ config (
  materialized= 'view',
  schema= 'DOORDASH',
  tags= ["staging","daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source('TEST_SCHEMA_EXT_DEV','DOORDASH_RAW')}}
),
rename AS 
(
SELECT DISTINCT 
  MD5(CURRENCY) AS K_CURRENCY_DLHK
  ,CURRENCY AS K_CURRENCY_BK
FROM 
  source
WHERE
  CURRENCY IS NOT NULL
)

SELECT * FROM rename