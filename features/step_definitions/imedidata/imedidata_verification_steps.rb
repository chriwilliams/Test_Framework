And(/^I verify user does not have access to study group "([^"]*)"$/) do |study_group|
  $applications.imedidata.home.search_by(:study, study_group)
  using_wait_time 3 do
    expect($applications.imedidata.home).not_to have_study_groups_in_search_result(text: study_group)
  end
end

And(/^I verify the course "([^"]*)" is (|not )blocking app access for (study|study group) "(.*?)"$/) do |course, option, search_term, name|
  name = $helpers.sticky_exist?(name, name)
  step %Q{I search for #{search_term} "#{name}"}
  if option.strip.empty?
    expect($applications.imedidata.home.course_link.first.text).to include(course)
    message = $applications.imedidata.home.course_link.first.text
    step %Q{I Print content "VERIFIED: #{message}" to shamus output}
  else
    expect($applications.imedidata.home.apps_in_search_result).not_to include(course)
    step %Q{I Print content "VERIFIED: #{course} link not found for #{search_term} #{name}" to shamus output}
  end
end

And(/^I verify the following apps can be accessed for (study|study group|site) "(.*?)":$/) do |search_term, name, table|
  input = table.transpose.rows_hash
  name = $helpers.sticky_exist?(name, name)
  apps = []
  input['Apps'].split(',').map(&:strip).each { |item| apps << $helpers.sticky_exist?(item, item) }

  step %Q{I search for #{search_term} "#{name}"}
  apps_list_in_page = $applications.imedidata.home.get_apps_list

  apps.each do |item|
    expect(apps_list_in_page).to include(item)
  end

end

And(/^I verify that I am logged in with username "(.*?)" in iMedidata$/) do |user_name|
  expect($applications.imedidata.home.header.get_edit_user_link).to include(user_name)
  message = $applications.imedidata.home.flash_notice.get_message
  step %Q{I Print content "VERIFIED: #{message}" to shamus output}
end

And(/^I should be on the iMedidata User Agreement page$/) do
  expect($applications.imedidata.user_agreement).to have_username
end

And(/^I verify I am on the iMedidata User Activation page$/) do
  expect($applications.imedidata.account_activation).to have_username
end

Then(/^I should be on the iMedidata Home page$/) do
  expect($applications.imedidata.home).to have_sites_link
end

And(/^I verify the activation page has the user email "([^"]*)"$/) do |email_arg|

  email = get_sticky(email_arg)

  #Retry once block for fetching exact email. TODO: Should be replaced once gmail enhanced API is utilized ~MD
  unless $applications.imedidata.account_activation.get_user_email.include?(email)
    sleep 60
    steps %Q{
    Given I have the iMedidata user activation link in email
    And I navigate to the iMedidata User Activation page
    And I verify I am on the iMedidata User Activation page
    And I verify the activation page has the user email "#{email}"
  }
  end
  expect($applications.imedidata.account_activation.get_user_email).to include(email)
end

And(/^I verify the notification message "([^"]*)"$/) do |msg|
  $applications.imedidata.manage_study.notifications.verify_notification(msg)
end
