include: "/datablocks_acs/sf.explore*"


view: zipcode_income_facts {
  derived_table: {
    persist_for: "10000 hours"
    explore_source: fast_facts {
      column: ZCTA5 { field: tract_zcta_map.ZCTA5 }
      column: income_household { field: block_group_facts.avg_income_house }
      column: total_population { field: block_group_facts.total_population }
    }
  }
  dimension: ZCTA5 {}
  dimension: income_household {
    hidden: yes
  }
  dimension: income_tier {
    type: tier
    style: integer
    sql: ${income_household} ;;
    tiers: [25000,50000,75000,100000, 150000,250000]
    value_format: "$#,##0"
  }
  measure: total_population {
    type: sum
    sql: ${TABLE}.total_population ;;
  }

  measure: average_income_per_household {
    type: average
    sql: ${income_household};;
  }
}
