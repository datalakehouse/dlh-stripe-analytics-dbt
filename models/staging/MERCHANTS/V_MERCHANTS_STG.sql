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
  MD5(MERCHANT) AS K_MERCHANT_DLHK
  ,MERCHANT AS A_MERCHANT_NAME  
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  source
WHERE
 MERCHANT IS NOT NULL
)

SELECT * FROM rename