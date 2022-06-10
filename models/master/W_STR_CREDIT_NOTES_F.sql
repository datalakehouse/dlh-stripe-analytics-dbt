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
  {{ref('V_STR_CREDIT_NOTES_STG')}} AS C