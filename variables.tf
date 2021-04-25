variable "my_crazy_var" {
  description = "This is a list[] of maps {}. Recall, a list is indexed by [INT], and maps can use lookup() to find a KEY=VALUE."
  default = [
    { name   = "January",
      number = 1
    },
    {
      name   = "February",
      number = 2
    },
    {
      name   = "March",
      number = 3
    }
  ]
}

variable "holiday_dates" {
  default = {
    "christmas"       = "Dec. 25"
    "eid-al-fitr"     = "May 13"
    "st-patricks-day" = "March 17"
  }
}

variable "holidays" {
  default = {
    christmas       = { date = "Dec. 25", season = "winter" }
    eid-al-fitr     = { date = "May 13", season = "spring" }
    st-patricks-day = { date = "March 17", season = "spring" }
  }
}

variable "holidays2" {
  default = [
    { name = "Christmas", date = "Dec. 25", season = "winter" },
    { name = "Eid al-Fitr", date = "May 13", season = "spring" },
    { name = "St. Patrick's Day", date = "March 17", season = "spring" }
  ]
}