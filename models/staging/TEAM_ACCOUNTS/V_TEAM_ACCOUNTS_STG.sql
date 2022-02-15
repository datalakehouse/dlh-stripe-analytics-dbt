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
  MD5(COALESCE(TEAM_ACCOUNT,'000000000000')) AS K_TEAM_ACCOUNT_DLHK
  ,TEAM_ACCOUNT AS A_TEAM_ACCOUNT 
FROM 
  source
)

SELECT * FROM rename