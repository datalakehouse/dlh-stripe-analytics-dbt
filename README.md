# Doordash package

This dbt package:

*   Contains a DBT dimensional model based on Doordash for work data;
*   The main use of this package is to provide a stable snowflake dimensional model that will provide useful insights.
    

### Models

The primary ouputs of this package are fact and dimension tables as listed below. There are several intermediate models used to create these models.

|        Type       |        Model       |        Description       |
|:----------------:|:----------------:|----------------|
|Dimension| W_BUDGET_D       | To be imported as a seed csv file containing the budget applied for each budget_id   |
|Dimension| W_CURRENCIES_D         | Based on all currencies applied to any orders |
|Dimension| W_DELIVERY_ADDRESS_D       | Based on all delivery addresses ever used |
|Dimension| W_EMPLOYEESS_D      | Based on all employees with at least one order |
|Dimension| W_MERCHANTS_D         | Based on all merchants with at least one order |
|Dimension| W_TEAM_ACCOUNTS_D         | Team accounts that has at least one order |
|Fact| W_ORDERS_F | History of all orders |

</br>

</br>

![oi1UZGn.jpg](https://i.imgur.com/oi1UZGn.jpg)| 
|:--:| 
| *Data Lineage Graph* |

Installation Instructions
-------------------------

Check [dbt Hub](https://hub.getdbt.com) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your packages.yml

```yaml
packages:
  - package: datalakehouse/dlh-doordash-analytics-dbt
    version: [">=0.1.0"]
```

Configuration
-------------

By default, this package uses `DEVELOPER_SANDBOX` as the source database and `DOORDASH` as source_schema. If this is not the where your salesforce data is, change ther below [variables](https://docs.getdbt.com/docs/using-variables) configuration on your `dbt_project.yml`:


```yaml
# dbt_project.yml

...

vars:    
    include_third_party_data_weather__weathersource: true
    source_database: DEVELOPER_SANDBOX
    target_schema: DOORDASH
    source_schema: TEST_SCHEMA_EXT_DEV
    source_weather_database: WEATHERSOURCE_TILE_SAMPLE_SNOWFLAKE_SECURE_SHARE_1622060371935
    source_weather_schema: STANDARD_TILE
```

Also, this project uses [Weather data ](https://www.snowflake.com/datasets/weather-source-llc-global-weather-climate-data-for-bi/)from Snowflake's marketplace to provide some insights about the weather conditions for each Doordash's order. If you're interested in this data, [pull weather marketplace data into your snowflake environment ](https://www.snowflake.com/datasets/weather-source-llc-global-weather-climate-data-for-bi/) and change the variables`source_weather_database` and `source_weather_database`above, pointing to your database and schema where the weather data is present.
If you're not interest in weather data, just change the `include_third_party_data_weather__weathersource` to false. 

Also, you may want have on your W_ORDERS_F the information if that order was below or above the budget. So, you will need to pull a CSV file with the budget configured for your company. There's a sample of that CSV file into /data folder. Replace the sample CSV file with your budget information.

![AUlsWqQ.png](https://i.imgur.com/AUlsWqQ.png)
BUDGET_ID = Id of the budget configured on Doordash for Work. All budget_ids can be found on `V_BUDGET_STG`.

### Database support

Core:

*   Snowflake
    

### Contributions

Additional contributions to this package are very welcome! Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.


*   Fork and :star: this repository :)
*   Check it out and :star: [the datalakehouse core repository](https://github.com/datalakehouse/datalakehouse-core);


