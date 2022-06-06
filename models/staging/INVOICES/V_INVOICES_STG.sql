{{ config (
  materialized= 'view',
  schema= var('target_schema'),
  tags= ["staging","daily"]
)
}}

WITH invoice_line AS (
  SELECT * FROM  {{ref('V_INVOICE_LINE_ITEM_STG')}}
),
invoice_header AS (
  SELECT * FROM  {{ref('V_INVOICE_HEADER_STG')}}
),
rename AS 
(
SELECT  
--DLHK
  MD5(IL.K_INVOICE_LINE_ITEM_DLHK) AS K_INVOICE_LINE_ITEM_DLHK
  ,MD5(IL.K_INVOICE_DLHK) AS K_INVOICE_DLHK
  ,MD5(IL.K_PLAN_DLHK) AS K_PLAN_DLHK
  ,MD5(IL.K_SUBSCRIPTION_DLHK) AS K_SUBSCRIPTION_DLHK
  ,MD5(IL.K_SUBSCRIPTION_ITEM_DLHK) AS K_SUBSCRIPTION_ITEM_DLHK
  ,I.K_CHARGE_DLHK
  ,I.K_CUSTOMER_DLHK
--BK
  ,IL.K_INVOICE_LINE_ITEM_BK
  ,IL.K_INVOICE_BK
  ,IL.K_PLAN_BK
  ,IL.K_SUBSCRIPTION_BK
  ,IL.K_SUBSCRIPTION_ITEM_BK
  ,I.K_CHARGE_BK
  ,I.K_CUSTOMER_BK
  --ATTRIBUTES
  ,IL.A_CURRENCY
  ,IL.A_DESCRIPTION
  ,IL.A_INVOICE_LINE_ITEM_TYPE
  ,IL.A_PERIOD_START AS A_PERIOD_START_AT
  ,IL.A_PERIOD_END AS A_PERIOD_END_AT
  ,I.A_CREATED AS  A_INVOICE_CREATED_AT
  ,I.A_ACCOUNT_COUNTRY AS  A_INVOICE_ACCOUNT_COUNTRY
  ,I.A_ACCOUNT_NAME AS  A_INVOICE_ACCOUNT_NAME
  ,I.A_BILLING_REASON AS  A_INVOICE_BILLING_REASON
  ,I.A_CURRENCY AS  A_INVOICE_CURRENCY
  ,I.A_CUSTOM_FIELDS AS  A_INVOICE_CUSTOM_FIELDS
  ,I.A_DUE_DATE AS  A_INVOICE_DUE_DATE
  ,I.A_FOOTER AS  A_INVOICE_FOOTER
  ,I.A_LAST_FINALIZATION_ERROR AS  A_INVOICE_LAST_FINALIZATION_ERROR
  ,I.A_TRANSFER_DATA AS  A_INVOICE_TRANSFER_DATA
  ,I.A_WEBHOOKS_DELIVERED_AT AS  A_INVOICE_WEBHOOKS_DELIVERED_AT
  ,I.A_ACCOUNT_TAX_IDS AS  A_INVOICE_ACCOUNT_TAX_IDS
  ,I.A_CUSTOMER_TAX_IDS AS  A_INVOICE_CUSTOMER_TAX_IDS
  --BOOLEAN
  ,IL.B_LIVEMODE
  ,I.B_ATTEMPTED AS  B_INVOICE_ATTEMPTED
  ,I.B_AUTO_ADVANCE AS  B_INVOICE_AUTO_ADVANCE
  --METRICS

  ,I.M_TOTAL_DISCOUNT_AMOUNTS AS  M_INVOICE_TOTAL_DISCOUNT_AMOUNTS
  ,I.M_TOTAL_TAX_AMOUNTS AS  M_INVOICE_TOTAL_TAX_AMOUNTS
  ,I.M_AMOUNT_DUE AS  M_INVOICE_AMOUNT_DUE
  ,I.M_AMOUNT_REMAINING AS  M_INVOICE_AMOUNT_REMAINING
  ,I.M_ATTEMPT_COUNT AS  M_INVOICE_ATTEMPT_COUNT
  ,I.M_ENDING_BALANCE AS  M_INVOICE_ENDING_BALANCE
  ,I.M_SUBTOTAL AS  M_INVOICE_SUBTOTAL
  ,I.M_AMOUNT_PAID AS  M_INVOICE_AMOUNT_PAID
  ,I.M_TAX AS  M_INVOICE_TAX
  ,IL.M_INVOICE_LINE_AMOUNT
  ,IL.M_INVOICE_LINE_QUANTITY
  ,DIV0((I.M_AMOUNT_PAID * IL.M_AMOUNT),I.M_SUBTOTAL)::decimal(15,4) as M_ALLOCATED_PAID_AMOUNT    
  ,DIV0((I.M_TAX * IL.M_AMOUNT),I.M_SUBTOTAL)::decimal(15,4) as M_ALLOCATED_TOTAL_TAX_AMOUNTS
  ,DIV0((I.M_AMOUNT_DUE * IL.M_AMOUNT),I.M_SUBTOTAL)::decimal(15,4) as M_ALLOCATED_AMOUNT_DUE
  ,DIV0((I.M_AMOUNT_REMAINING * IL.M_AMOUNT),I.M_SUBTOTAL)::decimal(15,4) as M_ALLOCATED_AMOUNT_REMAINING
  --METADATA
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  invoice_line IL
  LEFT JOIN invoice_header I ON I.K_INVOICE_BK = IL.K_INVOICE_BK
)

SELECT * FROM rename