{{ config (
  materialized= 'view',
  schema= var('target_schema'),
  tags= ["staging","daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source(var('source_schema'),'DOORDASH_RAW')}}
),
rename AS 
(
SELECT DISTINCT 
  MD5(TEAM_ACCOUNT) AS K_TEAM_ACCOUNT_DLHK
  ,TEAM_ACCOUNT AS A_TEAM_ACCOUNT 
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  source
WHERE
  TEAM_ACCOUNT IS NOT NULL
)

SELECT * FROM rename