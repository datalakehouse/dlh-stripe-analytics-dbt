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
  MD5(COALESCE(BUDGET_ID,'000000000000')) AS K_BUDGET_DLHK
  ,BUDGET_ID AS K_BUDGET_BK
  ,BUDGET_NAME AS A_BUDGET_NAME
FROM 
  source
)

SELECT * FROM rename