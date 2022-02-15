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
  MD5(CONCAT(EMPLOYEE_NAME,'-',EMPLOYEE_EMAIL)) AS K_EMPLOYEE_DLHK
  ,EMPLOYEE_NAME AS A_EMPLOYEE_NAME
  ,EMPLOYEE_EMAIL AS A_EMPLOYEE_EMAIL
FROM 
  source
)

SELECT * FROM rename