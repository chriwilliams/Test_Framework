Given(/^the "([^"]+)" (#{TAG})\s?(?:should)? (contain|match)(?:s|es)? the (?:#{TITLE}):? "([^"]+)" within the "([^"]+)" (?:#{CONTAINER})$/) do |item, tag, matcher, content, container|
  page = $applications.study_design.send($helpers.to_page_file(container))
  matcher = "#{matcher}#{(matcher == 'match') ? 'e' : ''}s?"
  $async::wait_until { page.has?(item, tag) && page.send(matcher, item, tag, content) }
  expect(page.send(matcher, item, tag, content)).to be_truthy
end


Then(/^I(?: should| can)? see the (?:value|text|tab):? "([^"]+)" (?:from|within|in) the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER})$/) do |text, item, tag, container|
  page = $applications.study_design.send($helpers.to_page_file(container))
  $async::wait_until { page.has?(item, tag) }
  $async::wait_until { page.contains?(item, tag, text) }
  expect(page.matches?(item, tag, text)).to be_truthy
end

Then(/^I\s?(?:should|can)? see the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER})(?: for "([^"]+)")?$/) do |item, tag, container, statement|
  sleep 1
  $applications.study_design.send($helpers.to_page_file(container)).reset(statement) if statement
  expect($applications.study_design.send($helpers.to_page_file(container)).has?(item, tag)).to be_truthy
end

Then(/^I (?:should|can|do)(?: not|'t|n't) see the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER})$/) do |item, tag, container|
  expect($applications.study_design.send($helpers.to_page_file(container)).has_no?(item, tag)).to be_falsey
end

Then(/^I\s?(?:should|can)? see the "([^"]+)" (#{TAG}) with the (?:#{TITLE}):? "([^"]+)" within the "([^"]+)" (?:#{CONTAINER})$/) do |item, tag, value, container|
  expect($applications.study_design.send($helpers.to_page_file(container)).contains?(item, tag, value)).to be_truthy
end

And /^the ([^"]+) (#{TAG}) (?:is|should)(?: (not))?(?: be)? visible within the "([^"]+)" (?:#{CONTAINER})$/ do |item, tag, is_not_visible, container|
  unless is_not_visible
    expect($applications.study_design.send($helpers.to_page_file(container)).has?(item, tag)).to be_truthy
  else
    expect($applications.study_design.send($helpers.to_page_file(container)).has_no?(item, tag)).to be_falsey
  end
end

When(/^I click\s?(?:on)? the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER})(?: for "([^"]+)")?$/) do |item, tag, container, statement|
  $applications.study_design.send($helpers.to_page_file(container)).reset(statement) if statement
  $applications.study_design.send($helpers.to_page_file(container)).click(item, tag)

end

When(/^I click\s?(?:on)? the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER}) with (?:title|message):? "([^"]+)"$/) do |item, tag, container, statement|
  $applications.study_design.send($helpers.to_page_file(container)).click(item, tag, statement)
end

And(/^the "([^"]+)" (#{TAG}) within the "([^"]+)" (#{CONTAINER}) (contain|match)(?:s|es)? the following (values|buttons):$/) do |item, tag, container, ctag, matcher, type, table|
  table.hashes.each do |row|
    step %Q{the "#{item}" #{tag} within the "#{container}" #{ctag} #{matcher}s the #{type.chop} "#{row[type]}"}
    if row['enabled']
      step %Q{I see the "#{row[type]}" #{type.chop} is #{row['enabled'] == 'true' ? 'enabled' : 'disabled'} within the "#{container}" #{ctag}}
    end
  end
end


And /^the ([^"]+) (?:#{CONTAINER}) (contain|match)(?:s|es)? the following data:$/ do |container, matcher, table|
  case container
    when /^study identification$/i
      expect($applications.study_design.scenario.has?('Study Identification', 'link')).to be_truthy
      $applications.study_design.scenario.toggle_click('Study Identification', 'toggle-button', false)
      expect($applications.study_design.scenario.has?('Study Identification', 'panel')).to be_truthy
  end
  table.hashes.each do |row|
    case matcher.downcase
      when 'contain'
        expect($applications.study_design.send($helpers.to_page_file(container)).contains?(row['field'], 'input-field', row['value'])).to be_truthy
      when 'match'
        expect($applications.study_design.send($helpers.to_page_file(container)).matches?(row['field'], 'input-field', row['value'])).to be_truthy
    end
  end
end

And(/^the "([^"]+)" (#{TAG}) within the "([^"]+)" (?:#{CONTAINER}) (contain|match)(?:s|es) the (?:value|button) "([^"]+)"$/) do |item, tag, container, matcher, value|
  expect($applications.study_design.send($helpers.to_page_file(container)).send("#{matcher}#{(matcher == 'match') ? 'e' : ''}s?", item, tag, value)).to be_truthy
end

When(/^I navigate to the study:? "([^"]+)" within the study group:? "([^"]+)"$/) do |study, study_group|
  step %Q{I switch to another study with title: "#{study}"}
  sleep 2
  step %Q{I verify the page "scenario" of app "Study_Design" is displayed}
  sleep 2
  step %Q{I verify the Page title is "Design Optimization" and the Study title is "#{study}"}
  sleep 1
end

When(/^I navigate to the study: "([^"]+)" from the study group: "([^"]+)"$/) do |study, study_group|
  step %Q{I login to "iMedidata" as user "meditaf_09"}
  step %Q{I navigate to "MCCAdmin" for study group "#{study_group}" from iMedidata}
  step %Q{I navigate to "#{study}" Study in "Study Design" study list}
  step %Q{I navigate to "Study Design" page from "Manage Users" page}
  sleep 2
  step %Q{I verify the page "scenario" of app "Study_Design" is displayed}
  sleep 2
  step %Q{I verify the Page title is "Design Optimization" and the Study title is "#{study}"}
end


When(/^I(?: should)? see the following "Buttons" within the "([^"]+)" (?:#{CONTAINER}) with parameters:$/) do |container, table|
  table.hashes.each do |data|
    expect($applications.study_design.send($helpers.to_page_file(container)).has?(data['buttons'], 'button')).to be_truthy
  end
end
