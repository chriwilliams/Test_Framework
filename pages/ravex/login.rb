require_relative '../common/base_page'

module Ravex
  class Login < Common::BasePage

    set_url $config['modules']['ui']['apps']['ravex']['base_url']

    element :username, 'input#session_username'
    element :password, 'input#session_password'
    element :submit, 'a#create_session_link'

    set_url_matcher /.checkmate./

    def initialize
      self.load
    end

    def login(username, password)
      self.username.set username
      self.password.set password
      submit.click
    end
  end
end