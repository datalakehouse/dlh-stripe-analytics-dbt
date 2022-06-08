{{ config (
  materialized= 'table',
  schema= var('target_schema'),
  tags= ["staging", "daily"],
  transient=false
)
}}

select subs.K_CUSTOMER_DLHK,
  subs.K_PLAN_DLHK,
  'day' as interval,
   date_cross.DATE_COLUMN date_ref,
  count(case when (subs.A_CURRENT_PERIOD_END::DATE is NULL or subs.A_CURRENT_PERIOD_END::DATE >= DATEADD(day,1, date_cross.DATE_COLUMN)) and subs.A_CURRENT_PERIOD_START::DATE < dateadd(day, 1, date_cross.DATE_COLUMN) then subs.K_SUBSCRIPTION_DLHK end) total_subscriptions  
FROM {{ref('W_STR_SUBSCRIPTION_F') }} subs
 CROSS JOIN
 {{ref('W_STR_DATE_D')}} date_cross
 where date_cross.DATE_COLUMN >= DATEADD(DAY, -1, A_CURRENT_PERIOD_START::DATE) AND date_cross.DATE_COLUMN <= DATEADD(DAY, 1, COALESCE(A_CURRENT_PERIOD_END::DATE,CURRENT_TIMESTAMP))
group by subs.K_CUSTOMER_DLHK,date_cross.date_column,subs.K_PLAN_DLHK

UNION ALL

select subs.K_CUSTOMER_DLHK,
  subs.K_PLAN_DLHK,
  'week' as interval,
   date_cross.DATE_COLUMN date_ref,
  count(case when (subs.A_CURRENT_PERIOD_END::DATE is NULL or subs.A_CURRENT_PERIOD_END::DATE >= last_day(date_cross.DATE_COLUMN,'week')) and subs.A_CURRENT_PERIOD_START::DATE < dateadd(week, 1, date_cross.DATE_COLUMN) then subs.K_SUBSCRIPTION_DLHK end) total_subscriptions  
FROM {{ref('W_STR_SUBSCRIPTION_F') }} subs
 CROSS JOIN
{{ref('W_STR_DATE_D')}} date_cross
 where date_cross.DATE_COLUMN >= DATEADD(DAY, -6, DATE_TRUNC('WEEK',A_CURRENT_PERIOD_START::DATE)) AND date_cross.DATE_COLUMN <= DATEADD(WEEK, 1, COALESCE(A_CURRENT_PERIOD_END::DATE,CURRENT_TIMESTAMP))
 AND date_cross.DAY_NUM_IN_WEEK = 1
group by subs.K_CUSTOMER_DLHK,date_cross.date_column,subs.K_PLAN_DLHK

UNION ALL

select subs.K_CUSTOMER_DLHK,
  subs.K_PLAN_DLHK,
  'month' as interval,
   date_cross.DATE_COLUMN date_ref,
  count(case when (subs.A_CURRENT_PERIOD_END::DATE is NULL or subs.A_CURRENT_PERIOD_END::DATE >= last_day(date_cross.DATE_COLUMN,'month')) and subs.A_CURRENT_PERIOD_START::DATE < dateadd(month, 1, date_cross.DATE_COLUMN) then subs.K_SUBSCRIPTION_DLHK end) total_subscriptions  
FROM {{ref('W_STR_SUBSCRIPTION_F') }} subs
 CROSS JOIN
{{ref('W_STR_DATE_D')}} date_cross
 where date_cross.DATE_COLUMN >= DATEADD(MONTH, -1, DATE_TRUNC('MONTH',A_CURRENT_PERIOD_START::DATE)) AND date_cross.DATE_COLUMN <= DATEADD(MONTH, 1, COALESCE(A_CURRENT_PERIOD_END::DATE,CURRENT_TIMESTAMP))
AND date_cross.DATE_COLUMN =  last_day(date_cross.DATE_COLUMN,'month') 
group by subs.K_CUSTOMER_DLHK,date_cross.date_column,subs.K_PLAN_DLHK