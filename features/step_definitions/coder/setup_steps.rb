And(/^I navigate to "([^"]*)" page from Admin list$/) do |page|
  $applications.coder.task_page.navigation.navigate_to_page page
  sleep 2
end


And(/^I select segment "([^"]*)"$/) do |segment|
  $applications.coder.setup.select_seg segment
end

And(/^I navigate to Admin page "([^"]*)" for segment "([^"]*)"$/) do |page, segment|
  $applications.coder.task_page.verify_coder_is_loaded
  $applications.coder.task_page.select_seg segment
  sleep 2
  $applications.coder.task_page.navigation.navigate_to_page page
  sleep 2
end


And(/^I select segment "([^"]*)" and dictionary "([^"]*)"$/) do |segment, dictionary|
  $applications.coder.setup.select_seg_n_dict segment , dictionary
  sleep 4
end

And(/^I find the number of pages pagination$/) do
  $applications.coder.setup.select_dictionary_to_roll_out 'WhoDrugDDC (eng)'
  $applications.coder.setup.page_count
end


And(/^I add a license key with the following data:$/) do |table|
  table.hashes.each do |input|
    license_code = input['License Code']
    start_date = input['Start Date']
    end_date = input['End Date']
    #$applications.coder.setup.select_seg_n_dict
    $applications.coder.setup.add_license(license_code, start_date, end_date)
    sleep 5
  end
end

And(/^I roll out all version for dictionary "([^"]*)" from the first page$/) do |dictionary|
  if dictionary.include? 'WhoDrug'
    versions = [200703, 200706, 200709, 200712, 200803, 200806, 200809, 200812, 200903, 200906, 200909, 200912, 201003, 201006, 201009, 201012, ]
  else
    case dictionary.downcase
      when 'AZDD (eng)'.downcase
        versions = [13.2, 13.1, 12.2, 12.1, 11.2, 11.1, 10.2, 10.2, 9.2, 9.1]
      when 'MedDRA (eng)'.downcase
        versions = [11.0, 11.1, 12.0, 12.1, 13.0, 13.1, 14.0, 14.1, 15.0, 15.1, 16.0, 16.1]
      when 'MedDRA (jpn)'.downcase
        versions = [11.0, 11.1, 12.0, 12.1, 13.0, 13.1, 14.0, 14.1, 15.0, 15.1, 16.0, 16.1]
      when 'JDrug (eng)'.downcase
        versions = ['2011H1', '2011H2', '2012H1', '2012H2', '2013H1']
      when 'JDrug (jpn)'.downcase
        versions = ['2011H1', '2011H2', '2012H1', '2012H2', '2013H1']
      else
        raise "Dictionary with name: #{dictionary} is not recognized. Cannot roll out dictionaries for unrecognized dictionary name."
    end

  end
  $applications.coder.setup.select_dictionary_to_roll_out dictionary
  sleep 3
  versions.each do |version|
    $applications.coder.setup.roll_out_version version.to_s
    sleep 5
  end

end

And(/^I roll out the following dictionaries with the associated data:$/) do |table|
  table.hashes.each do |inputs|
    @dict = inputs['Dictionary']
    @version = inputs['Version']
    puts "looking for version #{@version}"
    $applications.coder.setup.select_dictionary_to_roll_out @dict
    $applications.coder.setup.roll_out_version @version
  end
end

And(/^I roll out dictionary "([^"]*)" with version "([^"]*)"$/) do |dictionary, version|
  $applications.coder.setup.select_dictionary_to_roll_out dictionary
  $applications.coder.setup.roll_out_version version
end

And(/^I enroll a new segment named "([^"]*)" in Coder application$/) do |segment|
  $applications.coder.segment_management.add_new_segment segment
  sleep 6
end

And(/^I create and assign workflow role named "([^"]*)" on Workflow page$/) do |workflow_name|
  $applications.coder.task_page.navigation.navigate_to_page 'Create Workflow Role'
  $applications.coder.create_workflow_role.create_workflow workflow_name
  $applications.coder.create_workflow_role.assign_workflow_role workflow_name
end

And(/^I assign a workflow role to user "([^"]*)" with role "([^"]*)" for "([^"]*)"$/) do |user, role, study|
  $applications.coder.task_page.navigation.navigate_to_page 'Assign Workflow Role'
  $applications.coder.assign_workflow_role.assign_workflow_role(user, study, role)
  sleep 3
end

And(/^I create and assign general role named "([^"]*)" for security module "([^"]*)"$/) do |general_role_name, sec_module|
  $applications.coder.task_page.navigation.navigate_to_page 'Create General Role'
  $applications.coder.assign_general_role.select_security_module sec_module
  $applications.coder.create_general_role.create_general_role general_role_name
  $applications.coder.create_general_role.assign_general_role general_role_name
end

And(/^I assign a general page study role to user "([^"]*)" for module "([^"]*)" with role "([^"]*)" for "([^"]*)"$/) do |user ,sec_module, role, study|
  $applications.coder.task_page.navigation.navigate_to_page 'Assign General Role'
  $applications.coder.assign_general_role.select_security_module sec_module
  $applications.coder.assign_general_role.assign_general_study_role(user, study, role)
  sleep 3
end


And(/^I assign a general page dictionary role to user "([^"]*)" for module "([^"]*)" with role "([^"]*)" for dictionary "([^"]*)"$/) do |user ,sec_module, role, dict|
  $applications.coder.task_page.navigation.navigate_to_page 'Assign General Role'
  $applications.coder.assign_general_role.select_security_module sec_module
  $applications.coder.assign_general_role.assign_general_dict_role(user, dict, role)
  sleep 3
end
