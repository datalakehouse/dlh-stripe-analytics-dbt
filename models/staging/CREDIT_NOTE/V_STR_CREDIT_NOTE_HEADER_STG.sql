{{ config (
  materialized= 'view',
  schema= var('target_schema'),
  tags= ["staging","daily"]
)
}}

WITH credit_note AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_STRIPE_NEW'), 'CREDIT_NOTE')}}
),
rename AS 
(
SELECT  
--DLHK
  MD5(ID) AS K_CREDIT_NOTE_DLHK
  ,MD5(CUSTOMER) AS K_CUSTOMER_DLHK
  --BK
  ,ID AS K_CREDIT_NOTE_BK
  ,CUSTOMER AS K_CUSTOMER_BK
  ,INVOICE AS K_INVOICE_BK
  ,REFUND AS K_REFUND_BK
  ,CUSTOMER_BALANCE_TRANSACTION AS K_CUSTOMER_BALANCE_TRANSACTION_BK
  --ATTRIBUTES
  ,CREATED AS A_CREATED_AT
  ,CREDIT_NOTE_TYPE AS A_CREDIT_NOTE_TYPE
  ,CURRENCY AS A_CURRENCY    
  ,MEMO AS A_MEMO
  ,NUMBER AS A_NUMBER
  ,OUT_OF_BAND_AMOUNT AS A_OUT_OF_BAND_AMOUNT
  ,PDF AS A_PDF
  ,REASON AS A_REASON
  ,STATUS AS A_STATUS
  --BOOLEAN
  ,LIVEMODE AS B_LIVEMODE
  --METRICS
  ,AMOUNT AS M_AMOUNT
  ,DISCOUNT_AMOUNT AS M_DISCOUNT_AMOUNT
  ,SUBTOTAL AS M_SUBTOTAL
  ,TOTAL AS M_TOTAL
  --METADATA
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  credit_note I
)

SELECT * FROM rename