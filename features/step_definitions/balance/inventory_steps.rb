When /^In Balance I upload packlist "([^\"]*)" containing (\d+) items with file path "([^\"]*)"$/ do |name,items,path|
  step %Q{In Balance I navigate to the Uploads Page}
  $applications.balance.uploads.upload_packlist(name,items,path)
end

# example options table
# not all of these are necessary to create the lot
# i.e) article and unnumbered quantity is only needed for unnumbered lot
# | lot name            | lot one        |
# | article type        | syringe        |
# | expiry date         | 31 Dec 2018    |
# | depot               | US Depot 1     |
# | unnumbered quantity | 300            |
# | pack run id         | 0982047        |
When /^In Balance I create lot with options:$/ do |options_table|
  step %Q{In Balance I navigate to the Lots Page}
  $applications.balance.lots.create_lot(options_table)
end

When /^In Balance I add items "([^\"]*)" to lot "([^\"]*)"$/ do |articles,lot_name|
  step %Q{In Balance I navigate to the Lots Page}
  $applications.balance.lots.add_items_to_lot(lot_name,articles)
  step %Q{In Balance I navigate to the Randomization Design Page}
end

When /^In Balance I release lot "([^\"]*)" with signature "([^\"]*)"$/ do |lot_name,signature|
  step %Q{In Balance I navigate to the Lots Page}
  $applications.balance.lots.release_lot(lot_name,signature)
end

When /^In Balance I revoke release from lot "([^\"]*)"(?: with audit reason "([^\"]*)")?$/ do |lot_name,audit|
  step %Q{In Balance I navigate to the Lots Page}
  $applications.balance.lots.revoke_release_lot(lot_name,audit)
end


########################## Shipments ##################################

When /^In Balance I run the shipping algorithm$/ do
  step %Q(In Balance I navigate to the Shipments Page)
  $applications.balance.shipments.run_ship_algo.click
end

When /^In Balance I wait (\d+) seconds for shipment "([^\"]*)" to be generated$/ do |wait_time,shipment|
  step %Q(In Balance I navigate to the Shipments Page)
  $applications.balance.shipments.wait_for_shipment(shipment,wait_time.to_i)
end

When /^In Balance I confirm shipment "([^\"]*)" received$/ do |shipment|
  step %Q(In Balance I navigate to the Shipments Page)
  $applications.balance.shipments.confirm_receieved(shipment)
end

# Table example - these can be numbered or unnumbered items
# | Article Name  | Quantity |
# | Fixitol 10mg  | 2        |
# | Pamphlet      | 10       |
When /^In Balance I create a manual shipment with origin "([^\"]*)" and destination "([^\"]*)" containing articles:$/ do |origin,dest,articles|
  step %Q(In Balance I navigate to the Shipments Page)
  $applications.balance.shipments.create_manual_shipment(origin,dest,articles)
end

When /^In Balance I quarantine shipment "([^\"]*)" with reason "([^\"]*)"$/ do |shipment,reason|
  step %Q(In Balance I navigate to the Shipments Page)
  $applications.balance.shipments.quarantine_shipment(shipment,reason)
end
