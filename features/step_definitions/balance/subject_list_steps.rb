When /^In Balance I select the subject treatment report$/ do
  step %Q{In Balance I navigate to the Subjects Page}
  $applications.balance.subject_list.subject_treatment_report.select
end

When /^In Balance I select the subject distribution report$/ do
  step %Q{In Balance I navigate to the Subjects Page}
  $applications.balance.subject_list.subject_distribution_report.select
end

When /^In Balance I download a subject list$/ do
  step %Q{In Balance I navigate to the Subjects Page}
  $applications.balance.subject_list.subject_download_list.click
end

Then /^In Balance I search for subject "([^\"]*)"$/ do |subject_id|
  step %Q{In Balance I navigate to the Subjects Page}
  $applications.balance.subject_list.search_subject(get_sticky(subject_id))
end

Then /^In Balance I select the subject "([^\"]*)"$/ do |subject_id|
  step %Q{In Balance I navigate to the Subjects Page}
  $applications.balance.subject_list.subject_select(get_sticky(subject_id))
end
