require_relative '../common/base_page'

module Minotaur
  class RegistrationPage < Common::BasePage

    set_url $config['ui']['apps']['minotaur']['base_url']

    element :code, '#code'
    element :activate_button, '#activate-button'

    def initialize
      self.load
    end

    def set_activation_code(code)
      self.code.set code
    end

    def get_message
      message.text
    end

    def check_activation_code_enabled
      activate_button[:class].include?("disabled") ? false : true
    end
  end
end
