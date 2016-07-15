require_relative '../common/base_page'

module Imedidata
  class Login < Common::BasePage

    set_url $config['ui']['apps']['imedidata']['base_url']

    element :username, 'input#session_username'
    element :password, 'input#session_password'
    element :submit, '#create_session_link'

    def initialize
      self.load
    end

    def login(username, password)
      self.username.set username
      self.password.set password
      submit.click
    end
  end

  class InnerLogin < Common::BasePage
    def inner_method

    end
  end
end
