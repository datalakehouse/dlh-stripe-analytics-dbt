{{ config (
  materialized= 'view',
  schema= var('target_schema','STRIPE'),
  tags= ["staging","daily"]
)
}}

WITH subscription AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_STRIPE_NEW'), 'SUBSCRIPTION')}}
),
subscription_item AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_STRIPE_NEW'), 'SUBSCRIPTION_ITEM')}}
),
rename AS 
(
SELECT  
  --DLHK
  MD5(I.ID) AS K_SUBSCRIPTION_ITEM_DLHK
  ,MD5(S.ID) AS K_SUBSCRIPTION_DLHK
  ,MD5(S.CUSTOMER_ID) AS K_CUSTOMER_DLHK
  ,MD5(I.PLAN_ID) AS K_PLAN_DLHK
  --BK
  ,S.ID AS K_SUBSCRIPTION_BK
  ,S.CUSTOMER_ID AS K_CUSTOMER_BK
  ,S.DEFAULT_SOURCE_ID AS K_DEFAULT_SOURCE_BK
  ,I.PLAN_ID AS K_PLAN_BK
  --ATTRIBUTES
  ,S.BILLING_CYCLE_ANCHOR AS A_BILLING_CYCLE_ANCHOR
  ,S.CREATED AS A_CREATED_AT
  ,S.CREATED::DATE AS A_CREATED_DATE_AT
  ,S.CURRENT_PERIOD_END AS A_CURRENT_PERIOD_END
  ,S.CURRENT_PERIOD_START AS A_CURRENT_PERIOD_START
  ,S.START_DATE AS A_START_DATE
  ,S.ENDED_AT AS A_ENDED_AT
  ,S.STATUS AS A_STATUS
  ,S.TRIAL_START AS A_TRIAL_START  
  ,S.TRIAL_END AS A_TRIAL_END
  ,S.CANCELED_AT AS A_CANCELED_AT
  ,S.CANCEL_AT AS A_CANCEL_AT
  ,I.CREATED AS A_ITEM_CREATED_AT
  ,I.CREATED::DATE AS A_ITEM_CREATED_DATE_AT
  --BOOLEAN
  ,S.BILLING_THRESHOLD_RESET_BILLING_CYCLE_ANCHOR AS B_BILLING_THRESHOLD_RESET_BILLING_CYCLE_ANCHOR
  ,S.CANCEL_AT_PERIOD_END AS B_CANCEL_AT_PERIOD_END
  ,S.LIVEMODE AS B_LIVEMODE
  --METRICS
  ,S.APPLICATION_FEE_PERCENT AS M_APPLICATION_FEE_PERCENT
  ,S.BILLING_THRESHOLD_AMOUNT_GTE AS M_BILLING_THRESHOLD_AMOUNT_GTE
  ,S.DAYS_UNTIL_DUE AS M_DAYS_UNTIL_DUE
  ,I.BILLING_THRESHOLDS_AMOUNT_GTE AS M_ITEM_BILLING_THRESHOLDS_AMOUNT_GTE
  ,I.QUANTITY AS M_ITEM_QUANTITY 
  --METADATA
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  subscription S
  LEFT JOIN subscription_item I on I.SUBSCRIPTION_ID = S.ID
)

SELECT * FROM rename