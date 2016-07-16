require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class UserActivation < Common::BasePage
    section :header, Header, '.HeaderIconBar'

    element :act_code_label, 'span[id$="ActCodeValueLabel"]'
    element :activation_code_text, '#ActivationCodeBox'
    element :activation_code_value_label, 'span[id$="ActCodeValueLabel"]'
    element :pin_text, '#PINBox'
    element :activate_acc_button, '#ActivateButton'
    element :password_text, 'input[id$=NewPasswordBox]'
    element :confirm_password_text, 'input[id$=ConfirmPasswordBox]'
    element :save_password_btn, 'input[id$=SavePasswordButton]'
    element :continue_link, '#ContinueLink'

    set_url_matcher /\/medidatarave\//i

    #Gets activation code for the new or not activated user.
    def activation_code_get()
      act_code = activation_code_value_label.text
    end

    #Populates data on Account Activation Request
    #@param act_code[string] code to activate user
    #@param pin[sting] pin to activate user
    def activation_account_data_enter(act_code, pin)
      activation_code_text.set act_code
      pin_text.set pin
      activate_acc_button.click
    end

    #sets passeword for the new user account
    #@param password[string] password to set
    def activation_account_password_set(password)
      password_text.set password
      confirm_password_text.set password
      save_password_btn.click
    end

    #Navigates from user activation page to login page by clicking "Click here to continue..." link
    def activation_account_login_page_navigate()
      continue_link.click
    end
  end
end
