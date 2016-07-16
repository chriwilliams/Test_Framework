And(/^I add a subject in RaveX with the following data:$/) do |table|
  # table is a table.hashes.keys # => [:Field Name, :Type, :Value]

  $applications.ravex.site.add_subject

  table.hashes.each do |data|
    label = data['Field Name']
    type = data['Type']
    value = $helpers.randomize_arg(get_sticky(data['Value']))
    $applications.ravex.subject.form_data_enter(label, type, value)
  end

  $applications.ravex.subject.form_save

  subject_name = $applications.ravex.subject.subject_header.get_subject_name
  $sticky[:subject_name] = subject_name
end

And /^In RaveX I navigate to the Subject List Page$/ do
  $applications.ravex.site.subject_list_link.click
end

And(/^In RaveX I search for subject "([^"]*)"$/) do |subject_name|
  $applications.ravex.subject_list.search_subject(get_sticky(subject_name))
end

And(/^In RaveX I select subject "([^"]*)"$/) do |subject_name|
  $applications.ravex.subject_list.select_subject(get_sticky(subject_name))
end

And(/^I enter the following data for the "([^"]*)" form:$/) do |form, table|
  # table is a table.hashes.keys # => [:Field Name, :Type, :Value]

  expect($applications.ravex.edc).to have_form_name(text: form) # make sure we are on the right form

  dir = $config['utils']['apps']['ravex']['upload_dir'] unless $config['utils']['apps']['ravex']['upload_dir'].nil?

  table.hashes.each do |data|
    label = data['Field Name']
    type = data['Type']
    value = data['Value']

    if $sticky.has_key?(value.to_sym)
      value = $sticky[value.to_sym]
    end

    if type.to_s.downcase == 'file_upload'
      UploadHelper.set(dir)
      value = File.join(UploadHelper.path, value)
    else
      value = $helpers.randomize_arg(value)
    end

    $applications.ravex.edc.form_data_enter(label, type, value)
  end
end

And(/^I change pagination to "([^"]*)" in RaveX$/) do |number_per_page|
  $applications.ravex.site.pagination.change_number_items_per_page(number_per_page)
end

And(/^I navigate to the first page$/) do
  $applications.ravex.site.pagination.go_to_first_page
end

And(/^I navigate to the last page$/) do
  $applications.ravex.site.pagination.go_to_last_page
end

And(/^I navigate to form "([^"]*)"$/) do |form_name|
  $applications.ravex.subject.subject_menu_nav.navigate_to_form(form_name)
end

And(/^I navigate to folder "([^"]*)"$/) do |folder_name|
  $applications.ravex.subject.subject_menu_nav.navigate_to_folder(folder_name)
end

And(/^I navigate to form "([^"]*)" within folders:$/) do |form_name, table|
  # table is a table.hashes.keys # => [:Folder]
  table.hashes.each do |attributes|
    folder_name = attributes['Folder']
    $applications.ravex.subject.subject_menu_nav.navigate_to_folder(folder_name)
  end
  $applications.ravex.subject.subject_menu_nav.navigate_to_form(form_name)
end

And(/^I disable subject$/) do
  $applications.ravex.subject.disable_subject
end

And(/^I enable subject$/) do
  $applications.ravex.subject.enable_subject
end

And(/^I get the name of subject from the navigation panel header$/) do
  $applications.ravex.subject.subject_menu_nav.get_subject_name_from_nav_panel
end

And(/^In RaveX I add event "([^"]*)" on the subject page$/) do |option|
  $applications.ravex.subject.add_subject_event(option)
end

And(/^I navigate to Subject Administration page$/) do
  $applications.ravex.subject.open_subject_admin
end

And(/^I do action (Edit|New Query|New Sticky|New Protocol Deviation|Audits) for the field "([^"]*)" in RaveX$/) do |action, field|
  action = action.split(" ").map(&:capitalize).join(" ")
  $applications.ravex.edc.data_field_action_select(field, action)
end

And(/^I open query for field: "([^"]*)" to Marking Group: "([^"]*)" with text: "([^"]*)" and Require Response: "([^"]*)" in RaveX$/) do |label, marking_group, text, require_response|
  $applications.ravex.edc.query_sticky_data_enter(label, marking_group, text, require_response)
  $applications.ravex.edc.form_save
end

And(/^I verify icon (Complete|Not Conformant|Never Touched|Locked|Entry Lock|Inactive|Overdue|Incomplete|Requires Verification|Requires Review|Query Open|Answered Query|Requires Coding|Requires Signature) displayed for field "([^"]*)"$/) do |icon_name, label|
  $applications.ravex.edc.field_icon_verify(label, icon_name)
end

And(/^I open RaveX Log Line "([^"]*)"$/) do |line|
  $applications.ravex.log_line.log_line_open(line)
end

And(/^I do action (Activate|Reactivate|Inactivate) for RaveX Log Line "([^"]*)"$/) do |action, line|
  $applications.ravex.log_line.log_line_activation(line, action, nil)
end

And(/^I do action (Activate|Reactivate|Inactivate) for RaveX Log Line "([^"]*)" with reason "(.*)"$/) do |action, line, reason|
  $applications.ravex.log_line.log_line_activation(line, action, reason)
end

And(/^I save RaveX EDC form$/) do
  $applications.ravex.edc.form_save
end

And(/^I open query with the following data:$/) do |table|
  # table is a table.hashes.keys # => [:Field Name, :Marking Group, :Text, :Require Response]
  table.hashes.each do |data|
    label = data['Field Name']
    marking_group = data['Marking Group']
    text = data['Text']
    require_response = data['Require Response']

    $applications.ravex.edc.query_sticky_data_enter(label, marking_group, text, require_response)
  end
  $applications.ravex.edc.form_save
end

And(/^I open sticky for field: "([^"]*)" to Marking Group: "([^"]*)" with text: "([^"]*)" in RaveX$/) do |label, marking_group, text|
  $applications.ravex.edc.query_sticky_data_enter(label, marking_group, text)
  $applications.ravex.edc.form_save
end

And(/^I change to landscape view in RaveX$/) do
  $applications.ravex.log_line.change_to_landscape_view
end

And(/^I verify subject "([^"]*)" is created in RaveX$/) do |expected_subject_name|
  subject = $applications.ravex.edc.subject_menu_nav.get_subject_name_from_nav_panel
  $sticky[:subject_name] = expected_subject_name unless $sticky.has_key?(:subject_name)
  expect(subject).to eq($sticky[:subject_name])
end

And(/^I verify the following data on the "([^"]*)" form:$/) do |form, table|
  # table is a table.hashes.keys # => [:Field Name, :Value]

  expect($applications.ravex.edc).to have_form_name(text: form) # make sure we are on the right form

  table.hashes.each do |data|
    label = data['Field Name']
    value = data['Value']
    value = $sticky[value.to_sym] if $sticky.has_key? value.to_sym
    field_value = $applications.ravex.edc.get_field_value(label)
    expect(field_value.fetch(0).text).to eq(value)
  end
end

And(/^I change to portrait view in RaveX for Log Line "([^"]*)"$/) do |line_num|
  $applications.ravex.log_line.change_to_portrait_view(line_num)
end

And(/^I sign the form in RaveX with user "([^"]*)"$/) do |user_name|
  password = $config['modules']['ui']['apps']['ravex']['users'][user_name.downcase]
  $applications.ravex.edc.form_sign(user_name, password)
end

And(/^I sign all forms in RaveX with user "([^"]*)"$/) do |user_name|
  password = $config['modules']['ui']['apps']['ravex']['users'][user_name.downcase]
  $applications.ravex.subject.form_sign_all(user_name, password)
end

And(/^I verify the following Audit Data for field "([^"]*)":$/) do |field, table|
  # table is a table.hashes.keys # => [:Audit]
  $applications.ravex.edc.audit_select(field)

  a_data = $applications.ravex.edc.audit_data_get

  table.hashes.each do |data|
    v_data = data['Audit']
    $applications.ravex.edc.audit_data_verify(a_data, v_data)
  end
  $applications.ravex.edc.close_modal()
end

And /^In RaveX I replace(?: \d+)? "([^"]*)" items for field "([^"]*)"$/ do |unnumbered_count, items, selection|
  $applications.ravex.balance.replace_items(selection, items, unnumbered_count)
end

