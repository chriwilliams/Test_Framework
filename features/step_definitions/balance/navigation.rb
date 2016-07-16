### Design Pebble ###

When /^In Balance I navigate to the Randomization Design Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Design')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Randomization Design')
end

When /^In Balance I navigate to the Simulation Setups Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Design')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Simulation Setups')
end

When /^In Balance I navigate to the Simulation Results Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Design')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Simulation Results')
end

When /^In Balance I navigate to the Treatment Design Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Design')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Treatment Design')
end

When /^In Balance I navigate to the Visits Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Design')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Visits')
end

When /^In Balance I navigate to the Assign Treatments Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Design')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Assign Treatments')
end

### Subjects Pebble ###

When /^In Balance I navigate to the Subjects Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Subjects')
end


### Inventory Pebble ###

When /^In Balance I navigate to the Inventory Overview Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Inventory')
end

When /^In Balance I navigate to the Inventory By Items Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Inventory')
  $applications.balance.inventory_overview.by_item.click
end

When /^In Balance I navigate to the Lots Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Inventory')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Lots')
end

When /^In Balance I navigate to the Shipments Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Inventory')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Shipments')
end

When /^In Balance I navigate to the Uploads Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Inventory')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Uploads')
end

When /^In Balance I navigate to the Alerts Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Inventory')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Alerts')
end

### Logistics Pebble ###

When /^In Balance I navigate to the Manage Supply Plans Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Logistics')
end

When /^In Balance I navigate to the Manage Depots Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Logistics')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Manage Depots')
end

When /^In Balance I navigate to the Manage Sites Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Logistics')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Sites')
end

When /^In Balance I navigate to the Shipping Associations Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Logistics')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Shipping Associations')
end

When /^In Balance I navigate to the Manage Countries Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Logistics')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Manage Countries')
end

### Properties Pebble ###

When /^In Balance I navigate to the Properties Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Properties')
end

When /^In Balance I navigate to the Study Audits Page$/ do
  $applications.balance.rand_design.main_nav.select_main_nav('Properties')
  $applications.balance.rand_design.sub_nav.select_sub_nav('Study Audits')
end

When /^In Balance I logout$/ do
  $applications.balance.rand_design.logout.click
end

When /^In Balance I follow the iMedidata Logo$/ do
  $applications.balance.rand_design.imedidata_logo.click
end

