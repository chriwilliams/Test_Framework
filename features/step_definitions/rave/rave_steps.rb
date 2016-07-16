
And(/^I Search for Study "([^"]*)" in Rave$/) do |study|
  study = step %Q{I check if value "#{study}" is a sticky value from the config file}
  $applications.rave.home.study_search(study)
end

And(/^I Search for Site "([^"]*)" in Rave$/) do |site|
  $applications.rave.study.site_search(site)
end

And(/^I verify the assignments in Rave using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:Username, :Role, :Study, :Site, :Authenticator]
  input = table.transpose.rows_hash
  params = {}
  params[:last_name] = $sticky.has_key?(:last_name) ? $sticky[:last_name] : input['Last Name']
  params[:login] = $sticky.has_key?(:username) ?  $sticky[:username] :  input['Log In']
  params[:site] = $sticky.has_key?(:site_name) ? $sticky[:site_name] : input['Site']
  params[:site_group] = input['Site Group'] if input['Site Group']
  params[:role] = input['Role'] if input['Role']
  params[:study] = $sticky.has_key?(:study_name) ?  $sticky[:study_name] :  input['Study']
  params[:environment] = input['Environment'] if input['Environment']
  params[:authenticator] = input['Authenticator'] if input['Authenticator']

  title = $applications.rave.home.title
  if title.include?('Select Role')
    $applications.rave.role_selection.select_role(params[:role])
  end
  $applications.rave.home.header.go_home
  $applications.rave.home.useradmin_select
  $applications.rave.filter_users.user_search(params)
end

And(/^I add subject$/) do
  $applications.rave.site.subject_add
end

Then(/^I verify the following EDC fields data:$/) do |table|
  # table is a table.hashes.keys # => [:Data]
  sleep 3
  input = table.transpose.cell_matrix[0]
  $applications.rave.crf_page.data_verify(input)
end

And(/^I navigate to Configuration in Rave$/) do
  $applications.rave.home.configuration_select
end

And(/^I navigate to Other Settings in Rave$/) do
  $applications.rave.configurations.other_settings_select
end

And(/^I navigate to User Groups in Rave$/) do
  $applications.rave.other_settings.user_groups_select
end

And(/^I navigate to Coder Configuration in Rave$/) do
  $applications.rave.other_settings.coder_configuration_select
end

And(/^I set Review Marking Group to "([^"]*)" and requires response to "([^"]*)"$/) do |coder_marking_group, require_response|
  $applications.rave.coder_configuration.coder_cofigurations_set(coder_marking_group, !!(require_response))
end

And(/^I navigate to Project "([^"]*)" in Architect$/) do |project|
  project = step %Q{I check if value "#{project}" is a sticky value from the config file}
  $applications.rave.architect.active_project_select(project)
end

And(/^I remove CRF draft "([^"]*)"$/) do |draft|
  $applications.rave.project.draft_remove(draft)
end

And(/^I restore Rave defaults for Coder project "([^"]*)" with file named "([^"]*)" with draft "([^"]*)"$/) do |project_name, file_name, draft_name|
  project = step %Q{I check if value "#{project_name}" is a sticky value from the config file}
  step %Q{I go to Workflow Configuration page}
  step %Q{I make sure coder review group and coder marking group exist}
  current_dir = $config['ui']['apps']['coder']['coder_draft_path']
  draft_file = File.join(current_dir, file_name)
  excel_filename_new = file_name.gsub '.xls', '_updated' + '.xls'
  draft_file_new = File.join(current_dir, excel_filename_new)
  $applications.rave.home.home_tab_select
  $applications.rave.home.configuration_select
  $applications.rave.configurations.other_settings_select
  $applications.rave.other_settings.coder_configuration_select
  $applications.rave.coder_configuration.coder_cofigurations_set('site from system', true)
  $applications.rave.home.header.go_home
  $applications.rave.home.architect_select
  $applications.rave.architect.active_project_select(project)
  $applications.rave.project.draft_remove draft_name
  $applications.rave.home.header.go_home
 # Update draft name in excel
  if draft_file
    $applications.rave.draft_upload.excel_draft_name_update(project_name, draft_file, draft_file_new)
    # Update draft
    $applications.rave.home.architect_select
    # Navigate to "Upload draft"
    $applications.rave.architect.architect_menu_nav('Upload Draft')
    $applications.rave.draft_upload.draft_upload(draft_file_new)
  end
end

And(/^I open log line (\d+) for Coder datapoint "([^"]*)" on form "([^"]*)"$/) do |line_num, link_name, form_name|
  step %Q{I open Coder form "#{form_name}"}
  $applications.rave.crf_page.log_line_open(link_name, line_num, true)
end

And(/^I open log line "([^"]*)" for datapoint "([^"]*)" on form "([^"]*)"$/) do |line_num, link_name, form_name|
  step %Q{I navigate to form "#{form_name}" in Rave}
  link_name = $sticky[link_name.to_sym] if $sticky.has_key? link_name.to_sym
  step %Q{I navigate to form "#{form_name}" in Rave}
  $applications.rave.crf_page.log_line_open(link_name, line_num)
end

And(/^I upload draft "([^"]*)"$/) do |draft_name|

  draft = get_sticky(draft_name)

  dir = $config['utils']['apps']['rave']['upload_dir'] unless $config['utils']['apps']['rave']['upload_dir'].nil?

  UploadHelper.set(dir)
  draft_file_path = File.join(UploadHelper.path, draft)
  step %Q{I select "Upload Draft" in Rave Architect}
  $applications.rave.draft_upload.draft_upload("#{draft_file_path}")
end

And(/^I submit verbatim term for the following field on "([^"]*)" form:$/) do |form, table|
  # table is a table.hashes.keys # => [:Field Name, :Type, :value]
  step %Q{I open Coder form "#{form}"}
  step %Q{I enter the following data for the "#{form}" Rave form:}, table
  step %Q{I save Rave EDC form}
end

And(/^I search for subject "([^"]*)" for study named "([^"]*)" and site "([^"]*)"$/) do |subject, study, site|
  study = step %Q{I check if value "#{study}" is a sticky value from the config file}
  subject = $sticky[:sub_name] if ($sticky.has_key?(:sub_name) and $sticky[:sub_name] != '')
  step %Q{I navigate to study "#{study}" and site "#{site}" in Rave}
  $applications.rave.site.subject_search(subject)
end

And(/^I navigate to "([^"]*)" for Form "([^"]*)" in Draft "([^"]*)" for Project "([^"]*)"$/) do |draft_item, form_name, draft_name, project_name|
  project = step %Q{I check if value "#{project_name}" is a sticky value from the config file}
  $applications.rave.home.home_tab_select
  $applications.rave.home.architect_select
  $applications.rave.architect.active_project_select(project)
  $applications.rave.project.draft_open(draft_name)
  $applications.rave.draft.draft_item_open(draft_item)
  sleep 2
  $applications.rave.forms.form_fields_open(form_name)
end

And(/^I setup the field "([^"]*)" to use dictionary "([^"]*)"$/) do |field_name, dict_name|
  $applications.rave.fields.field_edit(field_name)
  $applications.rave.fields.coder_dict_select(dict_name)
  $applications.rave.fields.fields_save
end

And(/^I configure dictionary to use "([^"]*)" as the coding level$/) do |coding_level|
  $applications.rave.fields.coder_config_nav
  $applications.rave.coder_configuration.coding_level_select(coding_level)
  $applications.rave.coder_configuration.coder_config_save
end

And(/^I select Draft "([^"]*)"$/) do |draft_name|
  $applications.rave.project.draft_open(draft_name)
end

And(/^I Publish Draft as "([^"]*)"$/) do |crf|
  $applications.rave.draft.draft_publish(crf)

  using_wait_time 5 do #override wait time
    expect($applications.rave.draft).not_to have_crf_error
  end
end

And(/^I Publish and Push Draft "([^"]*)" as "([^"]*)" in "([^"]*)" environment to All sites$/) do |draft, crf, env|
  $applications.rave.draft.select_tab(draft)
  crf = $helpers.randomize_arg(crf)
  step %Q{I Publish Draft as "#{crf}"}
  $applications.rave.project.project_tab_select
  $applications.rave.project.draft_push_click
  $applications.rave.crf_version.draft_push_to_sites(env)
end

And(/^I select Project tab in Rave$/) do
  $applications.rave.project.project_tab_select
end

And(/^I Publish and Push Draft "([^"]*)" as "([^"]*)" in "([^"]*)" environment to sites below:$/) do |draft, crf, env, table|
  # table is a table.hashes.keys # => [:Site]

  sites_to_push = "site:"

  table.hashes.each do |key|
    sites_to_push << "#{key["Site"]}:"
  end

  $applications.rave.draft.select_tab(draft)
  crf = $helpers.randomize_arg(crf)
  step %Q{I Publish Draft as "#{crf}"}
  $applications.rave.project.project_tab_select
  $applications.rave.project.draft_push_click
  $applications.rave.crf_version.draft_push_to_sites(env,sites_to_push)

end

And(/^I Publish and Push Draft "([^"]*)" as "([^"]*)" in "([^"]*)" environment to site groups below:$/) do |draft, crf, env, table|
  # table is a table.hashes.keys # => [:Site]

  sites_to_push = "group:"

  table.hashes.each do |key|
    sites_to_push << "#{key["Site Group"]}:"
  end

  $applications.rave.draft.select_tab(draft)
  crf = $helpers.randomize_arg(crf)
  step %Q{I Publish Draft as "#{crf}"}
  $applications.rave.project.project_tab_select
  $applications.rave.project.draft_push_click
  $applications.rave.crf_version.draft_push_to_sites(env,sites_to_push)
end

And(/^I select and save following supplemental fields:$/) do |table|
  # table is a table.hashes.keys # => [:Value]
    fields = table.transpose.cell_matrix[0]
    $applications.rave.coder_configuration.select_supp_fields(fields)
end

And(/^I select and save following component fields:$/) do |table|
  # table is a table.hashes.keys # => [:Field, :Value]
   table.hashes.each do |comp_field|
     comp_name = comp_field['Field']
     comp_value = comp_field['Value']
     $applications.rave.coder_configuration.select_comp_fields(comp_name,comp_value)
   end
end

And(/^I enter the following data for the "([^"]*)" Rave form:$/) do |form, table|
  # table is a table.hashes.keys # => [:Field Name, :Type, :Value]

  # TODO: make sure we are on the right form using rspec

  table.hashes.each do |data|
    label = data['Field Name']
    type = data['Type']
    value = data['Value']
    value = $helpers.randomize_arg(value)
    value = $sticky[value.to_sym] if $sticky.has_key? value.to_sym
    $applications.rave.crf_page.form_data_enter(label, type, value)
  end
end

And(/^I (save|cancel) Rave EDC form$/) do |action|
  case action.downcase
    when 'save'
      $applications.rave.crf_page.form_save
    when 'cancel'
      $applications.rave.crf_page.form_cancel
  end
end

And(/^I add a subject in Rave with the following data:$/) do |table|
  # table is a table.hashes.keys # => [:Field Name, :Type, :Value]
  $applications.rave.site.subject_add

  table.hashes.each do |data|
    label = data['Field Name']
    type = data['Type']
    value = data['Value']
    value = $helpers.randomize_arg(value)
    $sticky[:subject_id] = value
    $applications.rave.crf_page.form_data_enter(label, type, value)
  end

  $applications.rave.subject.subject_save
  $sticky[:sub_name] = $applications.rave.subject.get_subject_name
  $applications.current_app.current_page.print_to_output("Subject: #{$sticky[:sub_name]} is created.")
end

And(/^I navigate to study "([^"]*)" and site "([^"]*)" in Rave$/) do |study, site|

  st_name = site
  st_name = $sticky[site.to_sym] if $sticky.has_key? site.to_sym
  $sticky[:site_name] = st_name

  sd_name = study
  sd_name = $sticky[study.to_sym] if $sticky.has_key? study.to_sym
  $sticky[:study_name] = sd_name

  $applications.rave.home.header.go_home
  $applications.rave.home.study_search(sd_name)
  $applications.rave.study.site_search(st_name)
end

And(/^I navigate to the study "([^"]*)" and first site in Rave$/) do |study|
  $sticky[:study_name] = study
  $applications.rave.home.header.go_home
  $applications.rave.home.study_search($sticky[:study_name])
  $sticky[:site_name]= $applications.rave.home.get_first_site_name
  $applications.rave.home.select_first_rave_study_site
end


And(/^I navigate to study "([^"]*)" in Rave$/) do |study|
  study = step %Q{I check if value "#{study}" is a sticky value from the config file}
  $applications.rave.home.study_search(study)
end

And(/^I open Coder form "([^"]*)"$/) do |form_name|
  $applications.rave.crf_page.menu_nav.open_form_by_name form_name
end

And(/^I navigate to form "([^"]*)" in Rave$/) do |form|
  $applications.rave.crf_page.menu_nav.form_folder_navigate(form)
end

And(/^I navigate to form "([^"]*)" in Rave within folders:$/) do |form, table|
  # table is a table.hashes.keys # => [:Folders]
  table.hashes.each do | data |
    folder = data['Folders']
    $applications.rave.crf_page.menu_nav.form_folder_navigate(folder)
  end
  $applications.rave.crf_page.menu_nav.form_folder_navigate(form)
end

And(/^I select subject "([^"]*)" in Rave$/) do |subject|
  $applications.rave.site.subject_search(subject)
  using_wait_time 5 do #override wait time
    if $applications.rave.site.has_subject_table?
      $applications.rave.site.subject_select(subject)
    end
  end
end

And(/^I add a Log Line in Rave EDC$/) do
  $applications.rave.crf_page.log_line_add
end

And(/^I open fields for "([^"]*)" form in Rave Architect$/) do |form|
  $applications.rave.forms.form_search(form)
  $applications.rave.forms.form_fields_open(form)
end

And(/^I select field "([^"]*)" in Rave Architect$/) do |field|
  $applications.rave.fields.field_edit(field)
end

Then(/^I verify query text "([^"]*)" is displayed for the field "([^"]*)" on Rave form$/) do |query_text, field|
  text = $applications.rave.crf_page.query_text_get(field)
  #expect(text.downcase).to eq(query_text.downcase)
  expect(text.downcase).to include(query_text.downcase)
end

And(/^I verify icon (Complete|Not Conformant|Never Touched|Locked|Entry Lock|Inactive|Overdue|Incomplete|Requires Verification|Requires Review|Query Open|Answered Query|Requires Coding|Requires Signature) displayed for field "([^"]*)" on Rave form$/) do |icon_name,label|
  $applications.rave.crf_page.field_icon_verify(label, icon_name)
end

And(/^I add a subject for study "([^"]*)" and site "([^"]*)" with following values:$/) do |study, site, table|
  study = step %Q{I check if value "#{study}" is a sticky value from the config file}
  # table is a table.hashes.keys # => [:Field Name, : Type, :Value]
  step %Q{I navigate to study "#{study}" and site "#{site}" in Rave}
  step %Q{I add a subject in Rave with the following data:},table
end

When(/^I am on add subject page for study "([^"]*)"$/) do |study|
  $applications.rave.home.home_tab_select
  select_study = step %Q{I check if value "#{study}" is a sticky value from the config file}
  $applications.rave.home.study_search select_study
end

And(/^I navigate to (User Administration|Architect|Site Administration|Reporter|Configuration|Report Administration|Lab Administration|DDE|Translation Workbench|PDF Generator|DCF|Query Management|Welcome Message) in Rave$/) do |main_menu_item|
  $applications.rave.home.header.go_home
  $applications.rave.home.main_subject_menu_nav.main_menu_nav(main_menu_item)
end

Then(/^I verify (Save|Sign and Save) button is (disabled|enabled)$/) do |button_text, state|
  case state.downcase
    when 'disabled'
      case button_text.to_s.downcase
        when 'save'
          expect($applications.rave.crf_page.save_button['disabled'].to_s).to match /true$/i
        when 'sign and save'
          expect($applications.rave.crf_page.sign_and_save_button['disabled'].to_s).to match /true$/i
      end
    when 'enabled'
      case button_text.to_s.downcase
        when 'save'
          expect($applications.rave.crf_page.save_button['disabled']).to be_nil
        when 'sign and save'
          expect($applications.rave.crf_page.sign_and_save_button['disabled']).to be_nil
      end
  end
  step %Q{I Print content "VERIFIED: Button: '#{button_text}' is '#{state}'" to shamus output}
  #$applications.rave.crf_page.save_button_disabled_verify(button_text)
end

Then(/^I verify Saving is disabled on the EDC page$/) do
  $applications.rave.crf_page.cannot_save_in_prod_sign_verify
end

And(/^I search for user in Rave using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:Last Name, :Log In, :Site, :Site Group, :Role, :Study, :Site, :Authenticator]
  input = table.transpose.rows_hash
  params = {}
  params[:last_name] = get_sticky(input['Last Name']) if input['Last Name']
  params[:login] = get_sticky(input['Log In']) if input['Log In']
  params[:site] = get_sticky(input['Site']) if input['Site']
  params[:site_group] = get_sticky(input['Site Group']) if input['Site Group']
  params[:role] = get_sticky(input['Role']) if input['Role']

  study_env = get_sticky(input['Study']) if input['Study'] # may or may not contain environment
  study_env = study_env.split(' ')
  params[:study] = study_env.first
  params[:environment] = study_env.last if study_env.count > 1
  params[:authenticator] = input['Authenticator'] if input['Authenticator']

  $applications.rave.home.header.go_home
  $applications.rave.home.useradmin_select
  $applications.rave.filter_users.user_search(params)
end

And(/^I go to user details for "([^"]*)"$/) do |user_name|
  user_name = step %Q{I check if value "#{user_name}" is a sticky value from the config file}
  sleep 1
  $applications.rave.filter_users.user_details_open($helpers.randomize_arg(user_name))
  using_wait_time 90 do # takes a while to get to user details page on some sites.
    expect($applications.rave.user_details).to have_pin_text
  end
end

Then(/^In Rave I verify Cannot Save in Production checkbox is (checked|unchecked)$/) do |state|
  case state.to_s
    when 'checked'
      expect($applications.rave.user_details.cannot_save_inprod_checkbox['checked'].to_s).to match /true$/i
    when 'unchecked'
      expect($applications.rave.user_details.cannot_save_inprod_checkbox['checked']).to be_nil
  end
  step %Q{I Print content "VERIFIED: Cannot Save in Production checkbox is #{state}" to shamus output}
end

And(/^I verify text "([^"]*)" (exists|does not exist) on User Details page in Rave$/) do |text, exist_option|
  case exist_option.to_s.downcase
    when 'exists'
      expect($applications.rave.user_details).to have_cannot_save_inprod_text(text: "#{text}")
    when 'does not exist'
      using_wait_time 5 do #override wait time
        expect($applications.rave.user_details).not_to have_cannot_save_inprod_text
      end
  end
  step %Q{I Print content "VERIFIED: Text: '#{text}' #{exist_option}" to shamus output}
end

And(/^I verify text "([^"]*)" is (available|not available) of EDC page$/) do |text, availability|
  case availability.to_s.downcase
    when 'available'
      expect($applications.rave.crf_page).to have_cannot_save_in_prod_table_text(text: "#{text}")
    when 'not available'
      using_wait_time 5 do #override wait time
      expect($applications.rave.crf_page).not_to have_cannot_save_in_prod_table_text
      end
  end
  step %Q{I Print content "VERIFIED: Text: '#{text}' is '#{availability}'" to shamus output}
end

And(/^I go to Workflow Configuration page$/) do
  $applications.rave.home.main_menu_select 'Configuration'

end


And(/^I make sure coder review group and coder marking group exist$/) do
  $applications.rave.workflow.verify_coder_review_group
  $applications.rave.workflow.verify_coder_marking_group
end

And(/^In Rave I verify the following data on the "([^"]*)" EDC form in Rave:$/) do |form, table|
  # table is a table.hashes.keys # => [:Field Name, :Value]
  expect($applications.rave.crf_page).to have_form_name(text: form) # make sure we are on the right form

  table.hashes.each do | data |
    label = data['Field Name']
    value = data['Value']
    field_value = $applications.rave.crf_page.get_field_value(label)
    expect(field_value).to eq(value)
    step %Q{I Print content "VERIFIED: Value: '#{value}' is available for the field: '#{label}'" to shamus output}
  end
end

Given(/^iMedidata user account is not linked to Rave account with following details:$/) do |table|
  # table is a table.hashes.keys # => [:Field, :Value]
  #TODO: Login to Rave
  step %Q{I navigate to User Administration in Rave}
  $applications.rave.filter_users.add_new_user()
  table.hashes.each do | data |
    field = data['Field']
    value = get_sticky(data['Value'])
    if field.downcase == 'pin'
      $sticky[:pin] = value
    end
    if field.downcase == 'login'
      $sticky[:rave_user] = value
    end
    $applications.rave.user_details.user_details_data_enter(field, value)
  end

  $applications.rave.user_details.user_details_save("training")
  act_code = $applications.rave.user_activation.activation_code_get()
  step %Q{I logout from "rave"}
  $applications.rave.login.login_click()
  $applications.rave.login.new_user_activate()
  $applications.rave.user_activation.activation_account_data_enter(act_code, $sticky[:pin])

  password="password"
  $applications.rave.user_activation.activation_account_password_set(password)
  $applications.rave.user_activation.activation_account_login_page_navigate()
end

And(/^I link iMedidata user with Rave account "([^"]*)" and password "([^"]*)"$/) do |rave_account, password|
  if $applications.rave.imedidata_rave_connection.link_account_button.visible?

    if rave_account.downcase == 'rave_user' and $sticky.has_key?(:rave_user)
      rave_account = $sticky[:rave_user]
    end
    if rave_account.downcase == 'password' and $sticky.has_key?(:password)
      rave_account = $sticky[:password]
    end

    $applications.rave.imedidata_rave_connection.imedidata_rave_connection_data_enter('rave account', rave_account)
    $applications.rave.imedidata_rave_connection.imedidata_rave_connection_data_enter('password', password)
    $applications.rave.imedidata_rave_connection.link_account_click
  end
end

And(/^I verify I am in Rave app on the Sites tab for site "(.*?)"$/) do |site|
  site_name = $applications.rave.site.site_name_get

  my_site = site
  my_site = $sticky[site.to_sym] if $sticky.has_key? site.to_sym

  if $sticky.has_key?(:site_name)
    my_site = $sticky[:site_name]
  end

  expect(my_site).to eq(site_name.text)
end

# Open a rave form wait for the coded term to appear on the page
And(/^in Rave I wait for the coded term and id to appear on Coder datapoint "([^"]*)" on Rave form "([^"]*)" for log line (\d+):$/) do |link_name, form, log_line, table|
  # Open the form
  input = table.transpose.cell_matrix[0]
  step %Q{I open log line #{log_line} for Coder datapoint "#{link_name}" on form "#{form}"}
  # verify that the id for the coded term is visible
  $applications.rave.crf_page.wait_for_data_to_verify(input)
end

# Open a rave form wait for the coded term to appear on the page
And(/^in Rave I assign role "([^"]*)" and study "([^"]*)" to user$/) do |study_role, study|
  #select the Assign to study button
  $applications.rave.user_details.select_assign_to_study
  # select a study role
  $applications.rave.user_details.select_study_role study_role
  # select a study role
  $applications.rave.user_details.select_study study
  # save
  $applications.rave.user_details.click_assign_user
end

And(/^I select "([^"]*)" in Rave Architect$/) do |menu_item|
  $applications.rave.architect.architect_menu_nav(menu_item)
end
