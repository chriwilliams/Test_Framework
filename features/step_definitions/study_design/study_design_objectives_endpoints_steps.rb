include JanusSelectorHelpers

When(/^I insert the following\s?(first)? "(Objectives|Endpoints)" within the "(Objectives\/Endpoints)" panel:$/) do |first, type, container, table|
  table.hashes.each_with_index do |attributes|
    objective = attributes['objective type']
    description = attributes['objective description']
    case type
      when 'Objectives'
        if first.nil?
          step %Q{I insert an "Objective" of type "#{objective}" and description as "#{description}" within the "Objectives/Endpoints" panel}
        else
          step %Q{I insert a first "Objective" of type "#{objective}" and description as "#{description}" within the "Objectives/Endpoints" panel}
        end
      when 'Endpoints'
        if first.nil?
          step %Q{I insert an "Endpoint" of type "#{endpoint}" description as "#{endpoint_description}" and sub-type as "#{endpoint_subtype}" from "#{objective} Objective" matching description: "#{description}" within the "Objectives/Endpoints" panel}
        else
          step %Q{I insert a first "Endpoint" of type "#{endpoint}" description as "#{endpoint_description}" and sub-type as "#{endpoint_subtype}" from "#{objective} Objective" matching description: "#{description}" within the "Objectives/Endpoints" panel}
        end

    end
    sleep 2
  end
  # sleep 60
end

When(/^I insert\s?an?\s?(first)? "Objective" of type "([^"]+)" and description as "([^"]+)" within the "Objectives\/Endpoints" panel(?:, but )?(cancel)?$/) do |first, type, description, cancel|
  first.nil? ? create_objective(type, description, !cancel.nil?):create_first_objective(type, description, !cancel.nil?)
end

When(/^I insert\s?an?\s?(first)? "Endpoint" of type "([^"]+)" description as "([^"]+)" and sub-type as "([^"]+)" from "([^"]+) Objective" matching description: "([^"]+)" within the "Objectives\/Endpoints" panel(?:, but )?(cancel)?$/) do |first, endpoint, endpoint_description, endpoint_subtype, type, description, cancel|
  first.nil? ? create_endpoint(endpoint, endpoint_description, endpoint_subtype, type, description, !cancel.nil?):create_first_endpoint(endpoint, endpoint_description, endpoint_subtype, type, description, !cancel.nil?)
end

When(/^I select "([^"]+) ([^"]+)" from the "([^"]+)" form within the "(Objectives\/Endpoints)" panel$/) do |content, type, form, container|
  case type
    when 'Objective'
      $applications.study_design.send($helpers.to_page_file(container)).select(form, 'form', content)
    when 'Endpoint'
      $applications.study_design.send($helpers.to_page_file(container)).select(form, 'form', content, 'endpoint')
    when 'Endpoint-Subtype'
      $applications.study_design.send($helpers.to_page_file(container)).select(form, 'form', content, 'endpoint-subtype')

  end

end

When(/^the number of "([^"]+)?\s?([^"]+)" types is (\d+) within the "(Objectives\/Endpoints)" panel$/) do |selection, type, count, container|
  case type
    when 'Objective'
      if selection.nil?
        $async::wait_until{$applications.study_design.send($helpers.to_page_file(container)).get_items_count('Objective', 'list').to_i == count.to_i}
        expect($applications.study_design.send($helpers.to_page_file(container)).get_items_count('Objective', 'list').to_i).to be == count.to_i
      end
  end
end

When(/^I\s?(?:should)? see the following "Objectives" within the "(Objectives\/Endpoints)" panel:$/) do |container, table|
  table.hashes.each_with_index do |attributes|
    step %Q{I can see the description: "#{attributes['objective description']}" for "#{attributes['objective type']} Objective" within the "Objectives/Endpoints" panel}
  end
end

When(/^I can see the description: "([^"]+)" for "([^"]+) Objective" within the "(Objectives\/Endpoints)" panel$/) do |content, type, container|
  # expect($applications.study_design.scenario.get_list_text_content('Objective', 'list', container, type).include?(content)).to be_true
  # list = $applications.study_design.scenario.get_list_content('Objective', 'list', container)
  # obj = list.find {|e| (e[:class].include? type.downcase)}
  # expect((obj.all('li obj-item').map{|elem| elem.text}).include?(content)).to be_true
sleep 5
  objectList = all("ol.obj-list").find {|e| (e[:class].downcase.include? type.downcase)}
  elem = objectList.all("li.obj-item p").map{|e|e.text}
  expect(elem.include?(content)).to be_true
end


# methods that add or update new objectives
# @param table: [hash] objectives data {1. type, 2. derscription}
# @param action: [string] update or create new objectives
def add_objective(table, action)
  step %Q{I toggle-open the "Objectives/Endpoints" toggle-button within the "Scenario" page}
  step %Q{I see the "Objectives/Endpoints" panel within the "Scenario" page}
  table.each_with_index do |data|
    case action
      when 'new'
        step %Q{I see the "New Objective" button within the "Objectives/Endpoints" panel}
        sleep 0.01
        step %Q{I click on the "New Objective" button within the "Objectives/Endpoints" panel}
        step %Q{I see the "Editable Objective" container within the "Objectives/Endpoints" panel}
      when 'first'
        step %Q{I see the "No Objectives" container within the "Scenario" page}
        step %Q{I see the "Add Objective" link within the "No Objectives" container}
        step %Q{I click on the "Add Objective" link within the "No Objectives" container}
        step %Q{I should see the "Editable Objective" first container within the "Objectives/Endpoints" panel}
    end
    step %Q{I see the "Add Objective" form within the "Editable Objective" container}
    step %Q{I see the text: "Add Objective - All fields are required" in the "#{action.capitalize} Objective" header within the "Editable Objective" container}
    data.merge!('action' => 'save')
    $applications.study_design.send($helpers.to_page_file('Objective Form')).add_objective(data)
    $applications.study_design.send($helpers.to_page_file("#{data['objective type']} Objective")).add_objective(data['objective description']) if data['action'] == 'save'
  end
end



# methods that add or update new objectives
# @param table: [hash] objectives data {1. type, 2. derscription}
# @param action: [string] update or create new objectives
def edit_objective(table)
  step %Q{I toggle-open the "Objectives/Endpoints" toggle-button within the "Scenario" page}
  step %Q{I see the "Objectives/Endpoints" panel within the "Scenario" page}
  table.each_with_index do |data|
    $applications.study_design.send($helpers.to_page_file("#{data['old objective type']} Objective")).reset(data['old objective description'])
    steps %Q{
      Given I see the "Action" button within the "#{data['old objective type']} Objective" container for "#{data['old objective description']}"
      When I click on the "Edit" button within the "#{data['old objective type']} Objective" container for "#{data['old objective description']}"
      Then I should see the "Active Objective" container within the "Objectives/Endpoints" panel
      And I should see the "Edit Objective" form within the "Editable Objective" container
      And I should see the text: "Edit Objective - All fields are required" in the "Edit Objective" header within the "Editable Objective" container
    }
    data.merge!('action' => 'save')

    $applications.study_design.send($helpers.to_page_file('Objective Form')).edit_objective(data)
    $applications.study_design.send($helpers.to_page_file("#{data['old objective type']} Objective")).delete_objective(data['old objective description']) if data['action'] == 'save'
    $applications.study_design.send($helpers.to_page_file("#{data['objective type']} Objective")).add_objective(data['objective description']) if data['action'] == 'save'
  end
end

def delete_objective(table)
  step %Q{I toggle-open the "Objectives/Endpoints" toggle-button within the "Scenario" page}
  step %Q{I see the "Objectives/Endpoints" panel within the "Scenario" page}
  table.each_with_index do |data|
    $applications.study_design.send($helpers.to_page_file("#{data['objective type']} Objective")).reset(data['objective description'])
    data.merge!('action' => 'yes')
    steps %Q{
      Given I see the "Action" button within the "#{data['objective type']} Objective" container for "#{data['objective description']}"
      When I click on the "Delete" button within the "#{data['objective type']} Objective" container for "#{data['objective description']}"
      Then I should see the Modal Dialog with title "Delete Objective" and message "Are you sure you want to remove this objective? Warning - Deleting this objective will remove the objective AND all endpoints attached to the objective"
      And I click the Modal Dialog button "#{data['action'].capitalize}"
    }

    $applications.study_design.send($helpers.to_page_file("#{data['objective type']} Objective")).delete_objective(data['objective description']) if data['action'] == 'yes'
  end
end


# methods that add or update new endpoints
# @param table: [hash] objectives data {1. type, 2. subtype 3. derscription}
# @param action: [string] update or create new endpoints
def add_endpoint(table, action)
  step %Q{I toggle-open the "Objectives/Endpoints" toggle-button within the "Scenario" page}
  step %Q{I see the "Objectives/Endpoints" panel within the "Scenario" page}
  table.each_with_index do |data|
    case action
      when 'new'
        sleep 1
        step %Q{I see the "Endpoints" link within the "#{data['objective type']} Objective" container for "#{data['objective description']}"}
        step %Q{I toggle-open the "Endpoints" toggle-button within the "#{data['objective type']} Objective" container for "#{data['objective description']}"}
        step %Q{I see the "New Endpoint" button within the "#{data['objective type']} Objective" container for "#{data['objective description']}"}
        step %Q{I click on the "New Endpoint" button within the "#{data['objective type']} Objective" container for "#{data['objective description']}"}
        sleep 1
        step %Q{I see the "New Endpoint" container within the "Editable Endpoint" container}
      when 'first'
        sleep 1
        step %Q{I see the "First Endpoint" button within the "#{data['objective type']} Objective" container for "#{data['objective description']}"}
        step %Q{I click on the "First Endpoint" button within the "#{data['objective type']} Objective" container for "#{data['objective description']}"}
        step %Q{I see the "First Endpoint" container within the "Editable Endpoint" container}
    end
    data.merge!('action' => 'save')
    $applications.study_design.send($helpers.to_page_file('Endpoint Form')).add_endpoint(data)
  end
end


def edit_endpoint(table)
  # TODO: implement method to edit existing endpoints
end

def delete_endpoint(table)
  # TODO: implement method to delete existing endpoints
end


Then /^the number of "([^"]+)" (types?|buttons?) is "(\d+)" within the "([^"]+)" (?:#{CONTAINER})$/ do |item, tag, count, container|
  expect($applications.study_design.send($helpers.to_page_file(container)).count(item, tag)).to eq count.to_i
end
