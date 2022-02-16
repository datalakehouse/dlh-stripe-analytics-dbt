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
  MD5(MERCHANT) AS K_MERCHANT_DLHK
  ,MERCHANT AS A_MERCHANT_NAME  
FROM 
  source
WHERE
 MERCHANT IS NOT NULL
)

SELECT * FROM rename