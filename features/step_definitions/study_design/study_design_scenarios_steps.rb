require 'retry'

When(/^I (delete|remove|copy)(?: the)? "([^"]+)" tab within the "([^"]+)" (?:#{CONTAINER})$/) do |action, item, container,|
  item = $sticky[item.to_sym] if $sticky.has_key? item.to_sym

  case container
    when /^scenario tab$/i
      case action
        when /^delete$/i, /^remove$/i
          case item
            when /^active scenario$/i
              delete_active_scenario
            else
              delete_scenario(item)
          end
        when /^export$/i
          export_scenario
      end
    when /^schedules? tabs?$/i
      case action
        when /^delete$/i, /^remove$/i
          case item
            when /^active schedule$/i
              delete_active_schedule
            else
              delete_schedule(item)
          end
        when /^copy$/i
          copy_active_schedule
      end
  end
end

When /^I rename the "([^"]+)" tab to "([^"]+)"(?: within the "([^"]+)" (?:#{CONTAINER}))?$/ do |item, name, container|
  case item
    when /^active scenario$/i
      container ||= "Scenario Tab"
      case container
        when /^scenario tab$/i
          rename_scenario(name)
      end
    when /^active schedule$/i
      container ||= "Schedules Tabs"
      case container
        when /^schedules? tabs?$/i
          rename_schedule(name)
      end
  end
end

When /^I export the contents from the "([^"]+)" tab$/ do |item|
  case item
    when /^active scenario$/i
      export_scenario
  end
end

Then(/^I(?: should)? get a download for(?: the)? ([^"]+) in "([^"]+)" study$/) do |scenario, study|
  DownloadHelper.wait_for_download
  case scenario
    when /^active scenario$/i
      content = study
  end
  expect(DownloadHelper.download).to include(content)
end


When(/^I(?: can| should)? see the following "(Objectives?|Endpoints?)" within(?: the)? "([^"]+)" (?:page|container|tab|panel)? with parameters:$/) do |type, container, table|
  table.hashes.each_with_index do |data, index|
    page = $applications.study_design.send($helpers.to_page_file(container))
    case type.downcase
      when 'objective', 'objectives'
        expect(page.includes?(type, 'text', data['objective description']))
      when 'endpoint', 'endpoints'
        expect(page.includes?(type, 'list', data['endpoint content']))
    end
  end
end


When(/^I (insert|modify|delete|add|update) (?:a|the|these) (first|new|following) "(Objective|Endpoint)(?:s)?"(?: within(?: the)? "([^"]+)" (?:tab)? with parameters)?(?: for the following objective\(s\))?:$/) do |action, how, type, container, table|
  container ||= "Active Scenario"
  case container.downcase
    when 'active scenario'
    else
      step %Q{I access "#{container}" scenario within the "Scenario Tab" bar }
      step %Q{I see the "Scenario Tab" bar within the "Scenario" page}
      step %Q{I see the text: "#{container}" in the "Active Scenario" tab within the "Scenario Tab" bar}
  end

  step %Q{I see the "Objectives/Endpoints" link within the "Scenario" page}

  case action
    when /^add$/i, /^insert$/i
      case type
        when /^objectives?$/i
          add_objective(table.hashes, how.downcase)
        when /^endpoints?$/i
          add_endpoint(table.hashes, how.downcase)
      end
    when /^modify$/i, /^update$/i
      case type
        when /^objectives?$/i
          edit_objective(table.hashes)
        when /^endpoints?$/i
          edit_endpoint(table.hashes)
      end
    when /^delete/i
      case type
        when /^objectives?$/i
          delete_objective(table.hashes)
        when /^endpoints?$/i
          delete_endpoint(table.hashes)
      end
  end
end


def is_page_displayed(page)
  $async.wait_with_retries(timeout: 30, attempts: 2) do
    $applications.study_design.send($helpers.to_page_file(page)).displayed?
  end
rescue Exception => e
    puts "Page Load Exception: #{e.message}."
    return false
end

def create_scenario(page = nil)
  case page
    when 'scenario'
      step %Q{I click on the "New Scenario" button within the "Scenario Tab" bar} #if $applications.study_design.send($helpers.to_page_file(container)).displayed?
    when 'no scenario'
      step %Q{I click on the "Start Design" button within the "No Scenario" page} #if $applications.study_design.send($helpers.to_page_file(container)).displayed?
    else
      if is_page_displayed('scenario') && is_page_displayed('scenario tab')
        step %Q{I click on the "New Scenario" button within the "Scenario Tab" bar}
      elsif is_page_displayed('no scenario')
        step %Q{I click on the "Start Design" button within the "No Scenario" page}
      end
  end
  step %{I can see the "Scenario Tab" bar within the "Scenario" page}
  step %{I can see the "New Scenario" button within the "Scenario Tab" bar}
end

def access_action_menu_scenario
  steps %Q{
    Given I can see the "Scenario Tab" bar within the "Scenario" page
    And I can see the "Active Scenario" tab within the "Scenario Tab" bar
    And I can see the "Action" button within the "Active Scenario" tab
  }
end

def delete_scenario(scenario_name)
  scenario_name = $sticky[scenario_name.to_sym] if $sticky.has_key? scenario_name.to_sym
  steps %Q{
    Given I can see the "Scenario Tab" bar within the "Scenario" page
    And the count of "Scenario" tab within the "Scenario Tab" bar should be greater than 1
    And the "Scenario Tab" bar contains the tab: "#{scenario_name}" within the "Scenario" page
  }
  $applications.study_design.send($helpers.to_page_file('Scenario Tab')).switch_to_tab(scenario_name)
  sleep 0.5
  delete_active_scenario
end

def delete_active_scenario
  access_action_menu_scenario
  $applications.study_design.send($helpers.to_page_file('Active Scenario')).invoke_action({'action' => 'delete', 'button' => 'Yes'})
end

def rename_scenario(name)
  access_action_menu_scenario
  $applications.study_design.send($helpers.to_page_file('Active Scenario')).invoke_action({'action' => 'rename', 'scenario name' => name, 'button' => 'Save'})
end

def export_scenario
  sleep 0.01
  access_action_menu_scenario
  sleep 0.01
  $applications.study_design.send($helpers.to_page_file('Active Scenario')).invoke_action({'action' => 'export'})
  sleep 0.01
end

def navigate_to_scenario(scenario_name)
  scenario_name = $sticky[scenario_name.to_sym] if $sticky.has_key? scenario_name.to_sym

  expect($applications.study_design.scenario.has?('Scenario Tab', 'bar')).to be_truthy
  expect($applications.study_design.scenario_tab.has?('Active Scenario', 'tab')).to be_truthy

  unless ($applications.study_design.scenario_tab.contains?('Active Scenario', 'tab', scenario_name))
    $applications.study_design.scenario_tab.switch_to_tab(scenario_name)
  end

  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
  sleep 0.01
  expect($applications.study_design.scenario_tab.contains?('Active Scenario', 'tab', scenario_name)).to be_truthy
end
