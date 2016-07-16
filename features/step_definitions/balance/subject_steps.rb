Then /^In Balance I unblind subject "([^\"]*)" with reason "([^\"]*)"$/ do |sub_name,reason|
  step %Q{In Balance I navigate to the Subjects Page}
  $applications.balance.subject_list.subject_select(get_sticky(sub_name))
  $applications.balance.subject.unblind_subject(reason)
end
