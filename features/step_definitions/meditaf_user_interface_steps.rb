# To do add User interface steps

Given(/^I login to "([^"]*)" as user "(.*?)"$/) do |app, username|
  password = $config['ui']['apps'][app.downcase]['users'][username.downcase]
  $applications.send(app.downcase.to_sym).login.login(username, password)
end

And(/^I logout from "([^"]*)"$/) do |app|
  $applications.send(app.downcase.to_sym).current_page.header.logout
  sleep 5  # single logout is a delayed job, need this wait to ensure the user is fully logged out (i.e. the dj has run)
  if app.downcase == 'imedidata'
    expect($applications.imedidata.login).to have_username
  end
end