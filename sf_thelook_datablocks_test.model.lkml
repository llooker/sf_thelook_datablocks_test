connection: "snowflake-datablocks"

include: "ecomm*.view"
include: "finance*.view"
include: "acs*.view"
include: "exchangerate*.view"

include: "/datablocks_exchangerate/sf.explore*"

# explore: zipcode_income_facts {}

# explore: financial_data {}

explore: order_items {
  join: orders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${orders.id} = ${order_items.order_id} ;;
  }

  join: users {
    sql_on: ${users.id} = ${orders.user_id} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: zipcode_income_facts {
    sql_on: ${users.zip} = ${zipcode_income_facts.ZCTA5} ;;
    type: left_outer
    relationship: many_to_one
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
#   join: weather_facts_month {
#     relationship: many_to_one
#     sql_on: ${users.zip} = ${weather_facts_month.zip_code}
#     and ${order_items.created_month} = ${weather_facts_month.date_month};;
#   }
  join: inflation {
    from: financial_data
    sql_on:
     cast(${orders.created_month} as string) =  cast(${inflation.indicator_month} as string)
      and ${inflation.dataset_code} = 'CPIAUCSL'
    ;;
    type: left_outer
    relationship: many_to_one
  }

  join: unemployment {
    from: financial_data
    sql_on:
     cast(${orders.created_month} as string) =  cast(${unemployment.indicator_month} as string)
      and ${unemployment.dataset_code} = 'UNEMPLOY'
    ;;
    type: left_outer
    relationship: many_to_one
  }

  join: sf_forex_historical_real{
    sql_on: ${orders.created_date} = ${sf_forex_historical_real.forex_exchange_date} ;;
    type: left_outer
    relationship: many_to_one

  }
}
