require 'faraday'

Given(/^I create a resource "(.*?)" with following attributes:$/) do |resource, table|
  attributes = table.rows_hash
  $response = nil
  begin
    $response = $services.send(resource.downcase.to_sym, adapter: :euresource).post(attributes, method: 'create')
  rescue Euresource::ResourceNotFound => e
    $response = e.message.scan(/^.* Response status: (\d{3})\..*$/)[0].join
  rescue RuntimeError => e
    $response = e
  end
end

Then(/^I should get a "(.*?)" status result$/) do |status|
  result = case $response
             when String
               $response.to_i
             else
               $response.respond_to?(:last_response) ? $response.last_response.status : $response.status
           end
  expect(result).to eq status.to_i
  step %Q{I Print content "VERIFIED: response has status '#{result}' " to shamus output}
end

Then /^I should get an error$/ do
  expect($response).to be_an_instance_of(RuntimeError)
  step %Q{I Print content "VERIFIED: response has status '#{$response}' " to shamus output}
end

Given(/^I notedown value of "(.*?)" from response in "(.*?)"$/) do |value, var|
  $sticky[var] = $response.attributes[value]
  step %Q{I Print content "Value '#{value}' is noted down in '#{var}' from response " to shamus output}
end

Then(/^the result should have the attributes and values:$/) do |table|
  table.rows_hash['uuid'] = $sticky[table.rows_hash['uuid']]
  table.rows_hash.each { |k, v| table.rows_hash[k] = nil if v == 'nil' }
  resp = $response.attributes
  expect(resp).to eq table.rows_hash
  step %Q{I Print content "VERIFIED: response attributes and values are matching " to shamus output}
end

When(/^I search resource "(.*?)" using "(.*?)"$/) do |resource, search_attr|
  begin
    $response = nil
    $response = $services.send(resource.downcase.to_sym, adapter: :euresource).get($sticky[search_attr])
  rescue Euresource::ResourceNotFound => e
    $response = e.message.scan(/^.* Response status: (\d{3})\..*$/)[0].join
  end
end

Then(/^I update the resource "(.*?)" with uuid "(.*?)" with following attributes and values:$/) do |resource, var, table|
  attributes = table.rows_hash
  uuid = $sticky[var]
  $response = $services.send(resource.downcase.to_sym, adapter: :euresource).put(attributes, params: {'uuid' => uuid})
end

Then(/^I delete the resource "(.*?)" with uuid "(.*?)"$/) do |resource, uuid|
  $response = nil
  begin
    $response = $services.send(resource.downcase.to_sym, adapter: :euresource).delete($sticky[uuid])
  rescue Euresource::ResourceNotFound => e
    $response = e.message.scan(/^.* Response status: (\d{3})\..*$/)[0].join
  end
end
