And /^I navigate to (Activities|Visits|Schedule Grid) tab$/i do |tab|
  expect($applications.study_design.active_schedule.has?('Schedule Tab', 'bar')).to be_truthy
  $applications.study_design.schedule_tab.switch_to(tab)

  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
  case tab
    when /^activit(?:y|ies)$/i
      expect($applications.study_design.activities.has?('Search', 'box')).to be_truthy
    when /^visits?$/i
      expect($applications.study_design.visits_details.has?('Visits', 'panel')).to be_truthy
    when /^schedule grid$/i
      expect($applications.study_design.schedule_grid_details.has?('Schedule Grid', 'panel')).to be_truthy
  end
end

And /^I note(?: the)? [aA]ctive [sS]chedule name as "([^"]*)"$/ do | store|
  sleep 1
  $sticky[store.to_sym] = $applications.study_design.schedules_tabs.get('Active Schedule', 'tab') unless $sticky.has_key?(store.to_sym)
end

def create_schedule(page = nil)
  $applications.study_design.scenario.toggle_click('Schedule', 'button')
  sleep 0.1
  $applications.study_design.scenario.wait_for_no_spinner

  if page.nil?
    if is_page_displayed('no schedule')
      page = "No Schedule"
    elsif is_page_displayed('schedules')
      page = "Schedules"
    else
      raise MediTAFException("Unable to verify whether a 'Schedule' page can be found")
    end
  end
  case page
    when 'No Schedule'
      $applications.study_design.no_schedule.create_new_schedule
    when 'Schedules'
      $applications.study_design.schedules.create_new_schedule
  end
end

def navigate_to_schedule(schedule_name, container)
  schedule_name = $sticky[schedule_name.to_sym] if $sticky.has_key? schedule_name.to_sym

  unless $applications.study_design.scenario.is_active?('Schedule', 'button')
    $applications.study_design.scenario.click('Schedule', 'button')
    sleep 5
  end
  $applications.study_design.send($helpers.to_page_file(container)).switch_to_tab(schedule_name)
  sleep 0.5
  steps %Q{
    Given I see the "Schedules" container within the "Scenario" page
    And I see the "Schedules Tabs" bar within the "Schedules" container
    And I see the "New Schedule" button within the "Schedules Tabs" bar
    And I see the "Active Schedule" tab within the "Schedules Tabs" bar
    And I see the text: "#{schedule_name}" in the "Active Schedule" label within the "Schedules Tabs" bar
  }
end

def verify_active_schedule
  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
  expect($applications.study_design.schedules_tabs.has?('Active Schedule', 'tab')).to be_truthy
end

def delete_active_schedule(is_linked = false)
  verify_active_schedule
  expect($applications.study_design.active_schedule.has?('Action', 'button')).to be_truthy
  $applications.study_design.send($helpers.to_page_file('Active Schedule')).invoke_action({'action' => 'delete', 'is linked' => is_linked, 'button' => 'Yes'})
  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
end

def delete_schedule(schedule_name, is_linked = false)
  schedule_name = $sticky[schedule_name.to_sym] if $sticky.has_key? schedule_name.to_sym

  $applications.study_design.send($helpers.to_page_file('Schedules Tabs')).switch_to_tab(schedule_name)

  sleep 1
  $applications.study_design.scenario.wait_for_no_spinner
  delete_active_schedule(is_linked)
  $applications.study_design.scenario.wait_for_no_spinner
end

def rename_schedule(name)
  verify_active_schedule

  expect($applications.study_design.active_schedule.has?('Action', 'button')).to be_truthy
  $applications.study_design.active_schedule.invoke_action({'action' => 'rename', 'schedule name' => name, 'button' => 'Save'})

  sleep 1
  $applications.study_design.scenario.wait_for_no_spinner

  expect($applications.study_design.schedules_tabs.has?('Active Schedule', 'tab')).to be_truthy
  expect($applications.study_design.schedules_tabs.contains?('Active Schedule', 'tab', name)).to be_truthy
end

def copy_active_schedule
  verify_active_schedule
  expect($applications.study_design.active_schedule.has?('Action', 'button')).to be_truthy
  $applications.study_design.send($helpers.to_page_file('Active Schedule')).invoke_action({'action' => 'copy'})

  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
end


