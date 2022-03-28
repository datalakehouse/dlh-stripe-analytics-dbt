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
  BUDGET_ID AS K_BUDGET_BK
  ,BUDGET_NAME AS A_BUDGET_NAME
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  source
)

SELECT * FROM rename