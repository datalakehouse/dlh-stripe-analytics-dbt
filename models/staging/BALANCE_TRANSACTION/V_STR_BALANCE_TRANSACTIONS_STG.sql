{{ config (
  materialized= 'view',
  schema= var('target_schema','STRIPE'),
  tags= ["staging","daily"]
)
}}

WITH balance_transactions AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_STRIPE_NEW'), 'BALANCE_TRANSACTION')}}
),
rename AS 
(
SELECT  
MD5(ID) AS K_BALANCE_TRANSACTION_DLHK
,MD5(SOURCE) AS K_SOURCE_DLHK
,ID AS K_BALANCE_TRANSACTION_BK
,SOURCE AS K_SOURCE_BK
,AVAILABLE_ON AS A_AVAILABLE_ON
,CREATED AS A_CREATED_AT
,CREATED::DATE AS A_CREATED_DATE_AT
,CURRENCY AS A_CURRENCY
,DESCRIPTION AS A_DESCRIPTION
,REPORTING_CATEGORY AS A_REPORTING_CATEGORY
,STATUS AS A_STATUS
,TRANSACTION_TYPE AS A_TRANSACTION_TYPE
--METRICS
,DIV0(AMOUNT,100) AS M_AMOUNT
,EXCHANGE_RATE AS M_EXCHANGE_RATE
,DIV0(NET,100) AS M_NET
  --METADATA
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  balance_transactions T
)

SELECT * FROM rename