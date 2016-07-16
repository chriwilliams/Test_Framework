include JanusSelectorHelpers

When(/^I (visit|access) the "([^"]+)" (#{CONTAINERS}) within the "([^"]+)" (?:#{CONTAINERS})$/) do |visit, section, tag, container|
  access = (visit == 'access')
  case section
    when 'Study Identification'
      access_study_identification
      sleep 10
    when 'Objectives/Endpoints'
      access_objectives_endpoints
    when 'No Schedule'
      access_schedule(access)
    when('Schedules')
      access_schedules(access)
    when'Activities Details', 'Visits Details', 'Schedule Grid Details'
      access_schedule_tabs_details(section, tag)
  end
end


When(/^I toggle(?:-)?(open|on|close|off) the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER})(?: for "([^"]+)")?$/) do |state, item, tag, container, statement|
  case state
    when 'open', 'on'
      toggle = false
    when 'close', 'off'
      toggle = true
    else
      raise Capybara::ExpectationNotMet, "expecting state to be open, on, close, off. got #{state}"
  end
  $applications.study_design.send($helpers.to_page_file(container)).reset(statement) if statement
  $applications.study_design.send($helpers.to_page_file(container)).toggle_click(item, tag, toggle)
end

#TODO the codes below will need better refactoring
When(/^I\s?(?:should|can)? see the following (labelled fields|labels|fields|values) within the "([^"]+)" (#{CONTAINER}):$/) do |tag, container, ctag, table|
  colname = (tag =~ /field/) ? 'field' : 'label'
  table.hashes.each do |row|
    case colname
      when 'value'
        step %Q{the "#{row[colname]}" #{tag.chop} matches the value "#{row['value']}" within the "#{container}" #{ctag}}
      else
        step %Q{I see the "#{row[colname]}" #{tag.chop} within the "#{container}" #{ctag}}
        step %Q{I see the "#{row[colname]}" #{tag.chop} is #{row['field_type']} within the "#{container}" #{ctag}} if colname == 'field'
    end
  end
end

When(/^I see the following values from the "([^"]+)" (fields) within the "([^"]+)" (#{CONTAINERS}):$/) do |object, type, container, c_tag, table|
  case object
    when 'Study Identification'
      case type
        when 'fields'
          fields = $applications.study_design.scenario.get_list_content('Study Identification', 'fields', container)
          table.hashes.each_with_index do |attributes|
            field = fields.find {|e| ( e[:name] == attributes['name'] )}
            expect(field.value).to eq(attributes['value'])
          end
      end
  end
end


And(/^the "([^"]+)" (#{TAG}) matches the value "([^"]+)" within the "([^"]+)" (?:#{CONTAINER})$/) do |item, tag, value, container|
  expect($applications.study_design.send($helpers.to_page_file(container)).matches?(item, tag, value)).to eq be_true
end

And(/^I see the "([^"]+)" (#{TAG}) is (not |)(readonly|read\/write|empty|enabled|disabled) within the "([^"]+)" (?:#{CONTAINER})$/) do |item, tag, negate, expected, container|
  negate = nil if negate == ""
  expect($applications.study_design.send($helpers.to_page_file(container)).send("#{expected.gsub(/\//, '_')}?", item, tag)).to ( negate ? be_falsey : be_truthy)
end

def access_objectives_endpoints
  step %Q{I toggle-open the "Objectives/Endpoints" toggle-button within the "Scenario" page}
  step %Q{I can see the "Objectives/Endpoints" panel within the "Scenario" page}
end

def access_study_identification
  step %Q{I toggle-open the "Study Identification" toggle-button within the "Scenario" page}
  step %Q{I can see the "Study Identification" panel within the "Scenario" page}
end


And /^I add a new (objective|endpoint) with the following attributes:$/ do |type, attributes|
  $applications.study_design.send("add_#{type}").add(attributes.hashes[0])
end

When /^I (save|cancel) the new (objective|endpoint)$/ do |op, type|
  step %Q{I click the "#{op.capitalize}" button within the "Add #{type.capitalize}" section}
end
