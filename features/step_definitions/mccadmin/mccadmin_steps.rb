And(/^In MCCAdmin navigate to Configuration Roles page and add roles using the values below:$/) do |table|
  table.map_headers! { |header| $helpers.symbolize_arg(header) }
  input = table.hashes
  params = []
  input.each do |param|
    param[:apps] = param[:apps].split(',').map(&:strip)
    param[:roles] = param[:roles].split(',').map(&:strip)
    param[:app_role_hash] = Hash[param[:apps].zip(param[:roles])]
    params << param
  end

  $applications.mccadmin.manage_users.main_nav.select_nav('Manage Roles')
  $applications.mccadmin.roles_configuration.select_configuration_action('Edit Roles')
  $applications.mccadmin.edit_configuration_roles.add_roles(params)

  expect($applications.mccadmin.roles_configuration.main).to have_header_text(text: 'Configurations')
  message = $applications.mccadmin.roles_configuration.main.get_message
  expect(message).to eq("#{params.size} Configuration type role(s) successfully updated.")
  step %Q{I Print content "VERIFIED : #{message}" to shamus output}
end

And(/^In Role Configuration I navigate to app "(.*?)"$/) do |app|
  $applications.mccadmin.roles_configuration.navigation.select_action(app)
end

And(/^In MCCAdmin I create a client division user using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:First, :Last, :Email, :Environment, :Role]
  table.hashes.each do |input|
    params = {}
    params[:first] = get_sticky(input['First'])
    params[:last] = get_sticky(input['Last'])
    params[:email] = get_sticky(input['Email'])
    params[:role] = get_sticky(input['Role'])
    params[:phone] = input['Phone'] ? get_sticky(input['Phone']) : $faker.phone_number.phone_number

    $applications.mccadmin.all_studies.main_nav.select_nav('Manage Users')
    $applications.mccadmin.all_users.click_create_admin_user
    $applications.mccadmin.add_user_to_client_division.add_user(params)
    expect($applications.mccadmin.all_users.main).to have_header_text(text: 'All Users')
    message = $applications.mccadmin.all_users.main.get_message
    expect(message).to include(params[:first], params[:last])
    step %Q{I Print content "VERIFIED:  #{message}" to shamus output}
    step %Q{I take a screenshot}
  end

end

And(/^In MCCAdmin I create a study using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:Protocol ID, :Study Name, :Primary Indication, :Secondary Indication, :Phase,
  #                                    :Configuration Type]
  input = table.transpose.rows_hash
  params = {}

  params['study_protocol_id'] = get_sticky(input['Protocol ID'])
  params['use_protocol_id'] = input['Use Protocol ID']
  params['study_name'] = get_sticky(input['Study Name'])
  params['primary_indication'] = input['Primary Indication']
  params['secondary_indication'] = input['Secondary Indication']
  params['study_phase'] = input['Phase']
  params['configuration_type'] = get_sticky(input['Configuration Type'])
  params['test_study'] = input['Test Study']

  $applications.mccadmin.all_studies.main_nav.select_nav('Manage Studies')
  expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Studies')

  # first check to see if study table is empty (when empty the search does not exist)
  if page.first('#search-list-form') != nil
    # recycle study if it already exists
    step %Q{In MCCAdmin I recycle study "#{params['study_name']}"}
  end

  $applications.mccadmin.all_studies.create_study_button.click
  expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Create Study')
  $applications.mccadmin.create_study.create_study(params)
  message = $applications.mccadmin.manage_users.main.get_message
  expect(message).to include(params['study_name'])
  step %Q{I Print content "VERIFIED: #{message}" to shamus output}

end

And (/^In MCCAdmin I add new user to study "(.*?)" using the value below:$/) do |study_arg, table|
  # table is a table.hashes.keys # => [:First, :Last, :Email, :Environment, :Roles, :Sites]
  table.hashes.each do |input|
    params = {}
    params[:email] = get_sticky(input['Email'])
    params[:first_name] = get_sticky(input['First'])
    params[:last_name] = get_sticky(input['Last'])
    params[:environment] = input['Environment'].split(',').map(&:strip)

    params[:roles] = []
    input['Roles'].split(',').each do |role|
      params[:roles] << get_sticky(role.strip)
    end

    if input['Sites']
      params[:sites] = []
      input['Sites'].split(',').each do |site|
        params[:sites] << get_sticky(site.strip)
      end
    end

    header = $applications.mccadmin.manage_users.main.get_page_header
    if header != "Manage Users"
      $applications.mccadmin.manage_users.main_nav.select_nav("Manage Users")
    end

    $applications.mccadmin.manage_users.add_user_dd.click
    $applications.mccadmin.manage_users.add_new_user.click
    $applications.mccadmin.add_users.add_user_personal_info(params[:email], params[:first_name], params[:last_name])
    $applications.mccadmin.add_users.add_env_role_site(params[:environment], params[:roles], params[:sites])
    $applications.mccadmin.add_users.add_user_submit
    expect($applications.mccadmin.manage_users.main).to have_header_text(text: 'Manage Users')
    message = $applications.mccadmin.manage_users.main.get_message
    expect(message).to include(params[:first_name], params[:last_name])
    expect(message).to include("successfully added to the study")
    step %Q{I Print content "VERIFIED: #{message}" to shamus output}
    step %Q{I take a screenshot}
  end

end

And(/^In MCCAdmin I create study site using the values below:$/) do |table|

  # table is a table.hashes.keys # => [:Site Name, :Client Division Site Number, :Site Number, :Street Address, :Zip, :City, :Country, :State, :Study Environment, :Principal Investigator Email, :Principal Investigator First Name, :Principal Investigator Last Name, :Principal Investigator Role]
  table.hashes.each do |input|
    params = {}
    params['site_name'] = get_sticky(input['Site Name'])
    params['client_division_site_number'] = get_sticky(input['Client Division Site Number'])
    params['site_number'] = get_sticky(input['Site Number'])
    params['address_1'] = input['Street Address'].empty? ? $faker.address.street_address : input['Street Address']
    params['zip_code'] = input['Zip'].empty? ? $faker.address.zip_code : input['Zip']
    params['city'] = input['City'].empty? ? $faker.address.city : input['City']
    params['country'] = input['Country'].empty? ? $faker.address.country : input['Country']
    params['state'] = input['State'].empty? ? $faker.address.state : input['State']
    params['study_env'] = input['Study Environment']
    params['pi_email'] = get_sticky(input['Principal Investigator Email'])
    params['pi_first_name'] = get_sticky(input['Principal Investigator First Name'])
    params['pi_last_name'] = get_sticky(input['Principal Investigator Last Name'])
    params['pi_role'] = get_sticky(input['Principal Investigator Role'])

    header = $applications.mccadmin.manage_users.main.get_page_header
    if header != "Manage Sites"
      $applications.mccadmin.manage_users.main_nav.select_nav("Manage Sites")
    end

    $applications.mccadmin.manage_sites.add_new_site.click
    $applications.mccadmin.add_study_sites.add_new_site.click

    $applications.mccadmin.add_new_study_site.add_site(params)
    expect($applications.mccadmin.manage_sites.main).to have_header_text(text: 'Manage Sites')
    message = $applications.mccadmin.manage_sites.main.get_message
    expect(message).to include(params['site_number'])
    step %Q{I Print content "VERIFIED: #{message}" to shamus output}
    step %Q{I take a screenshot}
  end

end

And(/^In MCCAdmin I assign user to site using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:User Email, :Environment, :Site Name]
  table.hashes.each do |input|
    params = {}
    params[:user_email] = get_sticky(input['User Email'])
    params[:environment] = input['Environment']
    params[:site_name] = get_sticky(input['Site Name'])

    header = $applications.mccadmin.manage_users.main.get_page_header
    if header != "Manage Users"
      $applications.mccadmin.manage_users.main_nav.select_nav("Manage Users")
    end

    $applications.mccadmin.manage_users.search_and_select_user('All', params[:user_email])
    $applications.mccadmin.user_details.assign_site_to_user('All', params)
    expect($applications.mccadmin.user_details).to have_assign_button(text: 'Unassign')
    step %Q{I Print content "VERIFIED: User with email: #{params[:user_email]} has been assigned to site: #{params[:site_name]}" to shamus output}
    step %Q{I take a screenshot}
  end

end

And(/^I navigate to Client Division Users page and remove an admin user(?: with email "([^"]*)")?$/) do |user_email|
  $applications.mccadmin.all_studies.main_nav.select_nav('Manage Users')
  email = user_email==nil ? $sticky[:admin_user_email] : user_email

  $applications.mccadmin.all_users.search.search_by('All', email)
  $applications.mccadmin.all_users.remove_client_division_user
  message = $applications.mccadmin.all_users.main.get_message
  step %Q{I Print content "VERIFIED:  #{message}" to shamus output}

  sleep 5 # the action of removing a role assignment happens in delayed job, therefore we need to wait to ensure dj has completed
end

And(/^I navigate to Configure Roles page and remove the following roles "([^"]*)"$/) do |roles|
  $applications.mccadmin.manage_users.main_nav.select_nav('Manage Roles')
  $applications.mccadmin.roles_configuration.select_configuration_action('Edit Roles')
  $applications.mccadmin.edit_configuration_roles.remove_roles(roles)
end

And(/^I navigate to "(.*?)" page from All Studies page$/) do |action|
  $applications.mccadmin.all_studies.navigation.select_action(action)
end

And(/^I navigate to "(.*?)" page from Manage (?:Users|Sites) page$/) do |action|
  $applications.mccadmin.manage_users.navigation.select_action('Edit Study')
  expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Study Detail')
end

Given(/^In MCCAdmin I navigate to "(.*?)" page from Manage (?:Users|Sites) page$/) do |arg1, arg2|
  $applications.mccadmin.manage_users.navigation.select_action('Upload Sites')
end

Given(/^In MCCAdmin I navigate to "(.*?)" page$/) do |page|
  $applications.mccadmin.manage_users.main_nav.select_nav(page)
end

Given(/^I create a csv spreadsheet named "([^"]*)" with values below:$/) do |filename, table|
  table = table.transpose.hashes

  table.each do |row|
    row.keys.each do |key|
      row[key] = $helpers.randomize_arg(row[key])
    end
  end
  filepath = File.join(Dir.pwd, filename)
  $helpers.create_csv(table, filepath)
end

And(/^In MCCAdmin I upload a site csv spreadsheet named "(.*?)" from the upload sites page$/) do |filename|
  filepath = File.join(Dir.pwd, filename)
  $applications.mccadmin.sites_upload.bootstrap_attach_file(filepath)
  $applications.mccadmin.sites_upload.upload_file_button.click

  $applications.mccadmin.sites_upload.field_mapping_confirmation_button.click
  $applications.mccadmin.sites_upload.add_site_now
end


And(/^In MCCAdmin I upload a user csv spreadsheet named "(.*?)" from the upload users page$/) do |filename|
  filepath = File.join(Dir.pwd, filename)
  $applications.mccadmin.users_upload.bootstrap_attach_file(filepath)
  $applications.mccadmin.users_upload.upload_file_button.click

  $applications.mccadmin.users_upload.field_mapping_confirmation_button.click
  $applications.mccadmin.users_upload.add_user_now
end

And(/^In MCCAdmin I verify the values for the following Users:$/) do |table|

  input = table.transpose.hashes

  params = {}
  input.each do |data|
    params[:email] = $helpers.randomize_arg(data['Email'])
    params[:first_name] = data['First Name']
    params[:last_name] = data['Last Name']
    params[:role] = data['Role']
    params[:environment] = data['Environment']
    params[:phone_number] = data['Phone Number']
    params[:site] = data['Site']
  end

  user = params[:email]
  $applications.mccadmin.manage_users.search_and_select_user('All', user)

  step %Q{I take a screenshot}
end

Given(/^I search for Site "(.*?)" in MCCAdmin$/) do |site|
  $applications.mccadmin.manage_sites.search_and_select_site('All', site)
end

And(/^In MCCAdmin I verify the values for the following Sites:$/) do |table|
  input = table.transpose.hashes

  input.each do |data|
    site = data['Medical Facility Name']
    $applications.mccadmin.manage_sites.search_and_select_site('All', site)

    mf_name = $applications.mccadmin.sites_details.mf_name.text
    expect(mf_name).to include(data['Medical Facility Name'])

    cd_number = $applications.mccadmin.sites_details.cd_site_number.text
    expect(cd_number).to include($helpers.randomize_arg(data['Client Division Site Number']))

    site_number = $applications.mccadmin.sites_details.ses_site_number.value
    expect(site_number).to include($helpers.randomize_arg(data['Study Environment Site Number']))

    email = $applications.mccadmin.sites_details.pi_email.text
    expect(email).to include($helpers.randomize_arg(data['PI Email Address']))

    piname = $applications.mccadmin.sites_details.site_pi_name.text
    expect(piname).to include(data['PI First Name'])
    expect(piname).to include(data['PI Last Name'])

    address = $applications.mccadmin.sites_details.address.text
    expect(address).to include(data['Street Address'])
    expect(address).to include(data['City'])
    expect(address).to include(data['Postal Code'])

    step %Q{I take a screenshot}
    $applications.mccadmin.sites_details.cancel_ses.click
  end
end


And(/^I lock the study and esign as user "(.*?)"$/) do |username|
  password = $config['modules']['ui']['apps']['imedidata']['users'][username.downcase]
  $applications.mccadmin.study_detail.lock_study(username, password)
  expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Studies')
  message = $applications.mccadmin.all_studies.main.get_message
  expect(message).to include($sticky[:protocol_id])
  step %Q{I Print content "VERIFIED:  #{message}" to shamus output}
end

And(/^I activate the study as user "(.*?)"$/) do |username|
  $applications.mccadmin.study_detail.activate_study
  expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Studies')
  message = $applications.mccadmin.all_studies.main.get_message
  expect(message).to include($sticky[:protocol_id])
  step %Q{I Print content "VERIFIED:  #{message}" to shamus output}
end

And(/^I verify user cannot be added in Manage Users page$/) do
  $applications.mccadmin.all_studies.search_and_select_study('All', $sticky[:study])
  expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Manage Users')
  using_wait_time 3 do
    expect($applications.mccadmin.manage_users).not_to have_add_user_dd
  end
end

And(/^I navigate to All Studies page, (lock|unlock|deactivate|activate) the study "(.*?)" and esign as user "(.*?)"$/) do |action, study, username|
  password = $config['modules']['ui']['apps']['imedidata']['users'][username.downcase]
  if $applications.mccadmin.manage_users.main.get_page_header.include?('Manage Users')
    $applications.mccadmin.manage_users.navigation.select_study('All Studies')
  end
  $applications.mccadmin.all_studies.search.search_by('All', $sticky[:study])
  $applications.mccadmin.all_studies.select_study_settings(action)
  $applications.mccadmin.all_studies.perform_action_and_esign(action, username, password)
end

And(/^I navigate to MCCAdmin home page$/) do
  $applications.mccadmin.manage_users.header.select_admin
end

And(/^I navigate to "([^"]*)" Study in RaveX study list$/) do |study_name|
  $sticky[:study] = study_name unless $sticky.has_key?(:study)
  $applications.mccadmin.temp_page.study_select($sticky[:study])
end

And(/^I navigate to "([^"]*)" environment in RaveX environments list$/) do |env|
  $sticky[:env] = env unless $sticky.has_key?(:env)
  $applications.mccadmin.temp_page.env_select($sticky[:env])
end

And(/^I navigate to "([^"]*)" Site in RaveX Sites list$/) do |site_name|
  $sticky[:site_name] = site_name unless $sticky.has_key?(:site_name)
  $applications.mccadmin.temp_page.site_select($sticky[:site_name])
end

And(/^I navigate to "([^"]*)" from the Actions in MCCAdmin$/) do |action|
  $applications.mccadmin.temp_page.navigation.select_action(action)
end

And(/^I remove the following roles "([^"]*)"$/) do |roles|
  $applications.mccadmin.roles_configuration.select_configuration_action('Edit Roles')
  $applications.mccadmin.edit_configuration_roles.remove_roles(roles)
end

Then(/^I search for study "([^"]*)" in MCCAdmin$/) do |study_arg|
  study_name = get_sticky(study_arg)

  header = $applications.mccadmin.manage_users.main.get_page_header
  if header != "Manage Studies"
    $applications.mccadmin.manage_users.main_nav.select_nav("Manage Studies")
  end

  $applications.mccadmin.all_studies.search_and_select_study('All', study_name)
end

Then(/^I (?:log out|logout) (?:from|of) (?:mccadmin|MCCAdmin)$/) do
  $applications.mccadmin.all_studies.header.logout
end

Then(/^I go to home page$/) do
  $applications.mccadmin.all_studies.navigation.go_home
end

Then(/^I select study group option for "([^"]*)"$/) do |study_group|
  $applications.mccadmin.all_studies.navigation.select_client_division(study_group)
end


Then /^In MCCAdmin I select environment "([^"]*)" from the filter group$/ do |environment|
  $applications.mccadmin.manage_sites.env_filter.select_environment(environment)
end

Then /^In MCCAdmin I select study "([^"]*)" from the study list table$/ do |study_name|
  $applications.mccadmin.all_studies.search_and_select_study("All", study_name)
end

And(/^In MCCAdmin I select the client division header$/) do
  $applications.mccadmin.manage_users.navigation.client_divisions_menu.click
end

Then /^In MCCAdmin I recycle study "([^"]*)"$/ do |study_name|
  new_name = "Recycled_#{rand(999999999)}"
  index = $applications.mccadmin.all_studies.search_study("Name", study_name)

  if index
    $applications.mccadmin.all_studies.search_and_select_study("Name", study_name)
    step %Q{In MCCAdmin I navigate to "Manage Study" page}
    $applications.mccadmin.study_detail.name.set new_name
    $applications.mccadmin.study_detail.protocol_id.set new_name
    $applications.mccadmin.study_detail.save_button.click
  end

end

Then /^In MCCAdmin I update study site number to "([^"]*)" for site "([^"]*)"$/ do |new_num, site_name|
  $applications.mccadmin.manage_users.main_nav.select_nav("Manage Sites")
  $applications.mccadmin.manage_sites.search_and_select_site("All", site_name)
  $applications.mccadmin.sites_details.update_study_site_num(new_num)
end

And(/^I add a new configuration role with the following data:$/) do |table|
  table.map_headers! { |header| $helpers.symbolize_arg(header) }
  input = table.hashes
  params = []
  input.each do |param|
    param[:apps] = param[:apps].split(',').map(&:strip)
    param[:permissions] = param[:permissions].split(',').map(&:strip)
    params << param
  end

  $applications.mccadmin.roles_configuration.select_configuration_action('Edit Roles')
  $applications.mccadmin.edit_configuration_roles.edit_configuration_roles(params)

end
