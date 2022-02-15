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
  MD5(COALESCE(MERCHANT,'000000000000')) AS K_MERCHANT_DLHK
  ,MERCHANT AS A_MERCHANT_NAME  
FROM 
  source
)

SELECT * FROM rename