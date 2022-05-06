{{ config (
  materialized= 'view',
  schema= var('target_schema'),
  tags= ["staging","daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source(var('source_schema'),'DOORDASH_RAW')}}
),
rename as (
SELECT DISTINCT 
    MD5(DELIVERY_ADDRESS) AS K_DELIVERY_ADDRESS_DLHK
    ,TRIM(SPLIT_PART(DELIVERY_ADDRESS, ',', 4))||'-'||TRIM(SPLIT_PART(TRIM(SPLIT_PART(DELIVERY_ADDRESS, ',', 3)),' ',2))  AS K_COUNTRY_POSTALCODE_BK    
    ,TRIM(SPLIT_PART(DELIVERY_ADDRESS, ',', 1)) AS A_DELIVERY_STREET
    ,TRIM(SPLIT_PART(DELIVERY_ADDRESS, ',', 2)) AS A_DELIVERY_CITY
    ,TRIM(SPLIT_PART(TRIM(SPLIT_PART(DELIVERY_ADDRESS, ',', 3)),' ',1)) AS A_DELIVERY_STATE
    ,TRIM(SPLIT_PART(TRIM(SPLIT_PART(DELIVERY_ADDRESS, ',', 3)),' ',2)) AS A_DELIVERY_POSTALCODE
    ,TRIM(SPLIT_PART(DELIVERY_ADDRESS, ',', 4)) AS A_DELIVERY_COUNTRY
    , '{{invocation_id}}' as MD_INTGR_ID
    , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  source
WHERE 
   DELIVERY_ADDRESS IS NOT NULL
)

SELECT * FROM rename