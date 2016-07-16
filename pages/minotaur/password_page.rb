require_relative '../common/base_page'

module Minotaur
  class PasswordPage < Common::BasePage

    element :next_password, '#next-password'
    element :password, '#patient_enrollment_password'
    element :password_confirmation, '#patient_enrollment_password_confirmation'

    def check_header_text(header_text)
      form.text.include?(header_text)
    end

    def check_next_password_button_enabled
      next_password[:class].include?("disabled") ? false : true
    end


    def click_next_password
      next_password.click
    end

    def set_password(password_val)
      password.set password_val
      $sticky[:password] = password_val
    end

    def set_password_confirmation(email_id)
      password_confirmation.set email_id
    end

  end
end
