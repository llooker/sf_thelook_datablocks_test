view: inventory_items {
  sql_table_name: THELOOK.PUBLIC.INVENTORY_ITEMS ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.COST ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.PRODUCT_ID ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.SOLD_AT ;;
  }

  measure: count {
    type: count
    drill_fields: [id, products.id, products.item_name, order_items.count]
  }
}
