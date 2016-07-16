require_relative '../common/base_page'

module Imedidata
  class UserAgreement < Common::BasePage

    element :username, 'input#user_login'
    element :password, 'input#user_password'
    element :agree, 'div[class*="buttons"] > [type="submit"]'
    element :cancel, 'div[class*="buttons"] > [type="danger"]'

    set_url_matcher /.imedidata./

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # confirms the EULA page
    # @param username [String] the name of the user
    # @param password [String] the password of the user
    def eula_confirm(username, password)
      self.username.set username
      self.password.set password
      agree.click
    end

    # cancels the EULA page
    def eula_cancel
      cancel.click
    end

  end
end