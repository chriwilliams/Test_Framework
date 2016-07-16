When(/^In Minotaur I enter a valid activation code$/) do
  $applications.minotaur.registration_page.set_activation_code($sticky[:activation_code])
end

Then(/^In Minotaur I should see the activate button enabled$/) do
  enabled = $applications.minotaur.registration_page.check_activation_code_enabled
  expect(enabled).to eq(true)
end

Then(/^In Minotaur I should click on activate button$/) do
  $applications.minotaur.registration_page.activate_button.click
end

Then(/^In Minotaur I should click on create account button$/) do
  $applications.minotaur.welcome_tou_page.create_account_button.click
end

Then(/^In Minotaur I should click on I agree button$/) do
  $applications.minotaur.welcome_tou_page.agree_button.click
end

Then(/^In Minotaur I should be able to navigate to the "(.*?)" page$/) do |page|
  page = page.to_sym
  position = {:welcome => 0, :introduction => 1, :email => 2, :password => 3, :security_question => 4}
  row = position[page]
  mapping = [{:welcome => {:page_name => "Welcome to Patient Cloud", :button => "activate"}},
             {:introduction => {:page_name => "Patient Cloud", :button => "create account"}},
             {:email => {:page_name => "Email", :button => "I agree"}},
             {:password => {:page_name => "Password", :button => "next-email"}},
             {:security_question => {:page_name => "Security question", :button => "next-password"}}]

  steps "Then In Minotaur I should see the #{mapping[row][page][:button]} button enabled"
  steps "And In Minotaur I should click on #{mapping[row][page][:button]} button"
  if page==:email
    steps %Q{
    And In Minotaur I should see a confirm dialog with text "Do you agree to the Terms of Use and Data Privacy Notice?"
    And In Minotaur I should click ok dialog button
    }
  end
  steps "Then In Minotaur I should see the \"#{mapping[row][page][:page_name]}\" page"
end

Then(/^In Minotaur I should be able register the user$/) do
  steps "And In Minotaur I should see the create-account button enabled"
  steps %Q{And In Minotaur I should click on create-account button}
end

Then(/^In Minotaur I should see the "(.*?)" page$/) do |header_text|
  text_present=$applications.minotaur.welcome_tou_page.check_header_text(header_text)
  expect(text_present).to eq(true)
end

Then(/^In Minotaur I should click cancel dialog button$/) do
  $applications.minotaur.welcome_tou_page.cancel_dialog
end

Then(/^In Minotaur I should click ok dialog button$/) do
  $applications.minotaur.welcome_tou_page.agree_dialog
end

And(/^In Minotaur I should see a confirm dialog with text "(.*?)"$/) do |dialog_text|
  dialog_value = $applications.minotaur.welcome_tou_page.get_text
  expect(dialog_value).to eq(dialog_text)
end

And(/^In Minotaur I should click on next-email button$/) do
  $applications.minotaur.email_page.click_next_email
end

And(/^In Minotaur I should enter patient confirmation email value$/) do
  $applications.minotaur.email_page.set_email_confirmation($sticky[:email])
end

And(/^In Minotaur I should see the next-email button not enabled/) do
  status = $applications.minotaur.email_page.check_next_email_button_enabled
  expect(status).to eq(false)
end

And(/^In Minotaur I should see the next-email button enabled$/) do
  status = $applications.minotaur.email_page.check_next_email_button_enabled
  expect(status).to eq(true)
end

And(/^In Minotaur I should enter patient email value$/) do
  email = [*('A'..'Z')].sample(8).join
  $sticky[:email] = "#{email}@g.com"
  $applications.minotaur.email_page.set_email($sticky[:email])
end

And(/^In Minotaur I should click on next-password button$/) do
  $applications.minotaur.password_page.click_next_password
end

And(/^In Minotaur I should enter patient password value$/) do
  password = "Password1@"
  $sticky[:password] = password
  $applications.minotaur.password_page.set_password($sticky[:password])
end

And(/^In Minotaur I should see the next-password button not enabled/) do
  status = $applications.minotaur.password_page.check_next_password_button_enabled
  expect(status).to eq(false)
end

And(/^In Minotaur I should see the next-password button enabled$/) do
  status = $applications.minotaur.password_page.check_next_password_button_enabled
  expect(status).to eq(true)
end

And(/^In Minotaur I should enter password confirmation value$/) do
  $applications.minotaur.password_page.set_password_confirmation($sticky[:password])
end

And(/^In Minotaur I should click on create-account button$/) do
  $applications.minotaur.security_question_page.create_account_button.click
end

And(/^In Minotaur I should enter security answer value$/) do
  $applications.minotaur.security_question_page.set_security_answer()
end

And(/^In Minotaur I should see the create-account button not enabled/) do
  status = $applications.minotaur.security_question_page.check_create_account_button_enabled
  expect(status).to eq(false)
end


And(/^In Minotaur I should see the create-account button enabled$/) do
  status = $applications.minotaur.security_question_page.check_create_account_button_enabled
  expect(status).to eq(true)
end

And(/^In Minotaur I should enter security question value$/) do
  $applications.minotaur.security_question_page.set_security_question()
end

Given(/^I navigate to minotaur activate page$/) do
  $sticky[:app]="minotaur"
  $applications.minotaur.registration_page
  enabled = $applications.minotaur.registration_page.check_activation_code_enabled
  expect(enabled).to eq(false)
end

Given(/^I have a valid activation code for a subject$/) do
  steps %Q{
  Given I added a subject in Rave for patient management
  And Activation code exists for a subject
  }
end

Then(/^In Minotaur I should see the message "(.*?)"$/) do |header_text|
  text_present=$applications.minotaur.security_question_page.check_header_text(header_text)
  expect(text_present).to eq(true)
end

And(/^Activation code exists for a subject$/) do
  steps %Q{
  Given I login to patient management as "test_user"
  And In Patient Management I navigate to the study-site page
  When In Patient Management I select study and site
  And In Patient Management I navigate to invite page
  And In Patient Management I enter subject,initials and language
  And In Patient Management I invite the subject
  And In Patient Management I can see activation code in the table
  And In Patient Management I can see that the subject and initials fields are cleared
  And I logout from patient management
  }
end

And(/^I am able to login to "(.*?)"$/) do |app|
  $applications.imedidata.login.login($sticky[:email], $sticky[:password])
  step %Q{I verify that I am logged in with username "#{$sticky[:email]}" in iMedidata}
end

And(/^In Minotaur I press the back arrow$/) do
  $applications.minotaur.security_question_page.press_back_arrow
end

And(/^In Minotaur I should see the create account button enabled$/) do
  enabled = $applications.minotaur.welcome_tou_page.check_create_account_button_enabled
  expect(enabled).to eq(true)
end

And(/^In Minotaur I should see the I agree button enabled$/) do
  enabled = $applications.minotaur.welcome_tou_page.check_agree_button_enabled
  expect(enabled).to eq(true)
end


