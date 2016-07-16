When /^In Balance I manually dispense to subject "([^\"]*)" under visit "([^\"]*)", and Article Type "([^\"]*)" with reason "([^\"]*)" dispensing(?: \d+)? "([^\"]*)"$/ do |subject_name, visit_name, article_type, reason, count, item_name|
  step %Q{In Balance I navigate to the Subjects Page}
  $applications.balance.subject_list.subject_select(subject_name)
  $applications.balance.manual_dispense.manual_dispense_button.click
  $applications.balance.manual_dispense.article_type.select(article_type)
  $applications.balance.manual_dispense.visit_name.select(visit_name)
  $applications.balance.manual_dispense.reason.set(reason)
  sleep (2)
  $applications.balance.manual_dispense.manual_dispense_item(item_name, count)
end
