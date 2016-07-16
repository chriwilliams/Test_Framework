require_relative '../common/base_page'

module Minotaur
  class SecurityQuestionPage < Common::BasePage

    element :create_account_button, '#create-account'
    element :security_question, "select[id='patient_enrollment_security_question']"
    element :security_answer, '#patient_enrollment_answer'
    element :form, 'p[id=download-instruction]'
    element :back_arrow, 'a[class="back-arrow pull-left"]'


    def check_header_text(header_text)
      form.text.include?(header_text)
    end

    def check_create_account_button_enabled
      begin
        create_account_button[:class].include?("disabled") ? false : true
      rescue
        true
      end
    end

    def set_security_question()
      security_question.find(:xpath, 'option[2]').select_option
    end

    def set_security_answer()
      security_answer.set "1985"
    end

    def press_back_arrow
      back_arrow.click
    end
  end
end
