{{ config (
  materialized= 'view',
  schema= var('target_schema'),
  tags= ["staging","daily"]
)
}}

WITH credut_note_line AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_STRIPE_NEW'), 'CREDIT_NOTE_LINE_ITEM')}}
),
rename AS 
(
SELECT  
  --DLHK
  MD5(ID) AS K_CREDIT_NOTE_ITEM_DLHK
  --BK  
  ,ID AS K_K_CREDIT_NOTE_ITEM_BK
  ,INVOICE_LINE_ITEM AS K_INVOICE_LINE_ITEM_BK
  ,DESCRIPTION AS A_DESCRIPTION  
  ,UNIT_AMOUNT_DECIMAL AS A_UNIT_AMOUNT_DECIMAL
  ,LIVEMODE AS B_LIVEMODE  
  ,AMOUNT AS M_AMOUNT
  ,DISCOUNT_AMOUNT AS M_DISCOUNT_AMOUNT
  ,QUANTITY AS M_QUANTITY
  ,UNIT_AMOUNT AS M_UNIT_AMOUNT
  --METADATA
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  credut_note_line I
)

SELECT * FROM rename