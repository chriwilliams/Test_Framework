require_relative '../common/base_page'

module Minotaur
  class WelcomeTouPage < Common::BasePage

    elements :form_header, '[class^=form-header]'
#TODO uncomment  element :create_account, '#next-landing'
    element :create_account_button, '#next-landing'
    element :form, 'h3[class=form-header]'
    element :agree_button, '#next-agree'
    element :confirm_agree, 'div[class*="buttons"] > [type="submit"]'
    element :confirm_cancel, 'div[class*="buttons"]> [type="danger"]'
    element :confirm, 'div[class*="buttons"]'
# find("#landing_page")[:class].include?("some-class")

    def check_header_text(header_text)
      form.text.include?(header_text)
    end

    def check_create_account_button_enabled
      create_account_button[:class].include?("disabled") ? false : true
    end

    def check_agree_button_enabled
      agree_button[:class].include?("disabled") ? false : true
    end

    def cancel_dialog
      page.driver.browser.switch_to.alert.dismiss
    end

    def agree_dialog
      page.driver.browser.switch_to.alert.accept
    end

    def get_text
      page.driver.browser.switch_to.alert.text
    end

  end
end
