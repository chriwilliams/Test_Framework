Given(/^I added a subject in Rave for patient management$/) do
  study_name = $config['utils']['apps']['patient_management']['study']
  site_name = $config['utils']['apps']['patient_management']['site']
  step 'I login to "rave" as user "defuser"'
  steps %Q{
    Then I navigate to study "#{study_name}" and site "#{site_name}" in Rave
    }
  field_name = $config['utils']['apps']['patient_management']['field_name']
  step 'I add a subject in Rave with the following data:', table(%{
  | Field Name    | Type | Value |
  | #{field_name}: | text | 1_<r7> |  })
  step 'I logout from "rave"'
end

When(/^In Patient Management I navigate to the study-site page$/) do
  sleep 2
end

And(/^I login to patient management as "(.*?)"$/) do |username|
  $applications.current_app.current_page.maximize_browser
  $applications.minotaur.invite_page
  $applications.minotaur.invite_page.enter_user_name(username)
  password = $config['ui']['apps']['patient_management']['users'][username]
  $applications.minotaur.invite_page.enter_password(password)
  $applications.minotaur.invite_page.login_button.click
end

And(/^In Patient Management I select study and site$/) do
  $applications.minotaur.invite_page.select_study($sticky[:study_name])
  $applications.minotaur.invite_page.select_site($sticky[:site_name])

end

And(/^In Patient Management I navigate to invite page$/) do
  $applications.minotaur.invite_page.launch_button.click
  sleep 8
end

And(/^In Patient Management I enter subject,initials and language$/) do
  $applications.minotaur.invite_page.select_subject($sticky[:subject_id].downcase)
  $applications.minotaur.invite_page.select_country_language
  $applications.minotaur.invite_page.set_initials
  $applications.minotaur.invite_page.get_previous_activation_code
  Capybara.default_wait_time = 5
end

And(/^In Patient Management I invite the subject$/) do
  $applications.minotaur.invite_page.invite_button.click
  sleep 14
end

Then(/^In Patient Management I can see activation code in the table$/) do
  $sticky[:activation_code] = $applications.minotaur.invite_page.get_activation_code
  $applications.minotaur.invite_page.validate_invite($sticky[:activation_code])
  #Assign subject id as nil, hence new to be created
  $sticky[:subject_id] = ""
end

And(/^In Patient Management I can see that the subject and initials fields are cleared$/) do
  $applications.minotaur.invite_page.check_subject_initials_empty
end

And(/^I logout from patient management$/) do
  $applications.minotaur.invite_page.logout
  sleep 5 # single logout is a delayed job, need this wait to ensure the user is fully logged out (i.e. the dj has run)
end
