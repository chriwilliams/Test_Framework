When /^In Balance I Go Live with(out)? flushing data$/ do |preserve|
  step %Q{In Balance I navigate to the Properties Page}
  if preserve
    $applications.balance.properties.make_study_go_live(true)
  else
    $applications.balance.properties.make_study_go_live(false)
  end
end

When /^In Balance I import study design from study "([^\"]*)"$/ do |study|
  step %Q{In Balance I navigate to the Properties Page}
  $applications.balance.properties.import_study_design(study)
end

When /^In Balance I enable quarantining at site with file upload option "([^\"]*)"$/ do |file_option|
  step %Q{In Balance I navigate to the Properties Page}
  $applications.balance.properties.enable_quarantine(file_option)
end

When /^In Balance I remove test data$/ do
  step %Q{In Balance I navigate to the Properties Page}
  $applications.balance.properties.remove_runtime_data()
end

When /^In Balance I (enable|disable) Randomization Only$/ do |option|
  step %Q{In Balance I navigate to the Properties Page}
  if option == 'enable'
    $applications.balance.properties.set_rand_only(true)
  else
    $applications.balance.properties.set_rand_only(false)
  end
end

When /^In Balance I (enable|disable) Ignoring Role Blinding Restrictions$/ do |option|
  step %Q{In Balance I navigate to the Properties Page}
  if option == 'enable'
    puts option
    $applications.balance.properties.set_blinding_restrictions(true)
  else
    puts option
    $applications.balance.properties.set_blinding_restrictions(false)
  end
end

When /^In Balance I (enable|disable) Advanced Dosing Rules$/ do |option|
  step %Q{In Balance I navigate to the Properties Page}
  if option == 'enable'
    $applications.balance.properties.set_advanced_dosing(true)
  else
    $applications.balance.properties.set_advanced_dosing(false)
  end
end

When /^In Balance I (enable|disable) Site Address in Shipping Requests$/ do |option|
  step %Q{In Balance I navigate to the Properties Page}
  if option == 'enable'
    $applications.balance.properties.set_site_address(true)
  else
    $applications.balance.properties.set_site_address(false)
  end
end

When /^In Balance I (enable|disable) Capping$/ do |option|
  step %Q{In Balance I navigate to the Properties Page}
  if option == 'enable'
    $applications.balance.properties.set_capping(true)
  else
    $applications.balance.properties.set_capping(false)
  end
end
