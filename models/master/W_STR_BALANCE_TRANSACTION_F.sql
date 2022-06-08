{{ config (
  materialized= 'table',
  schema= var('target_schema'),
  tags= ["staging", "daily"],
  transient=false
)
}}


WITH balance_transactions AS (
  SELECT * FROM {{ref('V_STR_BALANCE_TRANSACTIONS_STG')}}
),
charge as (
  SELECT * FROM {{ref('V_STR_CHARGES_STG')}}
),
payment_intent as (
  SELECT * FROM {{ref('V_STR_PAYMENT_INTENT_STG')}}
),
payout as (
  SELECT * FROM {{ref('V_STR_PAYOUT_STG')}}
),
refund as (
  SELECT * FROM {{ref('V_STR_REFUND_STG')}}
)

SELECT 
    balance_transactions.K_BALANCE_TRANSACTION_DLHK
    ,charge.K_CHARGE_DLHK
    ,payment_intent.K_PAYMENT_INTENT_DLHK
    ,charge.K_PAYMENT_METHOD_DLHK
    ,payout.K_PAYOUT_DLHK
    ,charge.K_PAYMENT_METHOD_BK
    ,charge.K_CHARGE_BK
    ,payment_intent.K_PAYMENT_INTENT_BK
    ,payout.K_PAYOUT_BK    
    ,balance_transactions.K_BALANCE_TRANSACTION_BK
    ,balance_transactions.A_CREATED_AT    
    ,balance_transactions.K_SOURCE_BK
    ,balance_transactions.A_AVAILABLE_ON    
    ,balance_transactions.A_CURRENCY
    ,balance_transactions.A_DESCRIPTION
    ,balance_transactions.A_REPORTING_CATEGORY
    ,balance_transactions.A_STATUS
    ,balance_transactions.A_TRANSACTION_TYPE
    ,balance_transactions.M_AMOUNT
    ,balance_transactions.M_EXCHANGE_RATE
    ,balance_transactions.M_NET
    ,CASE
        WHEN balance_transactions.A_TRANSACTION_TYPE in ('charge', 'payment') then 'charge'
        WHEN balance_transactions.A_TRANSACTION_TYPE in ('refund', 'payment_refund') then 'refund'
        WHEN balance_transactions.A_TRANSACTION_TYPE in ('payout_cancel', 'payout_failure') then 'payout_reversal'
        WHEN balance_transactions.A_TRANSACTION_TYPE in ('transfer', 'recipient_transfer') then 'transfer'
        WHEN balance_transactions.A_TRANSACTION_TYPE in ('transfer_cancel', 'transfer_failure', 'recipient_transfer_cancel', 'recipient_transfer_failure') then 'transfer_reversal'
        ELSE balance_transactions.A_TRANSACTION_TYPE
    END as A_REPORTING_TRANSACTION_CATEGORY
    ,CASE WHEN balance_transactions.A_TRANSACTION_TYPE = 'charge' then charge.M_AMOUNT end as M_CUSTOMER_FACING_AMOUNT
    ,CASE WHEN balance_transactions.A_TRANSACTION_TYPE = 'charge' then charge.A_CURRENCY end as A_CUSTOMER_FACING_CURRENCY
    ,COALESCE(charge.K_CUSTOMER_DLHK,charge_refund.K_CUSTOMER_DLHK) AS K_CHARGE_CUSTOMER_DLHK    
    ,charge.A_RECEIPT_EMAIL    
    ,charge.A_CREATED_AT as A_CHARGE_CREATED_AT    
    ,payout.A_ARRIVAL_DATE as A_PAYOUT_EXPECTED_ARRIVAL_DATE
    ,payout.A_STATUS as A_PAYOUT_STATUS
    ,payout.A_TYPE as A_PAYOUT_TYPE
    ,payout.A_DESCRIPTION as A_PAYOUT_DESCRIPTION
    ,refund.A_REASON as A_REFUND_REASON
FROM balance_transactions

left join charge on charge.K_BALANCE_TRANSACTION_DLHK = balance_transactions.K_BALANCE_TRANSACTION_DLHK
left join payment_intent on payment_intent.K_PAYMENT_INTENT_DLHK = charge.K_PAYMENT_INTENT_DLHK
left join payout on payout.K_BALANCE_TRANSACTION_DLHK = balance_transactions.K_BALANCE_TRANSACTION_DLHK
left join refund on refund.K_BALANCE_TRANSACTION_DLHK = balance_transactions.K_BALANCE_TRANSACTION_DLHK
left join charge as charge_refund on charge_refund.K_CHARGE_DLHK = refund.K_CHARGE_DLHK




