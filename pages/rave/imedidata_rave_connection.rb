require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class ImedidataRaveConnection < Common::BasePage
    section :header, Header, '.HeaderIconBar'

    #element :rave_account_dropdown, '[id$="UserAccountsDDL"]'
    element :password_text, 'input[id$="PasswordBox"]'
    element :link_account_button, '[id$=LinkAccountButton]'
    elements :rave_account_dropdown_options, '[id$="Content_UserAccountsDDL"]  > option '

    set_url_matcher /\/medidatarave\//i

    #Enters data in specified fields on iMedidata-Rave connection page.
    #@param field [string] field name: Rave Account, Password
    #@param value [string] value to populate.
    def imedidata_rave_connection_data_enter(field, value)
      #if link_account_button
        case field.downcase
          when 'rave account'
            option = rave_account_dropdown_options.detect { |item| item.value == value}
            option.click unless option.nil?
          when 'password'
            password_text.set value
          #TODO: when 'role'
          else
            raise "Option: #{field} is not supported."
        end
      #end
    end

    #clicks "Link account" button on iMedidata-Rave connection page.
    def link_account_click
      link_account_button.click
    end
  end
end