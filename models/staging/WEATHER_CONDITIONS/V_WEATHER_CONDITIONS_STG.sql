 {{ config(
    materialized='view',
    schema='DOORDASH',
    enabled=var('include_third_party_data_weather__weathersource')
) }}

SELECT    
    MD5(TRIM(C.A_ALPHA3_COUNTRY_CODE)||'-'||TRIM(H.POSTAL_CODE)||'-'||H.DATE_VALID_STD) AS K_WEATHER_DLHK
    ,H.COUNTRY AS A_COUNTRY
    ,H.POSTAL_CODE AS A_POSTAL_CODE    
    ,H.AVG_HUMIDITY_RELATIVE_2M_PCT AS M_AVG_HUMIDITY_RELATIVE_2M_PCT
    ,H.AVG_HUMIDITY_SPECIFIC_2M_GPKG AS M_AVG_HUMIDITY_SPECIFIC_2M_GPKG
    ,H.DATE_VALID_STD AS A_DATE_VALID_STD
    ,H.MAX_HUMIDITY_RELATIVE_2M_PCT AS M_MAX_HUMIDITY_RELATIVE_2M_PCT
    ,H.MAX_HUMIDITY_SPECIFIC_2M_GPKG AS M_MAX_HUMIDITY_SPECIFIC_2M_GPKG
    ,H.MIN_HUMIDITY_RELATIVE_2M_PCT AS M_MIN_HUMIDITY_RELATIVE_2M_PCT
    ,H.MIN_HUMIDITY_SPECIFIC_2M_GPKG AS M_MIN_HUMIDITY_SPECIFIC_2M_GPKG
    ,H.AVG_CLOUD_COVER_TOT_PCT AS M_AVG_CLOUD_COVER_TOT_PCT
    ,H.AVG_PRESSURE_2M_MB AS M_AVG_PRESSURE_2M_MB
    ,H.AVG_PRESSURE_MEAN_SEA_LEVEL_MB AS M_AVG_PRESSURE_MEAN_SEA_LEVEL_MB
    ,H.AVG_PRESSURE_TENDENCY_2M_MB AS M_AVG_PRESSURE_TENDENCY_2M_MB
    ,H.AVG_RADIATION_SOLAR_TOTAL_WPM2 AS M_AVG_RADIATION_SOLAR_TOTAL_WPM2
    ,H.AVG_TEMPERATURE_AIR_2M_F AS M_AVG_TEMPERATURE_AIR_2M_F
    ,H.AVG_TEMPERATURE_DEWPOINT_2M_F AS M_AVG_TEMPERATURE_DEWPOINT_2M_F
    ,H.AVG_TEMPERATURE_FEELSLIKE_2M_F AS M_AVG_TEMPERATURE_FEELSLIKE_2M_F
    ,H.AVG_TEMPERATURE_HEATINDEX_2M_F AS M_AVG_TEMPERATURE_HEATINDEX_2M_F
    ,H.AVG_TEMPERATURE_WETBULB_2M_F AS M_AVG_TEMPERATURE_WETBULB_2M_F
    ,H.AVG_TEMPERATURE_WINDCHILL_2M_F AS M_AVG_TEMPERATURE_WINDCHILL_2M_F
    ,H.AVG_WIND_DIRECTION_100M_DEG AS M_AVG_WIND_DIRECTION_100M_DEG
    ,H.AVG_WIND_DIRECTION_10M_DEG AS M_AVG_WIND_DIRECTION_10M_DEG
    ,H.AVG_WIND_DIRECTION_80M_DEG AS M_AVG_WIND_DIRECTION_80M_DEG
    ,H.AVG_WIND_SPEED_100M_MPH AS M_AVG_WIND_SPEED_100M_MPH
    ,H.AVG_WIND_SPEED_10M_MPH AS M_AVG_WIND_SPEED_10M_MPH
    ,H.AVG_WIND_SPEED_80M_MPH AS M_AVG_WIND_SPEED_80M_MPH
    ,H.DOY_STD AS M_DOY_STD
    ,H.MAX_CLOUD_COVER_TOT_PCT AS M_MAX_CLOUD_COVER_TOT_PCT
    ,H.MAX_PRESSURE_2M_MB AS M_MAX_PRESSURE_2M_MB
    ,H.MAX_PRESSURE_MEAN_SEA_LEVEL_MB AS M_MAX_PRESSURE_MEAN_SEA_LEVEL_MB
    ,H.MAX_PRESSURE_TENDENCY_2M_MB AS M_MAX_PRESSURE_TENDENCY_2M_MB
    ,H.MAX_RADIATION_SOLAR_TOTAL_WPM2 AS M_MAX_RADIATION_SOLAR_TOTAL_WPM2
    ,H.MAX_TEMPERATURE_AIR_2M_F AS M_MAX_TEMPERATURE_AIR_2M_F
    ,H.MAX_TEMPERATURE_DEWPOINT_2M_F AS M_MAX_TEMPERATURE_DEWPOINT_2M_F
    ,H.MAX_TEMPERATURE_FEELSLIKE_2M_F AS M_MAX_TEMPERATURE_FEELSLIKE_2M_F
    ,H.MAX_TEMPERATURE_HEATINDEX_2M_F AS M_MAX_TEMPERATURE_HEATINDEX_2M_F
    ,H.MAX_TEMPERATURE_WETBULB_2M_F AS M_MAX_TEMPERATURE_WETBULB_2M_F
    ,H.MAX_TEMPERATURE_WINDCHILL_2M_F AS M_MAX_TEMPERATURE_WINDCHILL_2M_F
    ,H.MAX_WIND_SPEED_100M_MPH AS M_MAX_WIND_SPEED_100M_MPH
    ,H.MAX_WIND_SPEED_10M_MPH AS M_MAX_WIND_SPEED_10M_MPH
    ,H.MAX_WIND_SPEED_80M_MPH AS M_MAX_WIND_SPEED_80M_MPH
    ,H.MIN_CLOUD_COVER_TOT_PCT AS M_MIN_CLOUD_COVER_TOT_PCT
    ,H.MIN_PRESSURE_2M_MB AS M_MIN_PRESSURE_2M_MB
    ,H.MIN_PRESSURE_MEAN_SEA_LEVEL_MB AS M_MIN_PRESSURE_MEAN_SEA_LEVEL_MB
    ,H.MIN_PRESSURE_TENDENCY_2M_MB AS M_MIN_PRESSURE_TENDENCY_2M_MB
    ,H.MIN_RADIATION_SOLAR_TOTAL_WPM2 AS M_MIN_RADIATION_SOLAR_TOTAL_WPM2
    ,H.MIN_TEMPERATURE_AIR_2M_F AS M_MIN_TEMPERATURE_AIR_2M_F
    ,H.MIN_TEMPERATURE_DEWPOINT_2M_F AS M_MIN_TEMPERATURE_DEWPOINT_2M_F
    ,H.MIN_TEMPERATURE_FEELSLIKE_2M_F AS M_MIN_TEMPERATURE_FEELSLIKE_2M_F
    ,H.MIN_TEMPERATURE_HEATINDEX_2M_F AS M_MIN_TEMPERATURE_HEATINDEX_2M_F
    ,H.MIN_TEMPERATURE_WETBULB_2M_F AS M_MIN_TEMPERATURE_WETBULB_2M_F
    ,H.MIN_TEMPERATURE_WINDCHILL_2M_F AS M_MIN_TEMPERATURE_WINDCHILL_2M_F
    ,H.MIN_WIND_SPEED_100M_MPH AS M_MIN_WIND_SPEED_100M_MPH
    ,H.MIN_WIND_SPEED_10M_MPH AS M_MIN_WIND_SPEED_10M_MPH
    ,H.MIN_WIND_SPEED_80M_MPH AS M_MIN_WIND_SPEED_80M_MPH
    ,H.TOT_PRECIPITATION_IN AS M_TOT_PRECIPITATION_IN
    ,H.TOT_RADIATION_SOLAR_TOTAL_WPM2 AS M_TOT_RADIATION_SOLAR_TOTAL_WPM2
    ,H.TOT_SNOWDEPTH_IN AS M_TOT_SNOWDEPTH_IN
    ,H.TOT_SNOWFALL_IN AS M_TOT_SNOWFALL_IN
    ,CASE 
        WHEN H.TOT_SNOWDEPTH_IN > 0 OR TOT_SNOWFALL_IN >0 THEN 'SNOWY'
        WHEN H.TOT_PRECIPITATION_IN > 0 THEN 'RAINY' 
        WHEN H.AVG_CLOUD_COVER_TOT_PCT >= 60 AND H.TOT_PRECIPITATION_IN=0 AND H.TOT_SNOWDEPTH_IN = 0 AND H.TOT_SNOWFALL_IN =0    THEN 'CLOUDY'        
        else 'CLEAR'
    END AS A_WEATHER_CONDITION_SUMMARY
    ,CASE 
        WHEN H.AVG_TEMPERATURE_AIR_2M_F <= 32 THEN 'UNDER 32 F'
        WHEN H.AVG_TEMPERATURE_AIR_2M_F BETWEEN 32 AND 50 THEN '32 to 50 F'  
        WHEN H.AVG_TEMPERATURE_AIR_2M_F BETWEEN 50 AND 68  THEN '50 to 68 F'
        WHEN H.AVG_TEMPERATURE_AIR_2M_F >= 68 THEN 'ABOVE 68 F'
    END AS A_AVG_TEMPERATURE_SUMMARY
    , '{{invocation_id}}' as MD_INTGR_ID
    , CURRENT_TIMESTAMP() MD_ELT_UPDATED_DTS
FROM
    {{source(var('source_weather_schema'),'HISTORY_DAY')}} H
LEFT JOIN {{ ref('V_COUNTRY_CODES_STG') }} C ON C.A_ALPHA2_COUNTRY_CODE = H.COUNTRY