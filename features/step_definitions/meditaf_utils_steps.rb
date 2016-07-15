Given(/^I generate Medidata_dateformat and print log$/) do
  step %Q{I Print content "Medidata Date Format: #{$faker.medidata_date_format}" to shamus output}
end

And(/^I should be able to append Medidata_dateformat to string "(.*?)" and print log$/) do |arg1|
  step %Q{I Print content "Print log: #{$faker.stringify(arg1, $faker.medidata_date_format)}" to shamus output}
end

Given(/^I generate Random_number and I print log$/) do
  step %Q{I Print content "Random Number: #{$faker.random}" to shamus output}
end

And(/^I should be able append random number to "(.*?)" and print log$/) do |arg1|
  step %Q{I Print content "Print log: #{$faker.stringify(arg1, $faker.random)}" to shamus output}
end


Given(/^I generate "(.*?)" and I print log$/) do |arg1|
  case arg1
    when "timestamp_short"
      step %Q{I Print content "Timestamp_short: #{$faker.timestamp_short}" to shamus output}
    when "timestamp_long"
      step %Q{I Print content "Timestamp_long: #{$faker.timestamp_long}" to shamus output}
  end
end

And(/^I append timestamp_short to "(.*?)" and print log$/) do |arg1|
  step %Q{I Print content "Print log: #{$faker.stringify(arg1, $faker.timestamp_short)}" to shamus output}
end

And(/^I append timestamp_long to "(.*?)" and print log$/) do |arg1|
  step %Q{I Print content "Print log: #{$faker.stringify(arg1, $faker.timestamp_short)}" to shamus output}
end

Given(/^I generate fake address and I print log$/) do
  pending # express the regexp above with the code you wish you had
end


And(/^I generate address "(.*?)" and I print log$/) do |arg1|
  case arg1
    when "city"
      step %Q{I Print content "City: #{$faker.address.city}" to shamus output}
    when "street_name"
      step %Q{I Print content "Street Name: #{$faker.address.street_name}" to shamus output}
    when "street_address"
      step %Q{I Print content "Street Address: #{$faker.address.street_address}" to shamus output}
    when "zip_code"
      step %Q{I Print content "Zip Code: #{$faker.address.zip_code}" to shamus output}
  end
end


And(/^I generate name "(.*?)" and I print log$/) do |arg1|
  case arg1
    when "first_name"
      step %Q{I Print content "First Name: #{$faker.name.first_name}" to shamus output}
    when "last_name"
      step %Q{I Print content "Last Name: #{$faker.name.last_name}" to shamus output}
  end
end

And(/^I generate number "(.*?)" and I print log$/) do |arg1|
  case arg1
    when "digit"
      step %Q{I Print content "Digit: #{$faker.number.digit}" to shamus output}
    when "decimal"
      step %Q{I Print content "Decimal: #{$faker.number.decimal}" to shamus output}
    when "number"
      step %Q{I Print content "Number: #{$faker.number.number}" to shamus output}
  end
end

And(/^I generate phone_number "(.*?)" and I print log$/) do |arg1|
  case arg1
    when "cell_phone"
      step %Q{I Print content "Phone number: #{$faker.phone_number.cell_phone}" to shamus output}
    when "phone_number"
      step %Q{I Print content "Cell Phone: #{$faker.phone_number.phone_number}" to shamus output}
  end
end


Given(/^I generate UID and I print log$/) do
  step %Q{I Print content "UID: #{$faker.uid}" to shamus output}
end

And(/^I append UID to "(.*?)" and print log$/) do |arg1|
  step %Q{I Print content "Print log: #{$faker.stringify(arg1, $faker.uid)}" to shamus output}
end

Given /^I generate name "(.*)" and store value in "(.*)" and print log$/ do |value, var|
  steps %Q{
    And I store value "#{$faker.name.send(value.to_sym)}" in "#{var}"
    And I Print content "#{var}: #{value}" to shamus output
  }
end

And /^I append "(.*)" to "(.*)" and print log$/ do |value, var|
  x = "#{$sticky[var] + $faker.send(value.to_sym)}"
  steps %Q{
    And I store value "#{$sticky[var] + $faker.send(value.to_sym)}" in "#{var}"
    And I Print content "#{var}: #{value}" to shamus output
  }
end

Given(/^Invitation email is delivered to user inbox$/) do
  $mail = MediTAF::Utils::Email::Mail.new($config['utils']['gmail']['gmail_user_addr'], $config['utils']['gmail']['gmail_user_password'])
  $mail.send_mail $config['utils']['gmail']['gmail_user_addr'], "You have been invited to join iMedidata", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
  sleep 15
end

Given(/^An invitation email is delivered to the inbox of the following users:$/) do |table|
  # table is a table.hashes.keys # => [:User, :Email]
  $mail = MediTAF::Utils::Email::Mail.new($config['utils']['gmail']['gmail_user_addr'], $config['utils']['gmail']['gmail_user_password'])
  $email_addr = {}

  table.hashes.each do | data |

    address = data['Email'].to_s.split('@')[0]
    domain = data['Email'].to_s.split('@')[1]
    user = data['User']

    rand = $faker.number.number(10)

    recipient = address + '+' + rand + '@'+domain

    unless $email_addr.has_key?(user)
      $email_addr.store(user, recipient)
    end

    $mail.send_mail recipient, "You have been invited to join iMedidata", File.open(Dir.glob(File.join("**", "mail_invite_body.html")).first, 'rb').read
  end
  sleep 15
end

When(/^I find latest unread email from specified sender in user inbox$/) do
  $invite = $mail.find_email($config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata')
end


When(/^I find latest unread email from specified sender in the inbox of a specific user at position (\d+) in the email thread$/) do |position|

  if $email_addr.has_key?(position)
      recipient=$email_addr[position]
    else
      raise ArgumentError.new('The position specified does not exist as a key')
  end
    $invite = $mail.find_email($config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata', true, Time.now, recipient)
end

Then(/^It should contain invitation url$/) do
  expect($invite.url.downcase).to include('users')
  $mail.delete $config['utils']['gmail']['gmail_user_addr'], 'You have been invited to join iMedidata'
  $mail.logout
end
