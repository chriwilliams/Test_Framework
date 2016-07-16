# Common steps
### UI STEPS ###

And(/^I take a screenshot$/) do
  $applications.current_app.current_page.take_screenshot if $applications.current_app
end

And(/^I verify(?: that)?(?: the)? page "([^"]*)" is displayed$/) do |page|
  expect($applications.current_app.send(page.downcase.to_sym)).to be_displayed
end

And(/^I verify (?:the|that) page "([^"]*)" of app "([^"]*)" is displayed$/) do |page, app|
  expect($applications.send(app.downcase.to_sym).send(page.downcase.to_sym)).to be_displayed
end

And(/^I go back to Homepage$/) do
  $applications.current_app.current_page.header.go_home
end

And(/^I Print content "([^"]*)" to shamus output$/) do |text|
  $applications.current_app.current_page.print_to_output(text) if $applications.current_app
end

Given(/^I login to "([^"]*)" as user "(.*?)"$/) do |app, username|
  # username sticky. For scenarios that have users defined in the config file as a sticky
  # if the sticky is not defined then whatever string passed in the step with be the username
  user_name = step %Q{I check if value "#{username}" is a sticky value from the config file}
  password = $config['modules']['ui']['apps'][app.downcase]['users'][user_name.downcase]
  $applications.send(app.downcase.to_sym).login.login(user_name, password)
  step %Q{I verify that I am logged in with username "#{user_name}" in iMedidata} if app.downcase == 'imedidata'
end

And(/^I logout from "([^"]*)"$/) do |app|
  $applications.send($helpers.symbolize_arg(app)).current_page.header.logout
  sleep 5 # single logout is a delayed job, need this wait to ensure the user is fully logged out (i.e. the dj has run)
  if app.downcase == 'imedidata'
    expect($applications.imedidata.login).to have_username
    message = $applications.imedidata.login.get_message
    step %Q{I Print content "MESSAGE: #{message}" to shamus output}
  end
end

And(/^I navigate to iMedidata from "([^"]*)"$/) do |app_name|
  if app_name.downcase.match /coder/
    $applications.coder.task_page.header.switch_to_imedidata
    sleep 5
  elsif app_name.downcase.include? "rave"
    $applications.rave.home.header.goto_imedidata
    sleep 3
  elsif app_name.downcase.include? "mccadmin"
    $applications.mccadmin.all_studies.header.go_home
    sleep 3
  end
end

Given(/^I have the following data set:$/) do |table|
  # table is a table.hashes.keys # => [:Key, :Value]

  print_sticky = $config['utils']['stickies']['print_sticky']
  re = /\<\w+.*\>/

  table.hashes.each do |data|
    key = data['Key']
    value = data['Value']

    r_value = $helpers.randomize_arg(value)

    set_sticky(key, r_value)

    if value =~ re # Check if it has randomize parameter
      if print_sticky
        print_to_output("'#{key}' has a randomized value of '#{r_value}'")
      end
    end
  end
end

And(/^I create a csv spreadsheet at location "([^"]*)" with values below:$/) do |filepath, table|
  data = table.hashes
  $helpers.create_csv(data, filepath)
end

And(/^I wait for "([0-9]+)" seconds$/) do |wait_time|
  sleep (wait_time.to_i)
end

And /^In ([^"]+), ([^"]+) contains the following data:$/ do |app, page, table|
  $applications
      .send($helpers.symbolize_arg(app))
      .send($helpers.to_page_file(page))
      .has?(table.hashes.inject({}) { |data, row| data.merge!(row['Field'] => {value: row['Value'], tag: row['Type']}) })
end

# Check if parameter is a sticky
And(/^I check if value "([^"]*)" is a sticky value from the config file$/) do |parameter|
  # Parameters defined from the config file (If parameter is not defined here and you want to use it then add it
  # to the parameter_list array)
  parameter_list = ['user_name', 'limited_user_name', 'study_group', 'project_name']
  parameter_to_return = ''
  # Check if a parameter is defined as a sticky and get the index of tit from the array first
  param_index = parameter_list.index(parameter)
  # if the parameter index is nil it does not exist as a configurable piece of data and we use the original value input
  if param_index.nil?
    parameter_to_use = parameter
    parameter_to_return = $helpers.randomize_arg(parameter_to_use)
    # if the parameter exist as configurable data then we use it
  elsif param_index >= 0
    parameter_to_use = parameter_list[param_index]
    parameter_to_return = $sticky[parameter_to_use.to_sym]
  end
  parameter_to_return
end

And /^I change locale to "([^"]+)"$/ do |language|
  locale = $locale_config['locale']['apps']['studydesign'][language.downcase]
  url = $applications.current_app.current_page.add_param_to_url(
      $applications.current_app.current_page.current_url,
      'locale',
      locale)
  $applications.current_app.current_page.navigate_to(url)
  sleep 0.01
  $applications.current_app.current_page.wait_for_no_spinner if $applications.current_app.current_page.respond_to? ('wait_for_no_spinner')
  $applications.current_app.current_page.switch_locale(locale) if $applications.current_app.current_page.respond_to? ('switch_locale')
end

And /^I scroll (up|down) the page(?: by (\d+) (?:px|pixels))?$/ do |direction, pixel|
  $applications.current_app.current_page.scroll_on_page({up: true, down: false}[direction.to_sym], pixel)
end

And(/^I close the browser$/) do
  Capybara.current_session.driver.quit
end

And(/^I cleanup feature data$/) do
  remove_all_stickies
end

And(/^I remove the following data keys$/) do |table|
  # table is a table.hashes.keys # => [:Key]
  table.hashes.each do |data|
    key = data['Key']
    remove_sticky(key)
  end
end
