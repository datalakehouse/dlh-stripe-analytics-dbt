{{ config (
  materialized= 'table',
  schema= var('target_schema','STRIPE'),
  tags= ["staging", "daily"],
  transient=false
)
}}

select 
  MD5(CONCAT(COALESCE(subs.K_CUSTOMER_DLHK,'00000'),'-',COALESCE(subs.K_PLAN_DLHK,'00000'),date_cross.K_DATE_BK)) K_SUBSCRIPTION_BY_PLAN_DLHK,
  subs.K_CUSTOMER_DLHK,
  subs.K_PLAN_DLHK,
  'day' as A_INTERVAL,
   date_cross.K_DATE_BK A_DATE_REF,
  count(case when (subs.A_CURRENT_PERIOD_END::DATE is NULL or subs.A_CURRENT_PERIOD_END::DATE >= DATEADD(day,1, date_cross.K_DATE_BK)) and subs.A_CURRENT_PERIOD_START::DATE < dateadd(day, 1, date_cross.K_DATE_BK) then subs.K_SUBSCRIPTION_DLHK end) M_TOTAL_SUBSCRIPTIONS  
FROM {{ref('W_STR_SUBSCRIPTION_F') }} subs
 CROSS JOIN
 {{ref('W_STR_DATE_D')}} date_cross
 where date_cross.K_DATE_BK >= DATEADD(DAY, -1, A_CURRENT_PERIOD_START::DATE) AND date_cross.K_DATE_BK <= DATEADD(DAY, 1, COALESCE(A_CURRENT_PERIOD_END::DATE,CURRENT_DATE))
group by subs.K_CUSTOMER_DLHK,date_cross.K_DATE_BK,subs.K_PLAN_DLHK

UNION ALL

select 
  MD5(CONCAT(COALESCE(subs.K_CUSTOMER_DLHK,'00000'),'-',COALESCE(subs.K_PLAN_DLHK,'00000'),date_cross.K_DATE_BK)) K_SUBSCRIPTION_BY_PLAN_DLHK,
  subs.K_CUSTOMER_DLHK,
  subs.K_PLAN_DLHK,
  'week' as A_INTERVAL,
   date_cross.K_DATE_BK A_DATE_REF,
  count(case when (subs.A_CURRENT_PERIOD_END::DATE is NULL or subs.A_CURRENT_PERIOD_END::DATE >= last_day(date_cross.K_DATE_BK,'week')) and subs.A_CURRENT_PERIOD_START::DATE < dateadd(week, 1, date_cross.K_DATE_BK) then subs.K_SUBSCRIPTION_DLHK end) M_TOTAL_SUBSCRIPTIONS  
FROM {{ref('W_STR_SUBSCRIPTION_F') }} subs
 CROSS JOIN
{{ref('W_STR_DATE_D')}} date_cross
 where date_cross.K_DATE_BK >= DATEADD(DAY, -6, DATE_TRUNC('WEEK',A_CURRENT_PERIOD_START::DATE)) AND date_cross.K_DATE_BK <= DATEADD(WEEK, 1, COALESCE(A_CURRENT_PERIOD_END::DATE,CURRENT_DATE))
 AND date_cross.A_DAY_NUM_IN_WEEK = 1
group by subs.K_CUSTOMER_DLHK,date_cross.K_DATE_BK,subs.K_PLAN_DLHK

UNION ALL

select 
  MD5(CONCAT(COALESCE(subs.K_CUSTOMER_DLHK,'00000'),'-',COALESCE(subs.K_PLAN_DLHK,'00000'),date_cross.K_DATE_BK)) K_SUBSCRIPTION_BY_PLAN_DLHK,
  subs.K_CUSTOMER_DLHK,
  subs.K_PLAN_DLHK,
  'month' as A_INTERVAL,
   date_cross.K_DATE_BK A_DATE_REF,
  count(case when (subs.A_CURRENT_PERIOD_END::DATE is NULL or subs.A_CURRENT_PERIOD_END::DATE >= last_day(date_cross.K_DATE_BK,'month')) and subs.A_CURRENT_PERIOD_START::DATE < dateadd(month, 1, date_cross.K_DATE_BK) then subs.K_SUBSCRIPTION_DLHK end) M_TOTAL_SUBSCRIPTIONS  
FROM {{ref('W_STR_SUBSCRIPTION_F') }} subs
 CROSS JOIN
{{ref('W_STR_DATE_D')}} date_cross
 where date_cross.K_DATE_BK >= DATEADD(MONTH, -1, DATE_TRUNC('MONTH',A_CURRENT_PERIOD_START::DATE)) AND date_cross.K_DATE_BK <= DATEADD(MONTH, 1, COALESCE(A_CURRENT_PERIOD_END::DATE,CURRENT_DATE))
AND date_cross.K_DATE_BK =  last_day(date_cross.K_DATE_BK,'month') 
group by subs.K_CUSTOMER_DLHK,date_cross.K_DATE_BK,subs.K_PLAN_DLHK