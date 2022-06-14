# Stripe package

This dbt package:

*   Contains a DBT dimensional model based on Stripe data from [Datalakehouse’s](https://www.datalakehouse.io/) connector.
*   The main use of this package is to provide a stable snowflake dimensional model that will provide useful insights.
    

### Models

The primary ouputs of this package are fact and dimension tables as listed below. There are several intermediate models used to create these models.

|        Type       |        Model       |        Description       |
|:----------------:|:----------------:|----------------|
|Fact| W_STR_BALANCE_TRANSACTION_F       | Balance transactions represent funds moving through your Stripe account. They're created for every type of transaction that comes into or flows out of your Stripe account balance.   |
|Fact| W_STR_CREDIT_NOTES_F         | Issue a credit note to adjust an invoice's amount after the invoice is finalized. |
|Fact| W_STR_INVOICES_F       | Invoices are statements of amounts owed by a customer, and are either generated one-off, or generated periodically from a subscription. |
|Fact| W_STR_SUBSCRIPTION_F      | Subscriptions allow you to charge a customer on a recurring basis. |
|Fact| W_STR_SUBSCRIPTION_BY_PLAN_F         | Reporting table with daily, weekly and monthly timeframe for active subscriptions by plan over period. |
|Dimension| W_STR_CUSTOMERS_D         | Represents a customer of your business. It lets you create recurring charges and track payments that belong to the same customer. |
|Dimension| W_STR_DATE_D | Date dimension |
|Dimension| W_STR_PAYMENT_METHOD_D | Represent your customer's payment instruments. |
|Dimension| W_STR_PLAN_D | Plans define the base price, currency, and billing cycle for recurring purchases of products. |

</br>

![3vJH8CW.png](https://i.imgur.com/3vJH8CW.png)
|:--:| 
| *Data Lineage Graph* |

Installation Instructions
-------------------------

Check [dbt Hub](https://hub.getdbt.com) for the latest installation instructions, or [read the docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your packages.yml

```yaml
packages:
  - package: datalakehouse/dlh_stripe
    version: [">=0.1.0"]
```

Configuration
-------------


By default, this package uses `DEVELOPER_SANDBOX` as the source database name and `DEMO_STRIPE_NEW` as schema name. If this is not the where your salesforce data is, add the below [variables](https://docs.getdbt.com/docs/using-variables) to your `dbt_project.yml`:


```yaml
# dbt_project.yml

...

vars:    
    source_database: DEVELOPER_SANDBOX
    target_schema: STRIPE
    source_schema: DEMO_STRIPE_NEW
```

### Database support

Core:

*   Snowflake
    

### Contributions

Additional contributions to this package are very welcome! Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.


*   Fork and :star: this repository :)
*   Check it out and :star: [the datalakehouse core repository](https://github.com/datalakehouse/datalakehouse-core);
