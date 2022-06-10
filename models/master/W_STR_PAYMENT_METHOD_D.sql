{{ config (
  materialized= 'table',
  schema= var('target_schema','STRIPE'),
  tags= ["staging", "daily"],
  transient=false
)
}}

SELECT
  *
FROM
  {{ref('V_STR_PAYMENT_METHOD_STG')}}


  