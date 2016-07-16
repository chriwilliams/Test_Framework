require_relative '../common/base_page'

module Minotaur
  class EmailPage < Common::BasePage

    element :next_email, '#next-email'
    element :email, '#patient_enrollment_login'
    element :email_confirmation, '#patient_enrollment_login_confirmation'
    element :disabled_email_button, 'a[id="next-email" class="btn btn-primary btn-block disabled"]'

    def check_header_text(header_text)
      form.text.include?(header_text)
    end

    def check_next_email_button_enabled
      next_email[:class].include?("disabled") ? false : true
    end


    def click_next_email
      next_email.click
    end

    def set_email(email_id)
      email.set email_id
      $sticky[:email]=email_id
    end

    def set_email_confirmation(email_id)
      email_confirmation.set email_id
    end

  end
end
