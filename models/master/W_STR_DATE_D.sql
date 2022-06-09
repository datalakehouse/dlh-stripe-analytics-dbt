{{ config (
  materialized= 'table',
  schema= var('target_schema'),
  tags= ["staging", "daily"],
  transient=false
)
}}

SELECT 
	CAST(DATE_KEY AS NUMBER(9)) AS K_DATE_INTEGER_BK
	,CAST(DATE_COLUMN AS DATE) AS K_DATE_BK
	,CAST(FULL_DATE_DESC AS VARCHAR(64)) AS A_FULL_DATE_DESC
	,CAST(DAY_NUM_IN_WEEK AS NUMBER(1)) AS A_DAY_NUM_IN_WEEK
	,CAST(DAY_NUM_IN_MONTH AS NUMBER(2)) AS A_DAY_NUM_IN_MONTH
	,CAST(DAY_NUM_IN_YEAR AS NUMBER(3)) AS A_DAY_NUM_IN_YEAR
	,CAST(DAY_NAME AS VARCHAR(10)) AS A_DAY_NAME
	,CAST(DAY_ABBREV AS VARCHAR(3)) AS A_DAY_ABBREV
	,CAST(WEEKDAY_IND AS VARCHAR(64)) AS A_WEEKDAY_IND
	,CAST(US_HOLIDAY_IND AS VARCHAR(64)) AS A_US_HOLIDAY_IND
	,CAST(COMPANY_HOLIDAY_IND AS VARCHAR(64)) AS A_COMPANY_HOLIDAY_IND
	,CAST(MONTH_END_IND AS VARCHAR(64)) AS A_MONTH_END_IND
	,CAST(WEEK_BEGIN_DATE_NKEY AS NUMBER(9)) AS A_WEEK_BEGIN_DATE_NKEY
	,CAST(WEEK_BEGIN_DATE AS DATE) AS A_WEEK_BEGIN_DATE
	,CAST(WEEK_END_DATE_NKEY AS NUMBER(9)) AS A_WEEK_END_DATE_NKEY
	,CAST(WEEK_END_DATE AS DATE) AS A_WEEK_END_DATE
	,CAST(WEEK_NUM_IN_YEAR AS NUMBER(9)) AS A_WEEK_NUM_IN_YEAR
	,CAST(MONTH_NAME AS VARCHAR(10)) AS A_MONTH_NAME
	,CAST(MONTH_ABBREV AS VARCHAR(3)) AS A_MONTH_ABBREV
	,CAST(MONTH_NUM_IN_YEAR AS NUMBER(2)) AS A_MONTH_NUM_IN_YEAR
	,CAST(YEARMONTH AS VARCHAR(10)) AS A_YEARMONTH
	,CAST(CURRENT_QUARTER AS NUMBER(1)) AS A_QUARTER
	,CAST(YEARQUARTER AS VARCHAR(10)) AS A_YEARQUARTER
	,CAST(CURRENT_YEAR AS NUMBER(5)) AS A_YEAR
	,CAST(FISCAL_WEEK_NUM AS NUMBER(2)) AS A_FISCAL_WEEK_NUM
	,CAST(FISCAL_MONTH_NUM AS NUMBER(2)) AS A_FISCAL_MONTH_NUM
	,CAST(FISCAL_YEARMONTH AS VARCHAR(10)) AS A_FISCAL_YEARMONTH
	,CAST(FISCAL_QUARTER AS NUMBER(1)) AS A_FISCAL_QUARTER
	,CAST(FISCAL_YEARQUARTER AS VARCHAR(10)) AS A_FISCAL_YEARQUARTER
	,CAST(FISCAL_HALFYEAR AS NUMBER(1)) AS A_FISCAL_HALFYEAR
	,CAST(FISCAL_YEAR AS NUMBER(5)) AS A_FISCAL_YEAR
	,CAST(SQL_TIMESTAMP AS TIMESTAMP_NTZ) AS A_SQL_TIMESTAMP_DTS
	,CAST(CURRENT_ROW_IND AS CHAR(1)) AS A_CURRENT_ROW_IND
	,CAST(EFFECTIVE_DATE AS DATE) AS A_EFFECTIVE_DATE
	,CAST(EXPIRA_DATE AS DATE) AS A_EXPIRATION_DATE
FROM
  {{ref('V_STR_DATE_STG')}} AS C


  