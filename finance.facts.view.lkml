
# include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

include: "/datablocks_finance/sf.finance.explore"

view: financial_data {
  derived_table: {
    persist_for: "100 hours"
    explore_source: sf_financial_indicators {
      column: indicator_date {}
      column: value {}
      column: dataset_code {}
      column: indicator_name { field: sf_indicators_metadata_codes.indicator_name }
      filters: {
        field: sf_financial_indicators.dataset_code
        value: "UNEMPLOY,CPIAUCSL"
      }
    }
  }

  dimension: primary_key {
    hidden: yes
    sql: concat(cast((${TABLE}.indicator_date) as string), ${dataset_code}) ;;
    primary_key: yes
  }

  dimension_group: indicator {
    type: time
    timeframes: [date, month, year]
    sql: cast(${TABLE}.indicator_date as timestamp) ;;
    convert_tz: no
  }

  dimension: value {}
  dimension: dataset_code {}
  dimension: indicator_name {}

  measure: value_at_start {
    label: "Value (Start Period)"
    type: min
    sql: ${TABLE}.value ;;
  }

  measure: value_at_end {
    label: "Value (End Period)"
    type: max
    sql: ${TABLE}.value ;;
  }

  measure: indicator_growth {
    label: "Growth (%)"
    type: percent_of_previous
    sql: ${value_at_start} ;;
    value_format_name: decimal_2
  }

#  measure: inflation_adjusted_value{
#    type: number
#    sql: ${order_items.total_revenue} * (${indicator_growth}/100) ;;
#    value_format_name: decimal_2
#  }
}
