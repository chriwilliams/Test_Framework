require_relative '../common/base_page'

module Rave
  class Login < Common::BasePage

    set_url $config['ui']['apps']['rave']['base_url']

    element :username, 'input#UserLoginBox'
    element :password, 'input#UserPasswordBox'
    element :submit, 'input#LoginButton'
    element :activate_link, 'a#NewAccountLink'
    element :forgot_password_link, 'a#ForgotAccountLink'
    element :language, 'select#LocaleList'
    element :login_link, 'a#LogInLink'

    def initialize
      self.load
    end

    # login to Rave
    # @param username [String] the name of the user
    # @param password [String] the password of the user
    def login(username, password)
      self.username.set username
      self.password.set password
      submit.click
    end

    # changes locale on the login page.
    # @param locale [String] the locale you want to select
    def change_locale(locale)
      self.language.select locale
    end

    #clicks on Log in Link.
    def login_click()
      login_link.click
    end

    #Navigates to User Activation page
    def new_user_activate()
      activate_link.click
    end
  end
end
