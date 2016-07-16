require_relative '../common/base_page'

module Imedidata
  class Login < Common::BasePage

    set_url $config['ui']['apps']['imedidata']['base_url']

    element :username, 'input#session_username'
    element :password, 'input#session_password'
    element :log_in, '#create_session_link'
    element :message, 'div[class^=flash]'

    def initialize
      self.load
    end

    # Login to imedidata using provided parameters
    # @param username [String] Username of the user
    # @param password [String] Password of the user
    def login(username, password)
      self.username.set username
      self.password.set password
      log_in.click
    end

    def get_message
      message.text
    end
  end
end
