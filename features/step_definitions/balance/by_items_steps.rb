When /^In Balance I select status "([^\"]*)" on the by item page$/ do |sh_header|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.skinny_header_selection(sh_header)
end

When /^In Balance I search by Item Number for items? "([^\"]*)"$/ do |item_name|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.search_by_item(item_name)
end

When /^In Balance I search by Lot for lot number "([^\"]*)"$/ do |lot_name|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.search_by_lot(lot_name)
end

When /^In Balance I search by Article Type for AT number "([^\"]*)"$/ do |at_name|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.search_by_article_type(at_name)
end

When /^In Balance I search by Sequence Range for sequence starting from "([^\"]*)" and ending with "([^\"]*)"$/ do |sq_start,sq_end|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.search_by_sequence(sq_start,sq_end)
end

When /^In Balance I search by Expiry Date between "([^\"]*)" and "([^\"]*)"$/ do |start_date, end_date|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.search_by_expiry(start_date, end_date)
end

When /^In Balance I will select (Depot|Site|Shipment) fat header selection "([^\"]*)"$/ do |fat_headers,fat_name|
  case fat_headers
    when "Depot"
      $applications.balance.by_items.depot_fat_header.select(fat_name)
    when "Site"
      $applications.balance.by_items.site_fat_header.select(fat_name)
    when "Shipment"
      $applications.balance.by_items.shipment_fat_header.select(fat_name)
    else
  end
end

When /^In Balance I waste items with reason "([^\"]*)"$/ do |reason_text_w|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.waste_item(reason_text_w)
end

When /^In Balance I quarantine items with reason "([^\"]*)"$/ do |reason_text_q|
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.quarantine_item(reason_text_q)
end

When /^In balance I download inventory item list$/ do
  step %Q{In Balance I navigate to the Inventory By Items Page}
  $applications.balance.by_items.download_inventory_button.click
end
