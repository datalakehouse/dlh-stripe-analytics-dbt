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
  MD5(TEAM_ACCOUNT) AS K_TEAM_ACCOUNT_DLHK
  ,TEAM_ACCOUNT AS A_TEAM_ACCOUNT 
FROM 
  source
WHERE
  TEAM_ACCOUNT IS NOT NULL
)

SELECT * FROM rename