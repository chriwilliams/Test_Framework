When /^I select study "([^\"]*)"$/ do |study_name|
  $applications.balance.studies.select_study(study_name)
end

When /^I click subject count for study "([^\"]*)"$/ do |study_name|
  $applications.balance.studies.select_subject_count(study_name)
end

When /^I click site link for study "([^\"]*)"$/ do |study_name|
  $applications.balance.studies.select_site_link(study_name)
end

When /^I click config report for study "([^\"]*)"$/ do |study_name|
  $applications.balance.studies.select_config_report(study_name)
end

When /^I search for studies(?: with name "([^\"]*)")?(?: with study group "([^\"]*)")?(?: with live option "([^\"]*)")?$/ do |study,study_group,live|
  $applications.balance.studies.main_nav.select_main_nav('Study List')
  $applications.balance.studies.search_for_study(study,study_group,live)
end