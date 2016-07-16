And(/^In iMedidata I create a study group using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:Name, :OID, :Apps, :Courses, :Access MCCAdmin]
  input = table.transpose.rows_hash
  params = {}
  apps = []

  params['name'] = get_sticky(input['Name'])
  params['oid'] = get_sticky(input['OID'])
  if input['Apps']
    input['Apps'].split(',').map(&:strip).each { |item| apps << item }
    params['apps'] = apps
  end

  params['courses'] = input['Courses'].split(',').map(&:strip) unless input['Courses'].empty?
  params['is_mccadmin_only'] = input['Access MCCAdmin']

  $applications.imedidata.home.header.go_to_admin_page
  $applications.imedidata.admin.load_admin_page_for(:study_groups)
  $applications.imedidata.study_groups_administration.go_to_study_group_creation
  $applications.imedidata.create_new_study_group.create_study_group(params)
  sg_name = $applications.imedidata.create_new_study_group.get_study_group_title[:name]
  expect(sg_name).to eq(params['name'])
  message = $applications.imedidata.current_page.flash_notice.get_message
  step %Q{I Print content "MESSAGE: #{message}" to shamus output}
end

And(/^the user with email "([^"]*)" for study group "([^"]*)" activates the account using the required values below:$/) do |email_arg, study_arg, table|
  # table is a table.hashes.keys # => [:Username, :First, :Last, :Phone, :Select Timezone, :Select Locale, :Password, :Security Question, :Answer]
  sleep 60
  email = get_sticky(email_arg)
  study_group = get_sticky(study_arg)
  steps %Q{
    Given I have the iMedidata user activation link in email for study group "#{study_group}"
    And I navigate to the iMedidata User Activation page
    And I verify I am on the iMedidata User Activation page
    And I verify the activation page has the user email "#{email}"
  }
  step "I enter in the following required iMedidata User Activation fields:", table
  steps %Q{
    When I click on Activate button
    And I should be on the iMedidata Login page
    And I login to iMedidata with Activated User
    And I should be on the iMedidata User Agreement page
    When I acknowledge the User Agreement page
  }
  expect($applications.imedidata.home.header).to have_edit_user_link(text: "#{get_sticky(:activated_user_name)}")
end

Then(/^I complete the course "([^"]*)" for (study|study group) "([^"]*)" and e-sign$/) do |link, option, study|

  option = $helpers.symbolize_arg(option)
  $sticky[option] = $sticky.has_key?(option) ? $sticky[option] : $helpers.randomize_arg(study)
  params = {}
  params[:username] = $sticky[:user_name]
  params[:password] = $sticky[:user_password]
  params[:study] = $sticky[option]

  $applications.imedidata.home.search_by(:study, $sticky[option])
  $applications.imedidata.home.complete_course_and_esign(link, params)
  $applications.imedidata.home.go_to_elearning_page
  status = $applications.imedidata.elearning_courses.verify_course_status(link)
  expect(status).to eq('Completed')
  $applications.imedidata.home.header.go_home
end

And(/^I navigate to "([^"]*)" for (study group|study) "([^"]*)" using the "(Study Group Launcher|Study Link|Study Launcher|App Launcher)" in iMedidata$/) do |app, option, name, process|
  case process.downcase
    when "study group launcher"
      case option.downcase
        when "study group"
          $applications.imedidata.study_launcher.select_item(study_group: name)
      end

      case app.downcase
        when 'mccadmin'
          sleep 5
          expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Studies') if option.to_s.downcase.include? 'study group'
      end
    when "study link"
      $applications.imedidata.home.select_item_in_view(study_link: name)
    when "study launcher"
      $applications.imedidata.home.select_item_in_view(study: name)
    when "app launcher"
      $applications.imedidata.home.select_item_in_view(app_launcher: name, app: app, option: option)
  end

end

And(/^In iMedidata I navigate to "([^"]*)" for (study group|study) "([^"]*)"$/) do |app, option, name|

  st_name = get_sticky(name)
  $applications.imedidata.study_groups_administration.header.go_home
  $applications.imedidata.home.search_by(:study, st_name)

  case app.downcase
    when 'mccadmin'
      sleep 5
      $applications.imedidata.home.select_item_from_search_results(st_name)
      if option.to_s.downcase.include? 'study group'
        expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Studies')
      else
        expect($applications.mccadmin.all_studies.main).to have_header_text(text: 'Manage Users')
      end
    when 'rave', 'edc'
      $applications.imedidata.home.select_item_from_search_results(app)
    when 'coder'
      $applications.imedidata.home.select_item_by_partial_match(:app, app)
    when 'rave edc', 'rave modules'
      $applications.imedidata.home.select_item_by_partial_match(:app, app)
      sleep 3
    when 'validationportal'
      sleep 2 # waiting for the search to be complete and page to load completely
      $applications.imedidata.home.select_item_by_partial_match(:app, st_name)
    else
      raise "No #{app} application found for #{st_name}"
  end

end

#TODO: Update accordingly when using this step
And(/^I create new course using the values below:$/) do |table|
  input = table.transpose.rows_hash
  @course_name = $faker.stringify(input['Course Name'], $faker.timestamp_short)

  create_course_params = {}
  create_course_params['name'] = @course_name
  create_course_params['oid'] = input['Course OID']
  create_course_params['description'] = input['Description']
  create_course_params['passing_score'] = input['Passing Score']
  create_course_params['prereq'] = input['Prerequisite']
  create_course_params['locale'] = input['Locale']
  create_course_params['duration'] = input['Duration']

  dir = $config['utils']['apps']['imedidata']['upload_dir'] unless $config['utils']['apps']['imedidata']['upload_dir'].nil?

  UploadHelper.set(dir)
  create_course_params['course_file'] = File.join(UploadHelper.path, input['Course File'])

  $applications.imedidata.home.header.go_to_admin_page
  $applications.imedidata.admin.load_admin_page_for(:courses)
  $applications.imedidata.courses_administration.go_to_course_creation
  $applications.imedidata.new_course.create_course(create_course_params)
end

And(/^I map the course using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:Course, :Apps, :Role]
  input = table.transpose.rows_hash
  param = {}
  param[:course] = input['Course']
  param[:app] = $helpers.sticky_exist?(input['Apps'], input['Apps'])
  param[:role] = $helpers.sticky_exist?(input['Roles'], input['Roles'])
  $applications.imedidata.manage_study_group.add_mapping(param)
  message = $applications.imedidata.current_page.flash_notice.get_message
  step %Q{I Print content "MESSAGE: #{message}" to shamus output}
end

# TODO: Deprecated - Remove when all instances replaced with new Invites Section
And(/^I perform actions for invitations in iMedidata using the values below:$/) do |table|
  table.map_headers! { |header| $helpers.symbolize_arg(header) }
  input = table.hashes
  params = []
  input.each do |param|
    param[:name] = $helpers.sticky_exist?(param[:name], param[:name])
    param[:environment] = param[:environment].split(',').map(&:strip) if param[:environment]
    param[:invitation] = param[:invitation].split(',').map(&:strip)
    params << param
  end
  $applications.imedidata.home.accept_or_decline_invitation(params)
end

And(/^I navigate to MCCAdmin "([^"]*)" page from iMedidata Manage Study Group page$/) do |page|
  if $helpers.symbolize_arg(page).to_s.include? "all_studies"
    $applications.imedidata.manage_study_group.select_sg_tab(:studies)
  elsif $helpers.symbolize_arg(page).to_s.include? "all_users"
    $applications.imedidata.manage_study_group.select_sg_tab(:users)
  else
    raise "No option declared to access #{page} page!"
  end
end

And(/^I have the iMedidata user activation link in email for (study|study group) "([^"]*)"$/) do |option, sg_arg|
  sleep 10

  imedidata_addr = $config['modules']['utils']['gmail']['gmail_imd_addr']
  gusername = $config['modules']['utils']['gmail']['gmail_user_addr']
  gpassword = $config['modules']['utils']['gmail']['gmail_user_password']
  gmail = MediTAF::Utils::Email::Mail.new(gusername, gpassword)

  invite = gmail.find_email(imedidata_addr, "You have been added to the "+ (option.to_s.titleize) +" #{sg_arg} on iMedidata.")
  set_sticky(:gmail_url, invite.url)
end

And(/^I navigate to the iMedidata User Activation page$/) do
  Capybara::visit(get_sticky(:gmail_url))
end

And(/^I enter in the following required iMedidata User Activation fields:$/) do |table|
  # table is a table.hashes.keys # => [:user_name, :first_name, :last_name, :email_address, :phone_number, :time_zone, :locale, :password, :security_question, :answer]
  data = table.hashes.first

  # set stickys so these values can be used in other steps
  set_sticky(:activated_user_name, get_sticky(data['Username']))
  set_sticky(:activated_user_password, get_sticky(data['Password']))
  set_sticky(:activated_first_name, get_sticky(data['First']))
  set_sticky(:activated_last_name, get_sticky(data['Last']))

  $applications.imedidata.account_activation.user_name_set get_sticky(:activated_user_name)
  $applications.imedidata.account_activation.password_set get_sticky(:activated_user_password)
  $applications.imedidata.account_activation.first_name_set get_sticky(:activated_first_name)
  $applications.imedidata.account_activation.last_name_set get_sticky(:activated_last_name)
  $applications.imedidata.account_activation.phone_set get_sticky(data['Phone'])
  $applications.imedidata.account_activation.time_zone_select get_sticky(data['Select Timezone'])
  $applications.imedidata.account_activation.locale_select get_sticky(data['Select Locale'])
  $applications.imedidata.account_activation.security_question_enter(data['Security Question'], data['Answer'])
end

When(/^I click on Activate button$/) do
  $applications.imedidata.account_activation.activate
end

And(/^I login to iMedidata with Activated User$/) do
  $applications.imedidata.login.login(get_sticky(:activated_user_name), get_sticky(:activated_user_password))
end

When(/^I acknowledge the User Agreement page$/) do
  $applications.imedidata.user_agreement.eula_confirm(get_sticky(:activated_user_name), get_sticky(:activated_user_password))
  step %Q{I verify that I am logged in with username "#{get_sticky(:activated_user_name)}" in iMedidata}
end

Then(/^I (?:N|n)avigate to "([^"]*)" (?:app) (?:of|for) (?:study group|studygroup) "([^"]*)"$/) do |app, study_group|
  $applications.imedidata.home.select({app: app}, {study_group: study_group})
end

Then(/^I (?:N|n)avigate to "([^"]*)" (?:app) (?:of|for) study "([^"]*)"$/) do |app, study|
  $applications.imedidata.home.select({app: app}, {study: study})
end

Then(/^I search for (?:study|study group) "([^"]*)"$/) do |search_term|
  search_term = $helpers.sticky_exist?(search_term, search_term)
  $applications.imedidata.home.search_by(:study, search_term)
end

Then(/^I select app "([^"]*)" from search results$/) do |app|
  $applications.imedidata.home.select_item_from_search_results(app)
end

And(/^I select app "([^"]*)" from partial search results$/) do |app|
  $applications.imedidata.home.select_item_by_partial_match(:app, app)
end

Then(/^I select study "([^"]*)" from search results$/) do |study|
  $applications.imedidata.home.select_item_from_search_results(study)
end

Then(/^I select study group "([^"]*)" from search results$/) do |study_group|
  $applications.imedidata.home.select_item_from_search_results(study_group)
end

Then(/^I should be on the iMedidata Login page$/) do
  expect($applications.imedidata.login).to have_username
end

#TODO: DO we need this? I don't see its being used anywhere
And(/^I create a (PROD|UAT|DEV) (study|study and site) in study group named "([^"]*)" with the following data:$/) do |study_type, study_n_site, sg, table|
  $applications.imedidata.home.go_to_sg(sg, 'Studies')
  $applications.imedidata.manage_study_group.click_tab :studies
  study_data = table.rows_hash
  study_name = $helpers.randomize_arg(study_data['Study Name'])
  study_protocol = $helpers.randomize_arg(study_data['Study Protocol'])
  site_name = $helpers.randomize_arg(study_data['Site Name'])
  site_number = $helpers.randomize_arg(study_data['Site Number'])
  case study_type.downcase
    when 'prod'
      study_name = study_name
    when study_type == 'dev'
      study_name = study_name + ' (DEV)'
    when study_type == 'uat'
      study_name = study_name + ' (UAT)'
  end

  if study_n_site.downcase == 'study and site'
    $applications.imedidata.studies.create_study(study_name, study_protocol, study_type)
    $applications.imedidata.studies.tab_navigation 'Sites'
    $applications.imedidata.sites.create_site(site_name, site_number)
  elsif study_n_site.downcase == 'study'
    $applications.imedidata.studies.create_study(study_name, study_protocol, study_type)
    puts 'INFO: You created a study without any site associated with the study.'
  end
end

#TODO: step can be deprecated
And(/^I navigate to iMedidata Manage Study Group page for "([^"]*)" and create study using the values below:$/) do |study_group, table|
  input = table.hashes
  study_group = $helpers.sticky_exist?(study_group, study_group)
  params = {}
  input.each do |data|
    params[:protocol_id] = $helpers.randomize_arg(data['Protocol ID'])
    params[:name] = $helpers.randomize_arg(data['Study Name'])
    params[:environment] = $helpers.randomize_arg(data['Environment'])
    $applications.imedidata.home.search_by(:study, study_group)
    $applications.imedidata.home.select_item_from_search_results(study_group)
    $applications.imedidata.manage_study_group.select_sg_tab(:studies)
    $applications.imedidata.manage_study_group.create_new_study
    $applications.imedidata.create_new_study.create_new_study(params)
    message = $applications.imedidata.current_page.flash_notice.get_message
    step %Q{I Print content "MESSAGE: #{message}" to shamus output}
    if input.size > 1
      $applications.imedidata.current_page.header.go_home
    end
  end
end

And (/^I navigate to site page and create new site in iMedidata using the values below:$/) do |table|
  input = table.hashes
  params = {}
  input.each do |data|
    params[:studyname] = $helpers.randomize_arg(data['Study Name'])
    params[:site_name] = $helpers.randomize_arg(data['Site Name'])
    params[:site_number] = $helpers.randomize_arg(data['Site Number'])
    params[:study_site_number] = $helpers.randomize_arg(data['StudySite Number'])

    $applications.imedidata.home.search_by(:study, params[:studyname])
    $applications.imedidata.home.select_item_from_search_results(params[:studyname])
    $applications.imedidata.manage_study_group.select_study_tab(:sites)
    $applications.imedidata.manage_study_group.create_new_site
    $applications.imedidata.create_new_site.new_site_create(params)
    $applications.imedidata.create_new_site.new_site_save
    message = $applications.imedidata.current_page.flash_notice.get_message
    step %Q{I Print content "MESSAGE: #{message}" to shamus output}
    step %Q{I take a screenshot}
    if input.size > 1
      $applications.imedidata.current_page.header.go_home
    end
  end
end

And (/^I navigate to admin page of study group "([^"]*)"$/) do |study_group|
  study_group = $helpers.sticky_exist?(study_group, study_group)
  $applications.imedidata.home.header.go_to_admin_page
  $applications.imedidata.admin.load_admin_page_for(:study_groups)
  $applications.imedidata.study_groups_administration.search_for_study_group(study_group)
  sleep 2
  $applications.imedidata.study_groups_administration.select_study_group(study_group)
end

And (/^I search for a study group "([^"]*)" in iMedidata Admin Page$/) do |study_group|
  $applications.imedidata.home.header.go_to_admin_page
  $applications.imedidata.admin.load_admin_page_for(:study_groups)
  $applications.imedidata.study_groups_administration.search_for_study_group(study_group)
  $applications.imedidata.study_groups_administration.select_study_group(study_group)
end

And(/^I navigate to Admin page of study group "([^"]*)" and invite a user using the values below:$/) do |study_group, table|
  step %Q{I navigate to admin page of study group "#{study_group}"}
  step "I invite a user with the values below:", table
end

And (/^I select study "([^"]*)" on Manage Study Group Page$/) do |study|
  $applications.imedidata.manage_study_group.select_sg_tab(:studies)
  $applications.imedidata.manage_study_group.select_study($helpers.randomize_arg(study))
end

And (/^I search for a study "([^"]*)" and navigate to Manage Study Group page$/) do |study|
  study = $helpers.randomize_arg(study)
  $applications.imedidata.home.search_by(:study, study)
  $applications.imedidata.home.select_item_from_search_results(study)
end

And (/^I invite a user with the values below:$/) do |table|
  table.map_headers! { |header| $helpers.symbolize_arg(header) }
  apps = []
  roles = []
  sites = []
  input = table.hashes[0]
  input[:email] = $helpers.randomize_arg(input[:email])
  if input[:apps] && !input[:apps].empty?
    input[:apps].split(',').map(&:strip).each { |item| apps << $helpers.sticky_exist?(item, item) }
    input[:apps] = apps
  end
  if input[:roles] && !input[:roles].empty?
    input[:roles].split(',').map(&:strip).each { |item| roles << $helpers.sticky_exist?(item, item) }
    input[:roles] = roles
  end
  if input[:sites] && !input[:sites].empty?
    input[:sites].split(',').map(&:strip).each { |item| sites << $helpers.sticky_exist?(item, item) }
    input[:sites] = sites
  end

  $applications.imedidata.manage_users.invite_user(input)
end

And (/^I search for the invited user "([^"]*)" on iMedidata Manage Study Page$/) do |email|
  email = $helpers.randomize_arg(email)
  $applications.imedidata.manage_study_group.search_for_the_user(email)
end

And (/^I search for a study "([^"]*)" and navigate to (Manage Study) page$/) do |study, page|
  study = $helpers.randomize_arg(study)
  page = $helpers.symbolize_arg(page)
  $applications.imedidata.current_page.header.go_home
  if study.downcase == 'study_name' and $sticky.has_key?(:study_name)
    study = $sticky[:study_name]
  end
  $applications.imedidata.home.search_by(:study, study)
  $applications.imedidata.home.select_item_from_search_results(study)
  $applications.imedidata.send(page)
end

And(/^I have a imedidata user csv spreadsheet named "([^"]*)" with values below:$/) do |filename, table|
  puts input = table.transpose.hashes
  input.each do |data|
    data['Email'] = $helpers.randomize_arg(data['Email'])
    data['Login'] = $helpers.randomize_arg(data['Login'])
    data['Study'] = $helpers.randomize_arg(data['Study'])
  end
  filepath = File.join(Dir.pwd, filename)
  $helpers.create_csv(input, filepath)
end

And(/^I upload users from csv file "([^"]*)" in the study users manage page$/) do |filename|
  $applications.imedidata.manage_study.select_study_tab(:users)
  filepath = File.join(Dir.pwd, filename)
  $applications.imedidata.manage_study.upload_csv(filepath)
end

And(/^I override a course for the user "([^"]*)"$/) do |user, table|
  user = $helpers.randomize_arg(user)
  data = table.hashes
  override_needed = $applications.imedidata.manage_study.open_course_override(user)
  sleep 1
  $applications.imedidata.courses_override.toggle_course_override(data[0]['Course'], true, data[0]['Reason']) if override_needed
  # message = $applications.imedidata.current_page.flash_notice.get_message
  # step %Q{I Print content "MESSAGE: #{message}" to shamus output}
end

And(/^I verify the user roles assignment and status using the table below:$/) do |table|
  data = table.hashes
  data.each do |row|
    row['Login'] = $helpers.randomize_arg(row['Login'])
    row['apps_roles'] = row['Apps and Roles'].split(',').map(&:strip)
  end
  $applications.imedidata.manage_study.verify_role_asgn_status(data)
end

And(/^I navigate to Helpdesk in iMedidata$/) do
  $applications.imedidata.home.header.go_to_helpdesk_page
end

Given(/^Cannot Save in Production flag for email "([^"]*)" is (checked|unchecked) in iMedidata$/) do |email, flag_state|
  step %Q{I navigate to Helpdesk in iMedidata}
  $applications.imedidata.helpdesk.email_search($helpers.randomize_arg(email))
  $applications.imedidata.helpdesk.tab_select('Security')
  $applications.imedidata.helpdesk.cannot_save_in_prod_flag_set(flag_state)
  step %Q{I take a screenshot}
  $applications.imedidata.helpdesk.helpdesk_form_save
end

And(/^I login to iMedidata as newly created user "([^"]*)"$/) do |user|
  user_name = $helpers.randomize_arg(user)
  password = ""
  if $sticky.has_key?(:users)
    $sticky[:users].each do |un|
      if un.first == user_name
        password = un.last
        break
      end
    end
  end

  $applications.imedidata.login.login(user_name, password)
  step %Q{I verify that I am logged in with username "#{user_name}" in iMedidata}
end

And(/^I assign Sites using the values below:$/) do |table|
  input = table.hashes
  input.each do |row|
    row['Search Field'] = $helpers.randomize_arg(row['Search Field'])
    row['Site Name'] = $helpers.randomize_arg(row['Site Name'])
  end

  step %Q{I search for the invited user "#{input.first['Search Field']}" on iMedidata Manage Study Page}
  $applications.imedidata.manage_study.click_assign_site(input.first['Search Field'])
  $applications.imedidata.assign_sites.search_site(input.first['Site Name'])
  $applications.imedidata.assign_sites.assign_site(input.first)
  message = $applications.imedidata.current_page.flash_notice.get_message
  step %Q{I Print content "MESSAGE: #{message}" to shamus output}
end

And(/^I verify App access for study$/) do |table|
  # table.map_headers! { |header| $helpers.symbolize_arg(header) }
  data = table.hashes
  data.each do |row|
    begin
      study_name = $helpers.randomize_arg(row['Study Name'])
      step %Q{I search for a study "#{study_name}" and navigate to Manage Study Group page}
      row['Login'] = $helpers.randomize_arg(row['Login'])
      row['apps_roles'] = row['Apps'].split(',')
      row['Roles'].split(',').each { |item| row['apps_roles'].push item }
      temp_arr = [row]
      $applications.imedidata.manage_study.verify_role_asgn_status(temp_arr)
    rescue => e
      raise e unless row['Verify'] == 'false' and e.message.include? "doesn't have correct Apps and role assignment"
    end
    $applications.imedidata.manage_study.header.go_home
  end
end

And(/^I add the app\-role assignment for user "(.*?)"$/) do |email, table|
  data = table.hashes
  data.each do |row|
    row['App'] = $helpers.sticky_exist?(row['App'], row['App'])
    row['Role'] = $helpers.sticky_exist?(row['Role'], row['Role'])
  end
  email = $helpers.randomize_arg(email)
  $applications.imedidata.manage_study.search_for_the_user(email)
  $applications.imedidata.manage_study.add_role(email, data)
end

And(/^I change the app\-role assignment for user "(.*?)"$/) do |email, table|
  data = table.hashes
  data.each do |row|
    row['App'] = $helpers.sticky_exist?(row['App'], row['App'])
    row['Role'] = $helpers.sticky_exist?(row['Role'], row['Role'])
    # row['NewRole'] = row['NewRole']
  end
  email = $helpers.randomize_arg(email)
  $applications.imedidata.manage_study.search_for_the_user(email)
  $applications.imedidata.manage_study.change_role(email, data)
end

And(/^I select (Studies|eLearning|Users|Sites) tab for (study|study group) "(.*)" in Manage (?:Study|Study Group) page$/) do |tab, option, name|
  puts name #TODO: Verify page contains study of SG name ~MD
  tab = $helpers.symbolize_arg(tab)
  if option.downcase=='study'
    case tab
      when :elearning, :users, :sites
        $applications.imedidata.manage_study.select_study_tab(tab)
      else
        raise "No option declared to access #{tab} page!"
    end
  elsif option.downcase=='study group'
    case tab
      when :elearning, :users, :studies
        $applications.imedidata.manage_study_group.select_sg_tab(tab)
      else
        raise "No option declared to access #{tab} page!"
    end
  else
    raise "Unknown option #{option}!"
  end
  sleep 2
end

And(/^I clear all the notifications$/) do
  $applications.imedidata.current_page.notifications.clear_notification
end

And(/^I navigate to Admin page and update the study group "(.*?)" using the values below:$/) do |study_group, table|
  apps = []
  courses = []
  step %Q{I navigate to admin page of study group "#{study_group}"}
  sg_name = $applications.imedidata.edit_study_group.get_study_group_title[:name]
  expect(sg_name).to eq($helpers.sticky_exist?(study_group, study_group))

  input = table.transpose.rows_hash
  input['Apps'].split(',').map(&:strip).each { |item| apps << $helpers.sticky_exist?(item, item) } if input['Apps']
  input['Apps'] = apps
  input['Courses'].split(',').map(&:strip).each { |item| courses << $helpers.sticky_exist?(item, item) } if input['Courses']
  input['Courses'] = courses

  $applications.imedidata.edit_study_group.add_apps_and_courses(input)
  message = $applications.imedidata.current_page.flash_notice.get_message
  step %Q{I Print content "MESSAGE: #{message}" to shamus output}
end

And /^I verify the following Apps name for iMedidata Apps type:$/ do |table|
  table.hashes.collect do |app|
    expect($applications.imedidata.study_launcher.get_item(app_name_value: app['apps'])).to have_content app['apps']
  end
end

And /^In iMedidata I add depots? "([^"]*)" to the selected study$/ do |depots|
  $applications.imedidata.manage_depots.add_depots(depots)
end

And /^In iMedidata I add users? "([^"]*)" to depot "([^"]*)"$/ do |users, depot|
  $applications.imedidata.manage_depots.assign_users_to_depot(depot, users)
end


# Sample Table
# | Depot Name  | Number  | Country       |
# | Depot 1     | 100     | United States |
# | Depot 2     | 200     | France        |
And /^In iMedidata I create depots? with the following attributes:$/ do |table|

  table.hashes.each do |row|
    $applications.imedidata.manage_depots.create_depot.click
    $applications.imedidata.create_new_depot.create_depot(row['Depot Name'], row['Number'], row['Country'])
  end
end

And /^In iMedidata I (accept|decline) invitation for "([^"]*)"$/ do |option, invite_name|
  if option == "accept"
    $applications.imedidata.home.invites.acknowledge_invite(invite_name, true)
  else
    $applications.imedidata.home.invites.acknowledge_invite(invite_name, false)
  end
end


# Sample Table
# | Name                | Invitation  |
# | Test Study 01       | accept      |
# | Test Study 02 (Dev) | decline     |
And /^In iMedidata I acknowledge invitations for the following studies:$/ do |table|
  table.hashes.each do |row|
    step %Q{In iMedidata I #{row['Invitation']} invitation for "#{row['Name']}"}
    $applications.common.base_page.refresh_browser
  end
end
