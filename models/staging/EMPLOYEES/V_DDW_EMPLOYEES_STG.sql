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
  MD5(CONCAT(COALESCE(EMPLOYEE_NAME,''),'-',COALESCE(EMPLOYEE_EMAIL,''))) AS K_EMPLOYEE_DLHK
  ,EMPLOYEE_NAME AS A_EMPLOYEE_NAME
  ,EMPLOYEE_EMAIL AS A_EMPLOYEE_EMAIL
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  source
WHERE
  (EMPLOYEE_EMAIL IS NOT NULL OR EMPLOYEE_EMAIL IS NOT NULL)
)

SELECT * FROM rename