require 'retry'

When (/^I create a new ([^"]+)(?: within the "([^"]+)" (?:page|panel|container|tab|bar))?$/) do |type, container|
  case type
    when /^scenario$/i
      create_scenario(container)
    when /^schedules?$/i
      create_schedule(container)
  end
end

When(/^I\s*(?:insert|type) (?:an|the) (?:phrase|text|term|number) "([^"]+)" in the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER})$/) do |phrase, item, tag, container|
  $applications.study_design.send($helpers.to_page_file(container)).insert(item, tag, phrase)
end

When(/^I\s*(?:insert|type) (?:an|the) (?:phrase|text|term|number) "([^"]+)" in the ([^"]+) (#{TAG})$/) do |phrase, item, tag|
  case item
    when /^study design notes?$/i
      $applications.study_design.study_identification.insert(item, tag, phrase)
  end
  sleep 5
end

Then(/^I can see the following ([^"]+) within Design Optimization "([^"]+)" page:$/) do |items, page, table|
  case page
    when /[Aa]ll [Ss]tudies/
      table.hashes.collect { |data| $applications.study_design.all_studies.verifyStudies(data)} if (items =~ /[Ss]tudies/)
  end
end

Then(/^the number of "([^"]+)" is (\d+) within Design Optimization "([^"]+)" page$/) do |items, count, page|
  case page
    when /[Aa]ll [Ss]tudies/
      expect ($applications.study_design.all_studies.count(items.downcase)).should be count.to_i if(items =~ /[Ss]tudies/)
  end
end


Given(/^I navigate to schedule:? "([^"]+)"(?: within the "([^"]+)" page)$/) do |schedule_name, page|
  page ||= 'Schedule'
  case page
    when /^Schedule/
      $applications.study_design.schedules.navigate_to_schedule(schedule_name)
    when /^Analytics/
      $applications.study_design.analytics.navigate_to_schedule(schedule_name)
    when /^Benchmark Analysis/
      $applications.study_design.benchmark_analysis.navigate_to_schedule(schedule_name)
  end
end

Given(/^I select (Primary|Secondary) indication within the "([^"]+)" page$/) do |indication, page|
  case page
    when /^Analytics/
      $applications.study_design.analytics.select_indication(indication)
    when /^Benchmark Analysis/
      $applications.study_design.benchmark_analysis.select_indication(indication)
  end
end


Given(/^I navigate to the "([^"]+)" page$/) do |page|
  $applications.study_design.scenario.toggle_click(page, 'button')
  sleep 0.1
  $applications.study_design.scenario.wait_for_no_spinner
end


def verifyNoScenarioContent(study_title, welcome_message = "Welcome!", start_design_label = "Start Design")
  begin
    expect(study_title).to eq("#{$applications.study_design.home.studyTitle}")
  rescue Exception => e
    puts e.message
  end
  expect(welcome_message).to eq("#{$applications.study_design.no_scenario.welcomeMessage}")
  expect(start_design_label).to eq("#{$applications.study_design.no_scenario.startDesignButtonLabel}")
end

def verifyScenarioContent(study_title)
  begin
  rescue Exception => e
    puts e.message
  end
end


Then(/^I verify(?:| that)? the (?:Page) title is "([^"]*)" and(?:| that)? the (?:Study) title is "([^"]*)"$/) do |page_title, study_title|
  expect(page_title).to eq("#{$applications.study_design.home.pageTitle}")
  expect(study_title).to eq("#{$applications.study_design.home.studyTitle}")
end

Then(/^I verify(?:| that)? I am on the "([^"]*)" page of the "([^"]*)" (?:app|site) with study "([^"]*)"$/) do |scenario, app, study_title|
  case app
    when "Design Optimization"
      case scenario
        when "No Scenario"
          verifyNoScenarioContent(study_title)
      end
  end
end

And /^I verify the text "([^"]*)" in the (Active Scenario) tab$/ do |text, page|
  expect($applications.study_design.send($helpers.to_page_file(page))).to have_text text
end

And /^I verify the text "([^"]*)" in the ([^"]*) (#{TAG}) within the "([^"]*)" (?:#{CONTAINER})$/ do |text, item, tag, page|
  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
  expect($applications.study_design.send($helpers.to_page_file(page)).contains?(item, tag, text)).to be
end


Then(/^the "([^"]*)" (#{TAG}) (?:should be|is) sorted(?: "(Descending|Ascending)")? within the "([^"]*)" (?:#{CONTAINER})$/) do |item, tag, order, container|
  expect($applications.study_design.send($helpers.to_page_file(container)).is_sorted(item, tag, order.downcase || 'ascending'))
end


Then(/^the count of "([^"]*)" (#{TAG}) within the "([^"]*)" (?:#{CONTAINER}) (?:should be|is)\s*(greater|less|greater or equal|less or equal|equal)?(?: than| to)?\s*(\d+)$/) do |item, tag, container, compare, count|
  compare = compare || 'equal'
  case compare.downcase
    when 'equal'
      $async::wait_until(20) { $applications.study_design.send($helpers.to_page_file(container)).count(item, tag).to_i == count.to_i }
      expect($applications.study_design.send($helpers.to_page_file(container)).count(item, tag).to_i).to be count.to_i
    when 'less'
      expect($applications.study_design.send($helpers.to_page_file(container)).count(item, tag).to_i).to be < count.to_i
    when 'greater'
      expect($applications.study_design.send($helpers.to_page_file(container)).count(item, tag).to_i).to be > count.to_i
    when 'less or equal'
      expect($applications.study_design.send($helpers.to_page_file(container)).count(item, tag).to_i).to be <= count.to_i
    when 'greater or equal'
      expect($applications.study_design.send($helpers.to_page_file(container)).count(item, tag).to_i).to be >= count.to_i
  end
end

When(/^I(?: should)? (select|delete|see|add|create|remove) the following "([^"]*)"(?: and verify ([^"]*))?(?: within the "([^"]*)" (?:#{CONTAINER}))?:$/) do |action, category, verify_option, container, table|
  container ||= 'Active Schedule'
  case category
    when /^activit(?:y|ies)$/i
      case action
        when /^add$/i
          add_activities(table)
        when /^select$/i
          select_activity(table)
        when /^delete$/i, /^remove/i
          delete_activity(table)
        when /^see$/i
          verify_activity(container, table)
      end
    when /^visits?$/i
      case action.downcase
        when /^add$/i, /^create$/
          create_visit(table)
        when /^update$/i
          update_visit(table)
        when /^delete$/i, /^remove/i
          delete_visit(table)
      end
  end
end

Then(/^I verify "([^"]*)" page for the Design Optimization study is "([^"]*)"(?: with statement: "([^"]*)")?$/) do |page, type, text|
  case page
    when /[Hh]ome/
      expect($applications.study_design.home.verifyPageIsReadOnly).to be_truthy if (type =~ /[Rr]ead [Oo]nly/)
    when /[Nn]o [Ss]cenarios?/
      expect($applications.study_design.no_scenario.verifyPageIsReadOnly).to be_truthy if (type =~ /[Rr]ead [Oo]nly/)
  end
end

When(/^I note the "([^"]*)" (#{TAG})(?: within the "([^"]*)" (?:#{CONTAINER}))? as "([^"]*)"$/) do |item, tag, container, store|
  container ||= "Scenario Tab"
  sleep 1
  $sticky[store.to_sym] = $applications.study_design.send($helpers.to_page_file(container)).get(item, tag) unless $sticky.has_key?(store.to_sym)
end

When(/^I navigate to "([^"]*)" (scenario|schedule) within the "([^"]*)" (?:#{CONTAINER})$/) do |name, tab, container|
  name = $sticky[name.to_sym] if $sticky.has_key? name.to_sym

  case tab
    when /^scenario$/i
      $applications.study_design.send($helpers.to_page_file(container)).switch_to_tab(name)
      sleep 0.5
      step %Q{I can see the "Scenario Tab" bar within the "Scenario" page}
      step %Q{I can see the "Active Scenario" tab within the "Scenario Tab" bar}
      step %Q{I should see the text: "#{name}" in the "Active Scenario" tab within the "Scenario Tab" bar}
    when /^schedule$/i
      navigate_to_schedule(name, container)
  end
end

And /^I navigate to scenario "([^"]*)"$/ do |scenario_name|
  navigate_to_scenario(scenario_name)
end

And /^I navigate to(?: the)? ([Aa]nalytics|[Ss]chedule|[Bb]enchmark? [Aa]nalysis) page(?: for schedule:? "([^"]*)")?$/ do |page, schedule|

  case page
    when /^analytics$/i, /^schedule$/i, /^benchmark? analysis$/i
      $applications.study_design.scenario.click(page, 'button') unless $applications.study_design.scenario.is_active?(page, 'button')
  end
  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
  if schedule
    schedule = $sticky[schedule.to_sym] if $sticky.has_key? schedule.to_sym
    case page
      when /^analytics$/i
        expect($applications.study_design.analytics.displayed?).to be
        $applications.study_design.analytics.invoke_action({'schedule' => schedule})
      when /^schedule$/i
        sleep 0.01
        expect($applications.study_design.schedules.displayed?).to be
        navigate_to_schedule(schedule, 'Schedules Tabs')
      when /^benchmark? analysis$/i
        expect($applications.study_design.benchmark_analysis.displayed?).to be
        $applications.study_design.benchmark_analysis.invoke_action({'schedule' => schedule})
    end
  end
  sleep 0.01
  $applications.study_design.scenario.wait_for_no_spinner
end


Given(/^I am in Design Optimization for study group "([^"]*)" and study "([^"]*)"$/) do |study_group, study|
  steps %Q{
    And I navigate to "MCCAdmin" for study group "#{study_group}" from iMedidata
    And I navigate to "#{study}" Study in "Design Optimization" study list
    And I navigate to "Design Optimization" page from "Manage Users" page
    And I verify the page "home" of app "Study_Design" is displayed
    And I verify the Page title is "Design Optimization" and the Study title is "#{study}"
  }
end

And(/^[iI]n Design Optimization Study Identification contains following data:$/) do |table|
  steps %Q{
      And I see the "Study Identification" link within the "Scenario" page
      When I toggle-open the "Study Identification" toggle-button within the "Scenario" page
      Then I should see the "Study Identification" panel within the "Scenario" page
  }
  table.hashes.each do |row|
    expect($applications.study_design.send($helpers.to_page_file('Study Identification')).contains?(row['field'], 'input-field', row['value'])).to be_truthy
  end
end


And(/^[iI]n Design Optimization I navigate to scenario(?: "([^"]*)")?$/) do |scenario_name|
  #TODO: Talk to Stanley
  if $scenario_name.nil? and scenario_name
    $scenario_name = scenario_name
  end
  step %Q{I can see the "Scenario Tab" bar within the "Scenario" page}
  step %Q{I can see the "Active Scenario" tab within the "Scenario Tab" bar}
  step %Q{I should see the text: "#{scenario_name}" in the "Active Scenario" tab within the "Scenario Tab" bar}
end

And(/^[iI]n Design Optimization I note the ([^"]*)$/) do |object|
  case object.downcase
    when 'scenario'
      $scenario_index ||= 1
      step %Q{And I note the "Active Scenario" tab within the "Scenario Tab" bar as "scenario_#{$scenario_index}"}
      $scenario_index += 1
    when 'schedule name'
      $schedule_index ||= 1
      step %Q{I note the "Active Schedule" tab within the "Schedules Tabs" bar as "schedule_#{$schedule_index}"}
      $schedule_index += 1
    when 'current cost and complexity'
      steps %Q{
        And I note the "Cost per Subject" value within the "Cost Complexity" container as "cost_value"
        And I note the "Complexity per Subject" value within the "Cost Complexity" container as "complexity_value"
      }
  end
end

And(/^[iI]n Design Optimization I navigate to schedule "([^"]*)" for "([^"]*)" scenario$/) do |schedule_name, scenario_name|
  #TODO: add later navigation to scenario along with schedule.
  steps %Q{
          And I see the "Schedule" button within the "Scenario" page
          And I click on the "Schedule" button within the "Scenario" page
          And I see the "Schedules" container within the "Scenario" page
          And I see the "Schedules Tabs" bar within the "Schedules" container
          }
  steps %Q{
          And I see the text: "#{schedule_name}" in the "Active Schedule" label within the "Schedules Tabs" bar
          And I see the "Schedule Tab" bar within the "Active Schedule" tab
          And I should see the "Activities" tab within the "Schedule Tab" bar
          And I should see the "Visits" tab within the "Schedule Tab" bar
          And I should see the "Schedule Grid" tab within the "Schedule Tab" bar
          }
end

And(/^[iI]n Design Optimization I navigate to (Schedule Grid|Activities|Visits) for schedule "([^"]*)"$/) do |tab, schedule_name|
  schedule_name = $sticky[schedule_name.to_sym] if $sticky.has_key? schedule_name.to_sym
  steps %{
    And I see the text: "#{schedule_name}" in the "Active Schedule" label within the "Schedules Tabs" bar
    And I see the "Schedule Tab" bar within the "Active Schedule" tab
    And I should see the "Activities" tab within the "Schedule Tab" bar
    And I should see the "Visits" tab within the "Schedule Tab" bar
    And I should see the "Schedule Grid" tab within the "Schedule Tab" bar
    }
  case tab.downcase
    when "schedule grid"
      steps %Q{
        And I click on the "Schedule Grid" tab within the "Schedule Tab" bar
      }
    when "activities"
      steps %Q{
            And I click on the "Activities" tab within the "Schedule Tab" bar
            And I see the "Search" box within the "Activities" tab
            }
    when "visits"
      steps %Q{
            And I click on the "Visits" tab within the "Schedule Tab" bar
            And I see the "Visits" panel within the "Visits Details" tab
            }
  end
end

And(/^[iI]n Design Optimization I add following objective\(s\) for scenario "([^"]*)":$/) do |scenario, table|
  scenario = $sticky[scenario.to_sym] if $sticky.has_key? scenario.to_sym
  steps %Q{
    And I navigate to "#{scenario}" scenario within the "Scenario Tab" bar
    And I see the tab: "#{scenario}" in the "Active Scenario" tab within the "Scenario Tab" bar
    And I see the "Objectives/Endpoints" link within the "Scenario" page
    And I toggle-open the "Objectives/Endpoints" toggle-button within the "Scenario" page
    And I see the "Objectives/Endpoints" panel within the "Scenario" page
  }

  $objective_count ||= 0
  table.hashes.each_with_index do |data|
    action = $objective_count > 0 ? 'new' : 'first'
    case action
      when 'new'
        step %Q{I see the "New Objective" button within the "Objectives/Endpoints" panel}
        step %Q{I click on the "New Objective" button within the "Objectives/Endpoints" panel}
        step %Q{I see the "Editable Objective" container within the "Objectives/Endpoints" panel}
      when 'first'
        step %Q{I see the "No Objectives" container within the "Scenario" page}
        step %Q{I see the "Add Objective" link within the "No Objectives" container}
        step %Q{I click on the "Add Objective" link within the "No Objectives" container}
        step %Q{I should see the "Editable Objective" first container within the "Objectives/Endpoints" panel}
    end
    step %Q{I see the "Add Objective" form within the "Editable Objective" container}
    step %Q{I see the text: "Add Objective - All fields are required" in the "#{action.capitalize} Objective" header within the "Editable Objective" container}
    data.merge!('action' => 'save')
    page = $applications.study_design.send($helpers.to_page_file('Objective Form'))
    page.add_objective(data)
    sleep 0.5
    $objective_count += 1
  end
end

And(/^[iI]n Design Optimization I add following (first|new) endpoint\(s\) for respective objective:$/) do |action, table|
  step %Q{I see the "Objectives/Endpoints" link within the "Scenario" page}
  add_endpoint(table.hashes, action.downcase)
end


And(/^[iI]n Design Optimization I verify the (Cost|Complexity) Per Subject has (increased|decreased|not changed)$/) do |cost_complexity, action|
  sleep 5
  case cost_complexity.downcase
    when "cost"
      current_value = $applications.study_design.send($helpers.to_page_file('Cost Complexity')).get('Cost per Subject', 'value').gsub(/\D/, '').to_f
      expected_value = $sticky[:cost_value].gsub(/\D/, '').to_f
    when "complexity"
      current_value = $applications.study_design.send($helpers.to_page_file('Cost Complexity')).get('Complexity per Subject', 'value').to_f
      expected_value = $sticky[:complexity_value].to_f
  end
  step %Q{I Print content "Original #{cost_complexity}: #{expected_value}" to shamus output}
  case action.downcase
    when "increased"
      raise "Current value: #{current_value} is not correct" unless current_value > expected_value
    when "decreased"
      raise "Current value: #{current_value} is not correct" unless current_value < expected_value
    when "not changed"
      raise "Current value: #{current_value} is not correct" unless current_value == expected_value
  end
  step %Q{I Print content "VERIFIED : #{cost_complexity} value has #{action} as expected" to shamus output}
end

And(/^[iI]n Design Optimization I remove following (activities|visits):$/) do |activities_visits, table|
  # table is a table.hashes.keys # => [:activity name, :is linked]
  case activities_visits.downcase
    when "activities"
      delete_activity(table)
    when "visits"
      delete_visit(table)
  end
end

And(/^[iI]n Design Optimization I add following (activities|visits)(?: and verify usage)?:$/) do |activities_visits, table|
  case activities_visits.downcase
    when "activities"
      table.hashes.each do |data|
        steps %Q{
            And I see the "Search" box within the "Activities" tab
            When I insert the phrase "#{data['code']}" in the "Search" input-field within the "Activity Search" box
            Then I should see the "Activity Results" container within the "Activities" tab
            And I should see the "Activity Results" table within the "Activities" tab
            And I should see the "Name & Description" header within the "Activity Results" table
            And I should see the "Code" header within the "Activity Results" table
            And I should see the "Protocol Usage %" header within the "Activity Results" table
        }
        data['name description'] = data['activity name']
        expect($applications.study_design.send($helpers.to_page_file('Activity Results'))).to be_truthy

        steps %Q{
              When I click once on the "Name & Description" column for "#{data['name description']}" within the "Activity Results" table
              And I click on the "Close" button within the "Activity Results" table
              And I should see the "Added Activities" container within the "Activities" tab
        }

      end

    when "visits"
      steps %Q{
            And I see the "Visits" tab within the "Schedule Tab" bar
            When I click on the "Visits" tab within the "Schedule Tab" bar
            Then I should see the "Visits" panel within the "Visits Details" tab
            And I should see the "New Visit" button within the "Visits Details" tab
            And I should see the "Visits Quantity" input-field within the "Visits Details" tab
      }
      $applications
          .study_design
          .visits_details
          .add(
              table.hashes.inject([]) do |visits, row|
                visits << ({encounter_type: row['encounter type'], visit_type: row['visit type'], name: row['visit name']})
                visits
              end
          )
  end
end
