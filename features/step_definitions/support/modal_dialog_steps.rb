Then(/^I\s?(?:should)? see the Modal Dialog with title "(.*?)" and message "(.*?)"$/) do |title, message|
  modal = find(".modal-dialog")
  expect(modal.find(".modal-title")).to have_content(title)
  expect(modal.find(".modal-body")).to have_content(message)
end
# I      should   see the Modal Dialog with the contents:
Then(/^I\s?(?:should)? see the Modal Dialog with\s?(?:the)? contents:$/) do |table|
  modal = find(".modal-dialog")
  table.hashes.each_with_index do |attributes|
    expect(modal.find(".modal-title")).to have_content(attributes['modal-title'])
    expect(modal.find(".modal-body")).to have_content(attributes['modal-body'])
  end

end

When(/^I click the Modal Dialog button "(.*?)"$/) do |button_text|
  modal = find(".modal-dialog")
  modal_button = modal.find(".modal-footer").find(:xpath, "button[contains(text(), '#{button_text}')]")
  modal_button.click()
end
