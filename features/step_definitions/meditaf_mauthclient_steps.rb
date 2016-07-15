$verbs = {'list' => :get, 'create' => :post, 'update' => :put, 'delete' => :delete}

Given /^I can make a request to imedidata to (list|create|update|delete) (.+)$/ do |verb, resource|
  @verb = $verbs[verb]
  @resource = case verb
                when 'list', 'create'
                  "study_groups/[study group UUID]/studies.json"
                when 'update', 'delete'
                  "studies/[study UUID].json"
              end
end

When /^I send the request with a StudyGroupId of "(.*)"$/ do |sgrpid|
    @resource.sub!(/\[study group UUID\]/, sgrpid)
    $response = $services.imedidata(adapter: :mauth, baseurl: 'https://validation.imedidata.net/api/v2') \
      .send(:request, {verb: @verb, resource: @resource})
end

And /^I store "(.*)" response value "(.*)" in "(.*)"$/ do |hash, key, var|
  step %Q/I store value "#{$response.body["#{hash}"]["#{key}"]}" in "#{var}"/
end

When /^I send the request with following attributes:$/ do |attributes|
  body = Hash[ attributes.hashes[0].select { |k,v| !['StudyGroupUUID', 'StudyUUID'].include?(k) }]
  body.each_pair { |k, v| body[k] = $sticky.has_key?(v) ? $sticky[v] : v }

  @resource = case @verb
                when :delete
                  @resource.sub(/\[study UUID\]/, attributes.hashes[0]['StudyUUID'])
                when :put
                  body['oid'] = $sticky['StudyOID']
                  body['name'] += $faker.timestamp_short
                  body['protocol'] += $faker.random
                  @resource.sub(/\[study UUID\]/, $sticky['StudyUUID'])
                when :post
                  body['oid'] += $faker.uid
                  body['name'] += $faker.timestamp_short
                  body['protocol'] += $faker.random
                  @resource.sub(/\[study group UUID\]/, attributes.hashes[0]['StudyGroupUUID'])
                else
                  raise "verb #{@verb} not handled with step"
              end

  $response = $services.imedidata.request(verb: @verb, resource: @resource, body: body.to_json)
end

# And /^I print response body in the log$/ do
#   text = case $response.headers['content-type']
#     when /^text\/html/
#       Nokogiri::XML($response.body){|c| c.default_xml.noblanks}.to_xml(indent:2)
#     when /^application\/json/
#       JSON.pretty_unparse($response.body)
#   end
#   asset = Shamus.current.current_step.add_inline_asset('.txt', Shamus::Cucumber::InlineAssets::RENDER_AS_TEXT)
#   File.open(asset, 'w') {|f| f.puts("#{text}")}
# end
