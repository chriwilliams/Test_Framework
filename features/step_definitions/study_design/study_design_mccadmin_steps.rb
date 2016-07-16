And(/^I navigate to iMedidata Study Design page from MCCAdmin "([^"]*)" page$/) do |page|
  $applications.mccadmin.manage_users.navigation.select_action('Study Design')
end

And(/^I navigate to "([^"]*)" Study in "([^"]*)" study list$/) do |study_name, study_app|
  $applications.mccadmin.temp_page_study_design.study_select(study_name)
end

And(/^I navigate to "([^"]*)" page from "Manage (?:Users|Sites)" page$/) do |action|

  case action
    when  /^design optimization$/i
      action = ['utils','apps','studydesign','navigation_app'].reduce($config) {|hash,key| hash && hash[key] }  || action
  end
  $applications.mccadmin.manage_users.navigation.select_action(action)
  sleep 2
end

And(/^I navigate to "([^"]*)" page from left panel side bar$/) do |nav|
  $applications.mccadmin.manage_site_bar.select_nav(nav)
  sleep 1
end

And(/^I (?:move|switch|return back) to\s?(?:another|the) study with title:? "([^"]+)"$/) do |study_name|
  $applications.mccadmin.manage_users.navigation.select_study(study_name)
  sleep 10
end

And /^I update Study with following values:$/ do |table|
  $applications.mccadmin.study_detail.update_study(table.rows_hash)
end
