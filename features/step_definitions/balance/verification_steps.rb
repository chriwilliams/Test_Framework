######################################################################
# Below Steps are valid for all pages with tables defined as sections
######################################################################

# Below are valid tables and flash notifications to verify
# study arms, randomization factors, article types, treatment compositions, dosing factors
# sites, depots, inventory overview, simulations. packlist, randlist, shipments, lots, subjects, shipments
When /^In Balance I verify the "([^\"]*)" table has contents of:$/ do |table_name, contents|

  # get sticky for any value that might be stored
  contents = contents.raw
  contents.each_with_index do |row, x|
    row.each_with_index do |cell, y|
      contents[x][y] = get_sticky(cell)
    end
  end

  case table_name.downcase
    when 'study arms'
      $applications.balance.rand_design.study_arms_table.verify_contents(contents)
    when 'randomization factors'
      $applications.balance.rand_design.randomization_factors_table.verify_contents(contents)
    when 'article types'
      $applications.balance.treatment_design.article_types_table.verify_contents(contents)
    when 'treatment compositions'
      $applications.balance.treatment_design.treatment_compostions_table.verify_contents(contents)
    when 'dosing factors'
      $applications.balance.treatment_design.dosing_factors_table.verify_contents(contents)
    when 'sites'
      $applications.balance.manage_sites.sites_table.verify_contents(contents)
    when 'depots'
      $applications.balance.manage_depots.depots_table.verify_contents(contents)
    when 'inventory overview'
      $applications.balance.inventory_overview.inventory_overview_table.verify_contents(contents)
    when 'lots'
      $applications.balance.lots.lot_list.verify_contents(contents)
    when 'shipments'
      $applications.balance.shipments.shipment_list.verify_contents(contents)
    when 'rand list'
      $applications.balance.rand_list_generate.randomization_lists.verify_contents(contents)
    when 'packlist upload'
      $applications.balance.uploads.packlist_list.verify_contents(contents)
    when 'simulation setup'
      $applications.balance.simulation_setup.simulation_setup_table.verify_contents(contents)
    when 'simulation result'
      $applications.balance.simulation_result.simulation_execution_list.verify_contents(contents)
    when 'subjects'
      $applications.balance.subject.subjects_table.verify_contents(contents)
    when 'subject_unblind'
      $applications.balance.subject.unblind_history_table.verify_contents(contents)
    else
      raise "Table #{table_name} not found"
  end
  step %Q{I take a screenshot}
end


When /^In Balance I verify the "([^\"]*)" column of "([^\"]*)" table does not contain "([^\"]*)"$/ do |col, table_name, values|
  values.split(',').each do |value|
    row = nil
    value = get_sticky(value)
    case table_name.downcase
      when 'study arms'
        row = $applications.balance.rand_design.study_arms_table.get_row_index(col, value, false)
      when 'randomization factors'
        row = $applications.balance.rand_design.randomization_factors_table.get_row_index(col, value, false)
      when 'article types'
        row = $applications.balance.treatment_design.article_types_table.get_row_index(col, value, false)
      when 'treatment compositions'
        row = $applications.balance.treatment_design.treatment_compostions_table.get_row_index(col, value, false)
      when 'dosing factors'
        row = $applications.balance.treatment_design.dosing_factors_table.get_row_index(col, value, false)
      when 'sites'
        row = $applications.balance.manage_sites.sites_table.get_row_index(col, value, false)
      when 'depots'
        row = $applications.balance.manad_depots.depots_table.verify_cget_row_index(col, value, false)
      else
        raise "Table #{table_name} not found"
    end
    raise "Found #{value} in row #{row} of the #{table_name} table." if row
  end
  step %Q{I take a screenshot}
end

When (/^In Balance I verify and close the notification message "([^"]*)"$/) do |message|
  sleep 5
  $applications.common.base_page.refresh_browser
  $applications.balance.subject_list.notifications.verify_notifications(message)
end

When (/^In Balance I verify the flash message "([^"]*)"$/) do |message|
  $applications.balance.subject_list.notifications.verify_flash(message)
end
