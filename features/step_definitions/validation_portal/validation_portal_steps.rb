When(/^I open project "([^"]*)" in Validation Portal$/) do |proj|
  project = proj
  project = $sticky[proj.to_sym] if $sticky.has_key? proj.to_sym
  $applications.validation_portal.projects.project_open(project)
end

Then(/^I should be on the Validation Portal project detail page$/) do
  expect($applications.validation_portal.project_detail).to have_project_name
end

Then(/^I should be on the Validation Portal Home Page$/) do
  expect($applications.validation_portal.projects).to have_app_name(text: 'Medidata Validation Portal')
end

When(/^I create the following Projects in Validation Portal:$/) do |table|
  # table is a table.hashes.keys # => [:Display Name, :Identifier, :GitHub Repository, :Project Type, :Externally Visible]
  $applications.validation_portal.projects.project_new
  table.hashes.each do | data |
    display_name = data['Display Name']
    display_name = $sticky[display_name.to_sym] if $sticky.has_key? display_name.to_sym
    display_name = $helpers.randomize_arg(display_name)

    id = data['Identifier']
    id = $sticky[id.to_sym] if $sticky.has_key? id.to_sym
    id = $helpers.randomize_arg(id)

    $applications.validation_portal.new_project.display_name_set(display_name)
    $applications.validation_portal.new_project.identifier_set(id)
    $applications.validation_portal.new_project.github_repository_set(data['GitHub Repository']) unless data['GitHub Repository'] == 'false'
    $applications.validation_portal.new_project.project_type_select(data['Project Type'])
    $applications.validation_portal.new_project.externally_visible_set(data['Externally Visible'])
  end
  $applications.validation_portal.new_project.project_create
end

And(/^I should see the message "([^"]*)" on the Project Detail page$/) do |message|
  expect($applications.validation_portal.project_detail).to have_content(message)
end

And(/^I search for project "([^"]*)"$/) do |name|
  project = name
  project = $sticky[name.to_sym] if $sticky.has_key? name.to_sym
  $applications.validation_portal.projects.project_search(project)
  sleep 5 #waiting for the search to be complete
end

When(/^I mark the project as a (un)?favorite$/) do |negate|
  if negate
    $applications.validation_portal.project_detail.unfavorite_set
  else
    $applications.validation_portal.project_detail.favorite_set
  end
end

Then(/^I should see the project "([^"]*)" with message "([^"]*)" on the Project Detail Page$/) do |proj, message|
  project = proj
  project = $sticky[proj.to_sym] if $sticky.has_key? proj.to_sym
  expect($applications.validation_portal.project_detail).to have_content(project + ' ' + message)
end

When(/^I create the following Version:$/) do |table|
  # table is a table.hashes.keys # => [:Version, :Git branch, :Release Type]
  $applications.validation_portal.project_detail.version_new
  table.hashes.each do | data |
    $applications.validation_portal.version.version_set(data['Version'])
    $applications.validation_portal.version.github_branch_set(data['Git branch']) unless data['Git branch'] == 'false'
    $applications.validation_portal.version.release_type_select(data['Release Type'])
  end
  $applications.validation_portal.version.version_save
end

And(/^I logout from Validation Portal$/) do
  $applications.validation_portal.current_page.header.logout
  sleep 5 # single logout is a delayed job, need this wait to ensure the user is fully logged out (i.e. the dj has run)
  expect($applications.imedidata.login).to have_username
  message = $applications.imedidata.login.get_message
  step %Q{I Print content "MESSAGE: #{message}" to shamus output}
end

Then(/^I should be on Version Detail page "([^"]*)"$/) do |version|
  expect($applications.validation_portal.validation_docs).to have_content(version)
end

And(/^I select the version "([^"]*)"$/) do |version|
  $applications.validation_portal.project_detail.version_open(version)
end

And(/^I upload the following file to the Validation Documents page:$/) do |table|
  # table is a table.hashes.keys # => [:Title, :Document]

  dir = $config['utils']['apps']['validation_portal']['upload_dir'] unless $config['utils']['apps']['validation_portal']['upload_dir'].nil?

  table.hashes.each do | data |
    title = data['Title'] if data['Title']
    unless title.nil?
      title = $sticky[title.to_sym] if $sticky.has_key? title.to_sym
      title = $helpers.randomize_arg(title)
    end

    doc = data['Document']

    UploadHelper.set(dir)
    file_name = File.join(UploadHelper.path, doc)
    $applications.validation_portal.validation_docs.file_upload_to_portal(file_name)
  end
end

And(/^I select the following Validation Document Types:$/) do |table|
  # table is a table.hashes.keys # => [:Document Type]
  table.hashes.each do | data |
    name = data['Document Type']
    $applications.validation_portal.validation_docs.val_doc_select(name)
    sleep 2 # waiting for the page to render the document uploaded if any (before taking screenshot)
  end
end

Then(/^I should see the message "([^"]*)" on the Validation Documents page$/) do |message|
  expect($applications.validation_portal.validation_docs).to have_content(message)
end

When(/^I release the version$/) do
  $applications.validation_portal.validation_docs.release_click
  $applications.validation_portal.validation_docs.version_release
end

Then(/^I should (not )?see "([^"]*)" in the search results$/) do |negate, proj|
  project = proj
  project = $sticky[proj.to_sym] if $sticky.has_key? proj.to_sym
  $applications.validation_portal.projects.project_search(project)
  item = $applications.validation_portal.projects.project_get(project)
  if negate
    expect(item).not_to match_array(project)
  else
    expect(item).to match_array(project)
  end
end

Then(/^the (un)?released versions section should( not)? include versions:$/) do |type, negate, table|
  # table is a table.hashes.keys # => [:Versions]
  items = $applications.validation_portal.project_detail.versions_get(type)

  # build array of versions to expect
  values = []
  table.hashes.each do |data|
    values << data['Versions']
  end

  if negate
    expect(items).not_to match_array(values)
  else
    expect(items).to match_array(values)
  end
end

When(/^I edit the Project in Validation Portal with the following values:$/) do |table|
  # table is a table.hashes.keys # => [:Display Name, :GitHub Repository, :Externally Visible]
  $applications.validation_portal.project_detail.project_edit
  table.hashes.each do | data |

    unless data['Display Name'].nil?
      display_name = data['Display Name']
      display_name = $sticky[display_name.to_sym] if $sticky.has_key? display_name.to_sym
      display_name = $helpers.randomize_arg(display_name)
      $applications.validation_portal.new_project.display_name_set(display_name)
    end

    unless data['GitHub Repository'].nil?
      $applications.validation_portal.new_project.github_repository_set(data['GitHub Repository'])
    end

    unless data['Externally Visible'].nil?
      $applications.validation_portal.new_project.externally_visible_set(data['Externally Visible'])
    end

  end
  $applications.validation_portal.new_project.project_create
end

When(/^I delete the project$/) do
  $applications.validation_portal.project_detail.project_delete
end

And(/^I should see the message "([^"]*)" on the Validation Portal Home Page$/) do |message|
  expect($applications.validation_portal.projects).to have_content(message)
end

When(/^I add the following Note to File:$/) do |table|
  # table is a table.hashes.keys # => [:Title, :Document]

  dir = $config['utils']['apps']['validation_portal']['upload_dir'] unless $config['utils']['apps']['validation_portal']['upload_dir'].nil?

  table.hashes.each do | data |
    title = data['Title'] if data['Title']

    doc = data['Document']

    UploadHelper.set(dir)
    file_name = File.join(UploadHelper.path, doc)
    $applications.validation_portal.validation_docs.note_to_file_add(file_name)
  end
end

When(/^I remove the uploaded document using Document Actions Menu$/) do
  $applications.validation_portal.validation_docs.document_remove
end

When(/^I edit the Version in Validation Portal with the following values:$/) do |table|
  # table is a table.hashes.keys # => [:Externally Visible]
  $applications.validation_portal.validation_docs.edit_version_click
  table.hashes.each do | data |

    unless data['Version'].nil?
      $applications.validation_portal.version.version_set(data['Version'])
    end

    unless data['Git Branch'].nil?
      $applications.validation_portal.version.github_branch_set(data['Git Branch'])
    end

    unless data['Release Tyoe'].nil?
      $applications.validation_portal.version.release_type_select(data['Release Type'])
    end
    $applications.validation_portal.version.version_save

  end
end

Then(/^I should see the message "([^"]*)"$/) do |message|
  expect($applications.current_app.current_page).to have_content(message)
end

When(/^I delete the Version "([^"]*)"$/) do |arg|
  $applications.validation_portal.validation_docs.delete_version_click
  $applications.validation_portal.validation_docs.version_delete
end

And(/^I navigate to Validation Portal Home Page$/) do
  $applications.validation_portal.current_page.navigation.go_home
end

And(/^the Project "([^"]*)" should (not )?be in the favorites panel$/) do |proj,negate|
  project = proj
  project = $sticky[proj.to_sym] if $sticky.has_key? proj.to_sym

  if negate
    if page.has_css?('#favourites')
      favorite_panel = $applications.validation_portal.projects.favorite_panel
      expect(favorite_panel.text).not_to have_content(project)
    end
  else
    favorite_panel = $applications.validation_portal.projects.favorite_panel
    expect(favorite_panel.text).to have_content(project)
  end
end

And(/^I visit the Administrator Options page for the selected version$/) do
  $applications.validation_portal.validation_docs.edit_version_click
end

When(/^I unrelease the Released Version$/) do
  $applications.validation_portal.version_admin.unrelease_version
end

When(/^I replace the uploaded document using Document Actions Menu with following document:$/) do |table|
  # table is a table.hashes.keys # => [:Document]

  dir = $config['utils']['apps']['validation_portal']['upload_dir'] unless $config['utils']['apps']['validation_portal']['upload_dir'].nil?

  table.hashes.each do |data|
    doc = data['Document']

    UploadHelper.set(dir)
    file_name = File.join(UploadHelper.path, doc)
    $applications.validation_portal.validation_docs.document_replace(file_name)
  end
end

And(/^the section "([^"]*)" exists on the left sidebar$/) do |section|
  expect($applications.validation_portal.validation_docs).to have_left_nav(text: "#{section}")
end

And(/^I verify the following documents( do not)? appear:$/) do |negate, table|
  # table is a table.hashes.keys # => [:Documents]
  table.hashes.each do |data|
    doc = data['Documents']
    if negate
      expect($applications.validation_portal.validation_docs).not_to have_content("#{doc}")
    else
      expect($applications.validation_portal.validation_docs).to have_content("#{doc}")
    end
  end
end

And(/^I navigate back to iMedidata$/) do
  $applications.validation_portal.current_page.navigation.go_to_imedidata
end

And(/^I verify that I am logged into Validation Portal as "([^"]*)"$/) do |username|
  expect($applications.validation_portal.projects.header).to have_user_name(text: "#{username}")
end
