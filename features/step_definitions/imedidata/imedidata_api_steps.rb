def study_group_uuid(name)
  response = $services.imedidata.request(verb: :get, resource: "study_groups.json")
  raise "invalid status #{response.status}" unless response.status == 200
  response.body['study_groups'].detect { |sg| sg['name'] == name }['uuid']
end

def study_uuid(name)
  raise "need study group name" unless $sticky[:study_group_name]
  response = $services.imedidata.request(verb: :get, resource: "study_groups/#{study_group_uuid($sticky[:study_group_name])}/studies.json")
  raise "invalid status #{response.status}" unless response.status == 200
  response.body['studies'].detect{|s| s['name'] == name}["uuid"]
end

And /^I complete the course and esign to access the study:$/ do
  steps %Q{
    Given I can make a request to imedidata to update a course by study group
    And I send the request to override
    And I should get a "200" status result
  }
end

### IMedidata Service Using MAuth STEPS ###
$verbs = {'list' => :get, 'create' => :post, 'update' => :put, 'delete' => :delete}

Given /^I can make a request to imedidata to (list|create|update|delete) (.+)$/ do |verb, resource|
  @verb = $verbs[verb]
  @resource = case verb
                when 'list', 'create'
                  case resource
                    when /\bstudies\b$/
                      "study_groups/[study group UUID]/studies.json"
                    when /\ba study\b$/
                      "studies/[study UUID].json"
                    when /\bstudy groups\b$/
                      "study_groups.json"
                    when /\b(?:a|the) study group\b$/
                      "study_groups/[study group UUID].json"
                    when /\bcourses\b$/
                      "courses.json"
                    when /\ba course by study group$\b/
                      "study_group/[study group UUID]/courses/[course UUID]/users/[user email]/override.json"
                    when /\ba course by study\b$/
                      "studies/[study UUID]/courses/[course UUID]/users/[user email]/override.json"
                  end
                when 'update', 'delete'
                  case resource
                    when /\b(?:a|the) study\b/
                      "studies/[study UUID].json"
                    when /\b(?:a|the) course by study group\b/
                      "study_group/[study group UUID]/courses/[course UUID]/users/[user email]/override.json"
                    when /\b(?:a|the) course by study\b/
                      "studies/[study UUID]/courses/[course UUID]/users/[user email]/override.json"
                  end
              end
end

When /^I send the request to override$/ do
  raise "need study or study group uuid" unless $sticky[:study_name] && $sticky[:study_group_name]
  raise "need a course uuid in the configuration" unless $config['modules']['ui']['apps']['imedidata']['course_uuid']
  $services.imedidata(adapter: :mauth, baseurl: $config['modules']['ui']['apps']['imedidata']['app_url'])
  uuid = case @resource
           when /\[study UUID\]/
             study_uuid($sticky[:study_name])
           when /\[study group UUID\]/
             study_group_uuid($sticky[:study_group_name])
         end
  @resource.sub!(/\[study (?:group |)UUID\]/, uuid)
  @resource.sub!(/\[user email\]/, $sticky[:test_user_email])
  @resource.sub!(/\[course UUID\]/, $config['modules']['ui']['apps']['imedidata']['course_uuid'])
  $response = $services.imedidata.request(verb: @verb, resource: @resource)
end

Then(/^I should get a "(.*?)" status result$/) do |status|
  result = case $response
             when String
               $response.to_i
             else
               $response.respond_to?(:last_response) ? $response.last_response.status : $response.status
           end
  result.should == status.to_i
  step %Q/I Print content "VERIFIED: response has status '#{result}' " to shamus output/
end
