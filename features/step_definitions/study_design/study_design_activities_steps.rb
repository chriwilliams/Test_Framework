include JanusSelectorHelpers

When(/^I select the following "Activities" from search within the "Activities Details" panel:$/) do |table|
  table.hashes.each_with_index do |attributes|
    sleep 1
    step %Q{I can see the "Activity Search" input-field within the "Activities Details" panel}
    sleep 1
    step %Q{I insert the phrase "#{attributes['search term']}" in the "Activity Search" input-field within the "Activities Details" panel}
    sleep 1
    step %Q{I can see the "Search Results" table within the "Activities Details" panel}
    sleep 1
    step %Q{I click once on the row that matches "#{attributes['activity selected']}" using search term "#{attributes['search term']}" in the "Search Results" list within the "Activities Details" panel}
  end
end

When(/^I click (once|twice|\d+ times) on the row that (match|contain)(?:s|es) "([^"]+)" using search term "([^"]+)" in the "(Search Results)" (list) within the "(Activities Details)" panel$/) do |times, matcher, selection, search, item, tag, container|
  click_on_activity_in_results(search, selection)
end

When(/^I click (once|twice|\d+)(?: times)? on the "([^"]+)" (#{TAG}) for "([^"]+)" within the "([^"]+)" (?:#{CONTAINER})$/) do |multiplier, item, tag, content, container|
count = 0
case multiplier
    when 'once'
      count = 1
    when 'twice'
      count = 2
    else
      count = multiplier.to_i
  end
  for i in 1..count
    sleep 0.5
    click_activity(item, tag, container, content, i)
  end
end

When(/^I delete the "([^"]+)" (#{TAG}) for "([^"]+)": "([^"]+)" within the "([^"]+)" (?:#{CONTAINER})$/) do |item, tag, type, content, container|
  $applications.study_design.send($helpers.to_page_file(container)).delete_activity(content)
end

def add_activities(table)
  table.hashes.collect{|data| add_activity(data)}
end

def add_activity(data)
  steps %Q{
    And I see the "Search" box within the "Activities" tab
    When I insert the phrase "#{data['code']}" in the "Search" input-field within the "Activity Search" box
    Then I should see the "Activity Results" container within the "Activities" tab
    And I should see the "Activity Results" table within the "Activities" tab
    And I should see the "Name & Description" header within the "Activity Results" table
    And I should see the "Code" header within the "Activity Results" table
    And I should see the "Protocol Usage %" header within the "Activity Results" table
  }

  expect($applications.study_design.send($helpers.to_page_file('Activity Results')).has_activity_content?(data)).to be_truthy
  expect($applications.study_design.send($helpers.to_page_file('Activity Results')).click_on_activity?(data)).to be_truthy

  step %Q{I Print content "VERIFIED: #{data.collect{|key, value| "#{key.capitalize}: #{value}"}.join(' --- ')} as expected" to shamus output}
  step %Q{I should see the "Added Activities" container within the "Activities" tab}
end

# Clicks on Activity, produces exception if click fails
# @param item
# @param tag
# @param container
# @param content
# @param count
def click_activity(item, tag, container, content, count)
  expect($applications.study_design.send($helpers.to_page_file(container)).click_on_activity?({item=> content}, count)).to be_truthy
end

# verifies activity(ies)
# @param container
# @param table [Hash] data hash with data
def verify_activity(container, table)
  step %Q{I see the "#{container}" table within the "Activities" tab}
  case container.downcase
    when 'activity results'
      step %Q{I see the "Name & Description" header within the "Activity Results" table}
      step %Q{I see the "Code" header within the "Activity Results" table}
      step %Q{I should see the "Protocol Usage %" header within the "Activity Results" table}
  end
  step %Q{the count of "Row Activity" items within the "#{container}" table should be greater than 1}
  table.hashes.each_with_index do |row|
    expect($applications.study_design.send($helpers.to_page_file(container)).has_activity_content?(row)).to be_truthy
  end
end

# deletes activity(ies)
# @param table [Hash] data hash with data
def select_activity(table)
  step %Q{I see the "Activity Results" table within the "Activities" tab}
  step %Q{I see the "Name & Description" header within the "Activity Results" table}
  step %Q{I see the "Code" header within the "Activity Results" table}
  step %Q{I should see the "Protocol Usage %" header within the "Activity Results" table}
  step %Q{the count of "Row Activity" items within the "Activity Results" table should be greater than 1}
  table.hashes.each_with_index do |row|
    step %Q{I click #{row['count']} times on the "Name & Description" column for "#{row['name description']}" within the "Activity Results" table} if row.has_key? 'name description'
    step %Q{I click #{row['count']} times on the "Code" column for "#{row['code']}" within the "Activity Results" table} if row.has_key? 'code'
  end
end


# deletes activity(ies)
# @param table [Hash] data hash with data
def delete_activity(table)
  step %Q{I see the "Added Activities" table within the "Activities" tab}
  step %Q{I see the "Activity Name" header within the "Added Activities" table}
  step %Q{I see the "Code" header within the "Added Activities" table}
  step %Q{the count of "Row Activity" items within the "Added Activities" table should be greater than 1}
  table.hashes.each_with_index do |data|
    step %Q{I delete the "Row Activity" items for "Code": "#{data['code']}" within the "Added Activities" table} if data.has_key? 'code'
    step %Q{I delete the "Row Activity" items for "Activity Name ": "#{data['activity name']}" within the "Added Activities" table} if data.has_key? 'activity name'

    if data.has_key? 'is linked'
      if data['is linked'].downcase == 'yes'
        sleep 0.5
        step %Q{I should see the Modal Dialog with title "Delete Activity" and message "You are trying to delete an Activity that is linked to a Visit(s). Would you like to delete this Activity?"}
        step %Q{I click the Modal Dialog button "Yes"}
      end
    end
  end
end
