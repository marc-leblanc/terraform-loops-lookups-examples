output "Show-one-list-element" {
  value = var.my_crazy_var[1]
}

output "Find-month-number-for-March" {
  value = [for x in var.my_crazy_var : x.number if x.name == "March"].0
}

output "Find-Holiday-Date" {
  value = lookup(var.holiday_dates, "christmas")
}

output "Find-Holiday-season" {
  value = lookup(var.holidays, "eid-al-fitr").season
}

output "Find-spring-holidays"{
    value = [for x in var.holidays2: x.name if x.season == "spring"]
}