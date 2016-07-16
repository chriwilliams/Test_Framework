
Then /^In Balance I search for site "([^\"]*)"$/ do |site_name|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.search_site_name(site_name)
end

Then /^In Balance I activate shipping for site "([^\"]*)"$/ do |site_name|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.activate_shipping(site_name)
end

And /^In Balance I check site "([^\"]*)"$/ do |site_name|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.check_site(site_name)
end

And /^In Balance I assign site "([^\"]*)" to supply plan "([^\"]*)"$/ do |site_name, supply_plan_param|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.search_site_name(site_name)
  $applications.balance.manage_sites.check_site(site_name)
  $applications.balance.manage_sites.assign_supply_plan(supply_plan_param)
end

And /^In Balance I assign all sites to supply plan "([^\"]*)"$/ do |supply_plan_param|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.select_all_sites_supply_plan(supply_plan_param)
end

When /^In Balance I assign site "([^\"]*)" to depot "([^\"]*)"$/ do |site_name,depot_name|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.assign_one_depot(site_name,depot_name)
end

And /^In Balance I assign all sites to depot "([^\"]*)"$/ do |depot_name|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.select_all_sites_depot(depot_name)
end

Then /^In Balance I deactivate shipping for site "([^\"]*)"$/ do |site_name|
  step %Q{In Balance I navigate to the Manage Sites Page}
  $applications.balance.manage_sites.deactivate_shipping(site_name)
end