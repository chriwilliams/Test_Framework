require_relative 'edc'

module Ravex
  class Subject < Edc

    element :select_matrix, '#addEventDropdown'
    elements :select_matrix_options, '#addEventDropdown > option'
    elements :rows, 'div[class*="row edcRow"]'
    elements :subject_page_buttons, 'a[class$="btn-default"]'
    elements :enable_disable_buttons, '#toggleLockEventStatus > button'
    element :sign_all, 'a#sign-all-button'
    element :add_event, '#addEvent'

    set_url_matcher /.checkmate./

    # Click "Disabled" button on Subject page to disable the subject.
    def disable_subject
      enable_disable_subject('Disabled')
    end

    # Click "Enabled" button on Subject page to disable the subject.
    def enable_subject
      enable_disable_subject('Enabled')
    end

    # Add event for a subject.
    # @param value [string] value to choose from dropdown.
    def add_subject_event(value)
        select_matrix.select value
        add_event.click
    end

    # Clicks on "Subject Administration" button.
    def open_subject_admin
      click_subject_buttons('Subject Administration')
    end

    # Clicks on "Subject Administration" button.
    def open_subject_id_form
      click_subject_buttons('Subject ID')
    end

    # signs all forms from the Subject page
    # @param user_name [string] the user name to sign the eCRF
    # @param password [string] the password of the user
    def form_sign_all(user_name, password)
      sign_all.click
      form_sign_data_enter(user_name, password)
    end

    private

    # Clicks on specified button.
    # @param name [string] value: "Subject ID" or "Subject Administration"
    def click_subject_buttons(name)
      subject_btn = subject_page_buttons.detect {|item| item.text == name}
      if subject_btn
          subject_btn.click
      else
        raise "Button: #{name} is not available on Subject Page."
      end
    end

    # Enables or Disables the Subject.
    # @param action [string] value: "Subject ID" or "Subject Administration"
    def enable_disable_subject(action)
      button = enable_disable_buttons.detect {|item| item.text == action}
      if button and button.value == 'false'
        button.click
      else
        raise "Button: #{action} is not available or active on the Subject Page."
      end
    end

  end
end