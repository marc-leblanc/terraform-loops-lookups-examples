# Examples of working with Terraform collections

This repo provides some examples of extracting information from terraform [collections](https://www.terraform.io/docs/language/expressions/type-constraints.html#collection-types). Far from comprehensive, but hopefully this is beneficial to someone! 

## Use Cases

Why does this exist? In my case, I wanted to solve how I could extract VPC information from a terraform module used to create GCP VPC networks. The output I had was a complex map of lists and additional maps. I wanted my Terraform to be able to find out information on the provisioned VPC's based on limited variable definitions. For example, I wanted Terraform building a production GKE cluster, to *find* information on the GKE VPC based on variables like `env=PROD` and `envtype=GKE`.

There are likely other ways to achieve some of this, possibly even better ways, but these are the ways I am showing you for now.

So here we go.
## Examples

### Example 1: Find value in a list of maps

The strategy here is to iterate over the list, and evaluate based on each list element.

Consider

```terraform
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
```

There is a list `[0,1,2]` of maps `{ name, number}`. 

If you wanted to print the `number` of a specific month `name`, you could use this approach. The `for x` will iterate over each element in the list[] allowing you to compare the key values of the map. 

```terraform
output "Find-month-number-for-March" {
  value = [for x in var.my_crazy_var : x.number if x.name == "March"].0
}
```
Notice we tagged `.0` to the end. Doing this will provide `value` with a singular result instead of a tuple, which you will see further down in Example 4.

### Example 2: Lookup within a Map

This one is more straight forward, but here's an example of it in action. If you have a map, you may want to extract a value for you a specific key. 

```terraform
variable "holiday_dates" {
  default = {
    "christmas"       = "Dec. 25"
    "eid-al-fitr"     = "May 13"
    "st-patricks-day" = "March 17"
  }
}
```

This is solved using the [lookup function](https://www.terraform.io/docs/language/functions/lookup.html).

```terraform
output "Find-Holiday-Date" {
  value = lookup(var.holiday_dates, "christmas")
}
```

### Example 3: Find a value for a key from a map nested in a map

Consider we had a more complex structure and we wanted a specific value for a key buried in a parent map. In this case, we'll try to print the season in which [Eid al-Fitr occurs in for 2021](https://www.google.com/search?q=eid+al-fitr+2021&oq=Eid+al-Fitr+2021&aqs=chrome.0.0l10.1509j0j7&sourceid=chrome&ie=UTF-8)

```terraform
variable "holidays" {
  default = {
    christmas       = { date = "Dec. 25", season = "winter" }
    eid-al-fitr     = { date = "May 13", season = "spring" }
    st-patricks-day = { date = "March 17", season = "spring" }
  }
}
```

This one is a little easier to solve, but at first glance it appears it may be complex. For this, we can use the lookup against the parent map, and specifiy the key want.

```terraform 
output "Find-Holiday-date" {
  value = lookup(var.holidays, "eid-al-fitr").season
```

### Example 4: Find all matching Values in a list of a maps

This is probably more realistic than the previous example. There may be multiple values we need to extract based on a key value. In this example, we'll get all holidays which occur in spring.

```terraform
variable "holidays2" {
  default = [
    { name = "Christmas", date = "Dec. 25", season = "winter" },
    { name = "Eid al-Fitr", date = "May 13", season = "spring" },
    { name = "St. Patrick's Day", date = "March 17", season = "spring" }
  ]
}
```

Similar to Example 1, to solve this, iterate over the list elements and match based on each list element. What is different is that we want and expect more than 1 result here and do not specify `.0` to get only the first element matched. 

```terraform 
output "Find-spring-holidays"{
    value = [for x in var.holidays2: x.name if x.season == "spring"]
}
```

The gotcha here is that the result is a tuple (list) and you will have to manipulate that accordingly be it converting to a string(s) or working with each element [0,1] individually.


## Testing

All of these examples are contained within [variables.tf](./variables.tf) and [outputs.tf](./outputs.tf). Pull this repo locally and test out manipulating the data and seeing the results.

```terraform

terraform init
terraform plan
terraform apply

Outputs:

Find-Holiday-Date = "Dec. 25"
Find-Holiday-season = "spring"
Find-month-number-for-March = 3
Find-spring-holidays = [
  "Eid al-Fitr",
  "St. Patrick's Day",
]
Show-one-list-element = {
  "name" = "February"
  "number" = 2
}
```

Hope this helps someone! Enjoy!
