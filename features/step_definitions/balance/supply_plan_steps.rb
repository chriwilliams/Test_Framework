#Supply Settings sample table layout
#|Short Window  |6    |
#|Long Window   |6    |
#|Do not count  |10   |
#|Do not count  |10   |

#Buffer Settings sample table layout
#|article name           | init stock|min buffer|max buffer|
#|Testing Purposes       |   2       |   3      | 4        |
#|Testing Purposes2      |   4       |   4      | 10       |


When /^In Balance I create supply plan "([^\"]*)" with supply plan mode "([^\"]*)" and settings:$/ do |name,sp_mode,table|
  step %Q{In Balance I navigate to the Manage Supply Plans Page}
  $applications.balance.supply_plan.create_supply_plan(name,sp_mode)
  $applications.balance.supply_plan.set_supply_settings(table)
end

And /^In Balance I remove supply plan "([^\"]*)"/ do|sp_name |
  step %Q{In Balance I navigate to the Manage Supply Plans Page}
  $applications.balance.supply_plan.remove_supply_plan(sp_name)
end

And /^In Balance I edit buffer settings for supply plan "([^\"]*)", with the following values:$/ do |sp_name, table2|
  step %Q{In Balance I navigate to the Manage Supply Plans Page}
  $applications.balance.supply_plan.edit_supply_plan(sp_name)
  $applications.balance.supply_plan.buffer_settings(table2)
end

And /^In Balance I edit supply plan "([^\"]*)" with supply settings:$/ do|sp_name, table |
  step %Q{In Balance I navigate to the Manage Supply Plans Page}
  $applications.balance.supply_plan.edit_supply_plan(sp_name)
  $applications.balance.supply_plan.set_supply_settings(table)
end