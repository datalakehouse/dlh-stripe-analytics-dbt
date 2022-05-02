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
  MD5(CURRENCY) AS K_CURRENCY_DLHK
  ,CURRENCY AS K_CURRENCY_BK
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  source
WHERE
  CURRENCY IS NOT NULL
)

SELECT * FROM rename