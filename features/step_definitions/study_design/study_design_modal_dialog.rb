def delete_modal(object, choice = 'Yes')
  title = "Delete #{object.capitalize}"
  message = nil
  case object.downcase
    when 'scenario'
      message = "Are you sure you would like to delete the scenario?"
    when 'schedule'
      message = "Are you sure you want to permanently delete the schedule?"
    when 'objective'
    when 'endpoint'
    when 'activity','activities'
      when 'visit','visits'
  end
  if title && message
    steps %Q{
      And I should see the Modal Dialog with title "#{title}" and message "#{message}"
      And I click the Modal Dialog button "#{choice}"
    }
  end
end

def rename_modal(object, message, choice='Save')
  title = "Rename #{object.capitalize}"

  within 'div.modal-dialog' do
    expect(page).to have_css 'h4.modal-title'
    expect(page).to have_content title

    fill_in "#{object.downcase}-name", with:  message
    click_button choice.capitalize
  end

end
