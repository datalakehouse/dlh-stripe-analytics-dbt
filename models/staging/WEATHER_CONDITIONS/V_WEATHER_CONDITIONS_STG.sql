 {{ config(
    materialized='view',
    enabled=var('include_third_party_data_weather__weathersource')
) }}

SELECT    
    MD5(TRIM(COUNTRY)||'-'||TRIM(POSTAL_CODE)||'-'||DATE_VALID_STD) AS K_WEATHER_DLHK
    ,COUNTRY AS A_COUNTRY
    ,POSTAL_CODE AS A_POSTAL_CODE    
    ,AVG_HUMIDITY_RELATIVE_2M_PCT AS M_AVG_HUMIDITY_RELATIVE_2M_PCT
    ,AVG_HUMIDITY_SPECIFIC_2M_GPKG AS M_AVG_HUMIDITY_SPECIFIC_2M_GPKG
    ,DATE_VALID_STD AS A_DATE_VALID_STD
    ,MAX_HUMIDITY_RELATIVE_2M_PCT AS M_MAX_HUMIDITY_RELATIVE_2M_PCT
    ,MAX_HUMIDITY_SPECIFIC_2M_GPKG AS M_MAX_HUMIDITY_SPECIFIC_2M_GPKG
    ,MIN_HUMIDITY_RELATIVE_2M_PCT AS M_MIN_HUMIDITY_RELATIVE_2M_PCT
    ,MIN_HUMIDITY_SPECIFIC_2M_GPKG AS M_MIN_HUMIDITY_SPECIFIC_2M_GPKG
    ,AVG_CLOUD_COVER_TOT_PCT AS M_AVG_CLOUD_COVER_TOT_PCT
    ,AVG_PRESSURE_2M_MB AS M_AVG_PRESSURE_2M_MB
    ,AVG_PRESSURE_MEAN_SEA_LEVEL_MB AS M_AVG_PRESSURE_MEAN_SEA_LEVEL_MB
    ,AVG_PRESSURE_TENDENCY_2M_MB AS M_AVG_PRESSURE_TENDENCY_2M_MB
    ,AVG_RADIATION_SOLAR_TOTAL_WPM2 AS M_AVG_RADIATION_SOLAR_TOTAL_WPM2
    ,AVG_TEMPERATURE_AIR_2M_F AS M_AVG_TEMPERATURE_AIR_2M_F
    ,AVG_TEMPERATURE_DEWPOINT_2M_F AS M_AVG_TEMPERATURE_DEWPOINT_2M_F
    ,AVG_TEMPERATURE_FEELSLIKE_2M_F AS M_AVG_TEMPERATURE_FEELSLIKE_2M_F
    ,AVG_TEMPERATURE_HEATINDEX_2M_F AS M_AVG_TEMPERATURE_HEATINDEX_2M_F
    ,AVG_TEMPERATURE_WETBULB_2M_F AS M_AVG_TEMPERATURE_WETBULB_2M_F
    ,AVG_TEMPERATURE_WINDCHILL_2M_F AS M_AVG_TEMPERATURE_WINDCHILL_2M_F
    ,AVG_WIND_DIRECTION_100M_DEG AS M_AVG_WIND_DIRECTION_100M_DEG
    ,AVG_WIND_DIRECTION_10M_DEG AS M_AVG_WIND_DIRECTION_10M_DEG
    ,AVG_WIND_DIRECTION_80M_DEG AS M_AVG_WIND_DIRECTION_80M_DEG
    ,AVG_WIND_SPEED_100M_MPH AS M_AVG_WIND_SPEED_100M_MPH
    ,AVG_WIND_SPEED_10M_MPH AS M_AVG_WIND_SPEED_10M_MPH
    ,AVG_WIND_SPEED_80M_MPH AS M_AVG_WIND_SPEED_80M_MPH
    ,DOY_STD AS M_DOY_STD
    ,MAX_CLOUD_COVER_TOT_PCT AS M_MAX_CLOUD_COVER_TOT_PCT
    ,MAX_PRESSURE_2M_MB AS M_MAX_PRESSURE_2M_MB
    ,MAX_PRESSURE_MEAN_SEA_LEVEL_MB AS M_MAX_PRESSURE_MEAN_SEA_LEVEL_MB
    ,MAX_PRESSURE_TENDENCY_2M_MB AS M_MAX_PRESSURE_TENDENCY_2M_MB
    ,MAX_RADIATION_SOLAR_TOTAL_WPM2 AS M_MAX_RADIATION_SOLAR_TOTAL_WPM2
    ,MAX_TEMPERATURE_AIR_2M_F AS M_MAX_TEMPERATURE_AIR_2M_F
    ,MAX_TEMPERATURE_DEWPOINT_2M_F AS M_MAX_TEMPERATURE_DEWPOINT_2M_F
    ,MAX_TEMPERATURE_FEELSLIKE_2M_F AS M_MAX_TEMPERATURE_FEELSLIKE_2M_F
    ,MAX_TEMPERATURE_HEATINDEX_2M_F AS M_MAX_TEMPERATURE_HEATINDEX_2M_F
    ,MAX_TEMPERATURE_WETBULB_2M_F AS M_MAX_TEMPERATURE_WETBULB_2M_F
    ,MAX_TEMPERATURE_WINDCHILL_2M_F AS M_MAX_TEMPERATURE_WINDCHILL_2M_F
    ,MAX_WIND_SPEED_100M_MPH AS M_MAX_WIND_SPEED_100M_MPH
    ,MAX_WIND_SPEED_10M_MPH AS M_MAX_WIND_SPEED_10M_MPH
    ,MAX_WIND_SPEED_80M_MPH AS M_MAX_WIND_SPEED_80M_MPH
    ,MIN_CLOUD_COVER_TOT_PCT AS M_MIN_CLOUD_COVER_TOT_PCT
    ,MIN_PRESSURE_2M_MB AS M_MIN_PRESSURE_2M_MB
    ,MIN_PRESSURE_MEAN_SEA_LEVEL_MB AS M_MIN_PRESSURE_MEAN_SEA_LEVEL_MB
    ,MIN_PRESSURE_TENDENCY_2M_MB AS M_MIN_PRESSURE_TENDENCY_2M_MB
    ,MIN_RADIATION_SOLAR_TOTAL_WPM2 AS M_MIN_RADIATION_SOLAR_TOTAL_WPM2
    ,MIN_TEMPERATURE_AIR_2M_F AS M_MIN_TEMPERATURE_AIR_2M_F
    ,MIN_TEMPERATURE_DEWPOINT_2M_F AS M_MIN_TEMPERATURE_DEWPOINT_2M_F
    ,MIN_TEMPERATURE_FEELSLIKE_2M_F AS M_MIN_TEMPERATURE_FEELSLIKE_2M_F
    ,MIN_TEMPERATURE_HEATINDEX_2M_F AS M_MIN_TEMPERATURE_HEATINDEX_2M_F
    ,MIN_TEMPERATURE_WETBULB_2M_F AS M_MIN_TEMPERATURE_WETBULB_2M_F
    ,MIN_TEMPERATURE_WINDCHILL_2M_F AS M_MIN_TEMPERATURE_WINDCHILL_2M_F
    ,MIN_WIND_SPEED_100M_MPH AS M_MIN_WIND_SPEED_100M_MPH
    ,MIN_WIND_SPEED_10M_MPH AS M_MIN_WIND_SPEED_10M_MPH
    ,MIN_WIND_SPEED_80M_MPH AS M_MIN_WIND_SPEED_80M_MPH
    ,TOT_PRECIPITATION_IN AS M_TOT_PRECIPITATION_IN
    ,TOT_RADIATION_SOLAR_TOTAL_WPM2 AS M_TOT_RADIATION_SOLAR_TOTAL_WPM2
    ,TOT_SNOWDEPTH_IN AS M_TOT_SNOWDEPTH_IN
    ,TOT_SNOWFALL_IN AS M_TOT_SNOWFALL_IN
    ,CASE 
        WHEN TOT_SNOWDEPTH_IN > 0 OR TOT_SNOWFALL_IN >0 THEN 'SNOWY'
        WHEN TOT_PRECIPITATION_IN > 0 'RAINY'
FROM
    {{source('WEATHER_SOURCE','HISTORY_DAY')}}