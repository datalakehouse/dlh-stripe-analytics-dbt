{{ config (
  materialized= 'view',
  schema= var('target_schema'),
  tags= ["staging","daily"]
)
}}

WITH source AS (
  SELECT * FROM  {{source(var('source_schema'),'DOORDASH_RAW')}}
),
{% if var('include_third_party_data_weather__weathersource') %}
weather AS (
  SELECT * FROM  {{ref('V_WEATHER_CONDITIONS_STG')}}
),
{% endif %}
delivery_address AS (
  SELECT * FROM  {{ ref('V_DELIVERY_ADDRESS_STG') }}
),
budget_hist AS (
  SELECT * FROM  {{ ref('W_BUDGET_D') }}
),
rename AS 
(
SELECT DISTINCT 
  MD5(S.ORDER_ID) AS K_ORDER_DLHK  
  ,MD5(CONCAT(COALESCE(S.EMPLOYEE_NAME,''),'-',COALESCE(S.EMPLOYEE_EMAIL,''))) AS K_EMPLOYEE_DLHK
  ,MD5(S.CURRENCY) AS K_CURRENCY_DLHK
  ,B.K_BUDGET_DLHK AS K_BUDGET_DLHK
  ,MD5(S.MERCHANT) AS K_MERCHANT_DLHK
  ,MD5(S.TEAM_ACCOUNT) AS K_TEAM_ACCOUNT_DLHK
  ,MD5(S.DELIVERY_ADDRESS) AS K_DELIVERY_ADDRESS_DLHK
  ,S.ORDER_ID AS K_ORDER_BK
  ,S.DELIVERY_DATE AS A_DELIVERY_DATE
  ,S.DELIVERY_TIME AS A_DELIVERY_TIME
  ,S.PICKUP_DELIVERY AS A_PICKUP_DELIVERY
  ,S.EXPENSE_CODE AS A_EXPENSE_CODE
  ,S.EXPENSE_NOTES AS A_EXPENSE_NOTE
  {% if var('include_third_party_data_weather__weathersource') %}
  ,W.A_WEATHER_CONDITION_SUMMARY
  ,W.A_AVG_TEMPERATURE_SUMMARY
  {% endif %}  
  ,ROUND(NVL(S.SUBTOTAL, 000), 2)::decimal(15,2) M_SUBTOTAL
  ,ROUND(NVL(S.TAX, 000), 2)::decimal(15,2) M_TAX
  ,ROUND(NVL(S.TIP, 000), 2)::decimal(15,2) M_TIP
  ,ROUND(NVL(S.SERVICE_FEE, 000), 2)::decimal(15,2) M_SERVICE_FEE
  ,ROUND(NVL(S.DELIVERY_FEE, 000), 2)::decimal(15,2) M_DELIVERY_FEE
  ,ROUND(NVL(S.LEGISLATIVE_FEE, 000), 2)::decimal(15,2) M_LEGISLATIVE_FEE
  ,ROUND(NVL(S.SMALL_ORDER_FEE, 000), 2)::decimal(15,2) M_SMALL_ORDER_FEE
  ,ROUND(NVL(S.DISCOUNTS_PROMOTIONS, 000), 2)::decimal(15,2) M_DISCOUNTS_PROMOTIONS
  ,ROUND(NVL(S.ORDER_TOTAL, 000), 2)::decimal(15,2) M_ORDER_TOTAL
  ,ROUND(NVL(S.COMPANY_PAID, 000), 2)::decimal(15,2) M_COMPANY_PAID
  ,ROUND(NVL(S.EMPLOYEE_PAID, 000), 2)::decimal(15,2) M_EMPLOYEE_PAID
  ,CASE WHEN S.ORDER_TOTAL > B.M_AMOUNT THEN ROUND(S.ORDER_TOTAL - B.M_AMOUNT,2)::decimal(15,2) ELSE 0 END AS M_AMOUNT_ABOVE_BUDGET
  ,CASE WHEN S.ORDER_TOTAL > B.M_AMOUNT THEN TRUE ELSE FALSE END AS IS_ABOVE_BUDGET
  , '{{invocation_id}}' as MD_INTGR_ID
  , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM 
  source S
  LEFT JOIN delivery_address A ON A.K_DELIVERY_ADDRESS_DLHK = MD5(S.DELIVERY_ADDRESS)
  {% if var('include_third_party_data_weather__weathersource') %}
  LEFT JOIN weather W on W.K_WEATHER_DLHK = MD5(A.K_COUNTRY_POSTALCODE_BK||'-'||TRIM(S.DELIVERY_DATE))
  {% endif %}
  LEFT JOIN budget_hist B ON B.K_BUDGET_BK = S.BUDGET_ID AND S.DELIVERY_DATE >= B.START_DATE  AND (S.DELIVERY_DATE < B.END_DATE   OR B.END_DATE IS NULL)
)

SELECT * FROM rename