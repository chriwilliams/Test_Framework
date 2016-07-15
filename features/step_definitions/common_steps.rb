And(/^I take a screenshot$/) do
  $applications.current_app.current_page.take_screenshot
end

And(/^I verify (?:the|that) page "([^"]*)" is displayed$/) do |page|
  $applications.current_app.send(page.downcase.to_sym).verify_page
end

And(/^I verify (?:the|that) page "([^"]*)" of app "([^"]*)" is displayed$/) do |page, app|
  $applications.send(app.downcase.to_sym).send(page.downcase.to_sym).verify_page
 end

And(/^I verify the (?:link|text) "([^"]*)" is seen$/) do |link|
  $applications.current_app.current_page.verify_link_exists(link)
end

And(/^I verify the (?:link|text) "([^"]*)" is seen on page "([^"]*)"$/) do |link, page|
  $applications.current_app.send(page.downcase.to_sym).verify_link_exists(link)
end

And(/^I verify the (?:link|text) "([^"]*)" is seen on page "([^"]*)"  of app "([^"]*)"$/) do |link, page, app|
  $applications.send(app.downcase.to_sym).send(page.downcase.to_sym).verify_link_exists(link)
end

And(/^I click on "([^"]*)" (?:link|text)$/) do |link|
  $applications.current_app.current_page.click_link(link)
end

And(/^I click on "([^"]*)" (?:link|text) on page "([^"]*)"$/) do |link, page|
  $applications.current_app.send(page.downcase.to_sym).click_link(link)
end

And(/^I click on "([^"]*)" (?:link|text) on page "([^"]*)" of app "([^"]*)"$/) do |link, page, app|
  $applications.send(app.downcase.to_sym).send(page.downcase.to_sym).click_link(link)
end

And(/^I go back to Homepage$/) do
  $applications.current_app.current_page.header.go_home
end

# And(/^I Print content (.*) to shamus output$/) do |text|
#   asset = Shamus.current.current_step.add_inline_asset('.txt', Shamus::Cucumber::InlineAssets::RENDER_AS_TEXT) if defined? Shamus
#   asset ||= "./FirstFramework_run.log"
#   File.open(asset, 'w') {|f| f.puts("#{text}")}
# end

And(/^I store value "(.*)" in "(.*)"$/) do |value, var|
  $sticky["#{var}"] = value
end

And(/^I get value of "(.*)" and print to log$/) do |var|
  step %Q/I Print content "#{var}: #{$sticky["#{var}"]}" to shamus output/
end
