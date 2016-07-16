

Given(/^the "([^"]+)" (#{TAG}) matches the generic "([^"]+)" within the "([^"]+)" (#{CONTAINER})/) do |item, tag, type, container, c_tag|
  case type
    when 'Scenario Name'
      step %Q{the "#{item}" #{tag} matches the text: "#{$scenario_name}" within the "#{container}" #{c_tag}}
  end
end




# And(/^I click on the "(.*?)" tab         with title          matching "(.*?)"        within the "(.*?)" bar$/)
When(/^I click on the "([^"]+)" (#{TAGS}) with title (contain|match)(?:ing) "([^"]+)" within the "([^"]+)" (?:#{CONTAINERS})$/) do |item, tag, cmp, content, container|
  comp = {"match" => true, "contain" => false}
  $applications.study_design.scenario.click_on_item(item, tag, container, content, comp[cmp])
end

When(/^I click on the Generic "Scenario" tab within the "(Scenario Tab)" bar$/) do |container|
  step %Q{the "Scenario Tab" bar contains the tab: "#{$scenario_name}" within the "Scenario" page}
  sleep 1
  step %Q{I click on the "Scenario" tabs with title matching "#{$scenario_name}" within the "Scenario Tab" bar}
  sleep 2
  step %Q{the "Scenario Tab" bar contains the tab: "#{$scenario_name}" within the "Scenario" page}
  sleep 1
  step %Q{the "Scenario Description" input-field matches the text: "#{$scenario_name}" within the "Scenario" page}
end
