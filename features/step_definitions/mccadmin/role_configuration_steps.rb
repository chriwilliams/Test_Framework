And(/^I add roles using the values below:$/) do |table|

  expect($applications.mccadmin.roles_configuration.main).to have_header_text(text: 'Configurations')
  table.map_headers! { |header| header.downcase.gsub(' ', '_').to_sym }
  input = table.hashes
  params = []
  input.each do |param|
    param[:apps] = param[:apps].split(',').map(&:strip)
    param[:roles] = param[:roles].split(',').map(&:strip)
    param[:apps] = param[:apps].map {|app| "#{rave_app} #{app}"}
    param[:app_role_hash] = Hash[param[:apps].zip(param[:roles])]
    params.push(param)
  end

  $sticky[:role_cops] = params[0][:name]
  $sticky[:role_pi] = params[1][:name]
  $applications.mccadmin.roles_configuration.select_configuration_action('Edit Roles')
  $applications.mccadmin.edit_configuration_roles.add_roles(params)

  message = $applications.mccadmin.roles_configuration.main.get_message
  expect(message).to eq("#{params.size} Configuration type role(s) successfully updated.")
  step %Q{I Print content "VERIFIED : #{message}" to shamus output}
end

And(/^I create admin user using the values below:$/) do |table|
  # table is a table.hashes.keys # => [:First, :Last, :Email, :Environment, :Roles]
  input = table.transpose.rows_hash
  params = {}

  params[:email] = input['Email'].split('@').join("+mcc_admin_#{$faker.random}@")
  $sticky[:admin_user_email] = params[:email]
  params[:first] = input['First']
  params[:last] = $faker.stringify(input['Last'], "-"+$faker.random.chop.chop)
  admin_name = $faker.stringify(params[:first], " "+(params[:last]))
  $sticky[:admin_name] = admin_name
  params[:phone] = $faker.phone_number.phone_number if input['Phone'].empty?
  params[:role] = input['Role']

  $applications.mccadmin.all_users.click_create_admin_user
  $applications.mccadmin.add_user_to_client_division.add_user(params)
  message = $applications.mccadmin.all_users.main.get_message
  expect(message).to include(params[:first], params[:last])
  step %Q{I Print content "VERIFIED :  #{message}" to shamus output}
  sleep 90  #TODO: change this after seeing MD's change
end

And(/^I remove a user with email "([^"]*)"$/) do |email|
  email = $sticky.has_key?(:admin_user_email) ? $sticky[:admin_user_email] : email

  $applications.mccadmin.all_users.search.search_by('All', email)
  $applications.mccadmin.all_users.remove_client_division_user
  message = $applications.mccadmin.all_users.main.get_message
  step %Q{I Print content "VERIFIED :  #{message}" to shamus output}
end
