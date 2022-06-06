{{ config (
  materialized= 'view',
  schema= var('target_schema'),
  tags= ["staging","daily"]
)
}}

WITH payment_method AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_STRIPE_NEW'), 'PAYMENT_METHOD')}}
),
payment_method_card AS (
  SELECT * FROM  {{source(var('source_schema', 'DEMO_STRIPE_NEW'), 'PAYMENT_METHOD_CARD')}}
),
rename AS 
(
SELECT  
  --DLHK  
  MD5(P.ID) AS K_PAYMENT_METHOD_DLHK
  ,MD5(P.CUSTOMER) AS K_CUSTOMER_DLHK
  ,MD5(C.ID) AS K_PAYMENT_METHOD_CARD_DLHK
  --BUSINESS KEYS
  ,P.ID AS K_PAYMENT_METHOD_BK
  ,P.CUSTOMER AS K_CUSTOMER_BK
  ,C.ID AS K_PAYMENT_METHOD_CARD_BK
  --ATTRIBUTES
  ,P.BILLING_DETAIL_ADDRESS_CITY AS A_BILLING_DETAIL_ADDRESS_CITY
  ,P.BILLING_DETAIL_ADDRESS_COUNTRY AS A_BILLING_DETAIL_ADDRESS_COUNTRY
  ,P.BILLING_DETAIL_ADDRESS_LINE_1 AS A_BILLING_DETAIL_ADDRESS_LINE_1
  ,P.BILLING_DETAIL_ADDRESS_LINE_2 AS A_BILLING_DETAIL_ADDRESS_LINE_2
  ,P.BILLING_DETAIL_ADDRESS_POSTAL_CODE AS A_BILLING_DETAIL_ADDRESS_POSTAL_CODE
  ,P.BILLING_DETAIL_ADDRESS_STATE AS A_BILLING_DETAIL_ADDRESS_STATE
  ,P.BILLING_DETAIL_EMAIL AS A_BILLING_DETAIL_EMAIL
  ,P.BILLING_DETAIL_NAME AS A_BILLING_DETAIL_NAME
  ,P.BILLING_DETAIL_PHONE AS A_BILLING_DETAIL_PHONE
  ,P.CREATED AS A_CREATED_AT  
  ,P.METHOD_TYPE AS A_METHOD_TYPE
  ,P.LIVEMODE AS B_LIVEMODE
  ,C.FINGERPRINT AS A_CARD_FINGERPRINT
  ,C.FUNDING AS A_CARD_FUNDING
  ,C.DESCRIPTION AS A_CARD_DESCRIPTION
  ,C.BRAND AS A_CARD_BRAND
  ,C.WALLET_TYPE AS A_CARD_WALLET_TYPE
  --METADATA
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  payment_method P
  LEFT JOIN payment_method_card C ON C.PAYMENT_METHOD_ID = P.ID
)

SELECT * FROM rename