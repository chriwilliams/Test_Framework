require_relative '../common/base_page'
require_relative '../common/base_section'
require_relative 'sections'

module Imedidata
  class Helpdesk < Common::BasePage
    section :header, Header, '#header'

    element :email_searchbox, '#search_field_email'
    element :search_button, 'a#active_user_search_submit'
    element :cannot_save_in_prod_flag, 'input#user_clinical_data_restricted'
    elements :save_or_send_buttons, '[class="btn btn-sm btn-default"]'
    element :profile_tab, 'div[id=ajax-profile-tabs]'

    # Search for the user with specified email address.
    # @param email [staing] email address to search for.
    def email_search(email)
      email_searchbox.set email
      email_searchbox.native.send_keys(:enter)
    end

    # Sets the "Cannot Save in Production" flag to requested state.
    # @param state [string] possible values: checked, unchecked.
    def cannot_save_in_prod_flag_set(state)
      case state.downcase
        when 'checked'
          if cannot_save_in_prod_flag['checked'].nil?
            cannot_save_in_prod_flag.set true
          end
        when 'unchecked'
          if cannot_save_in_prod_flag['checked'].to_s.match(/(true)$/i)
            cannot_save_in_prod_flag.set false
          end
        else
          raise "State: '#{state}' of the 'Cannot Save in Production' flag is not supported."
      end
    end

    # Saves the Helpdesk form.
    def helpdesk_form_save
      save_button = save_or_send_buttons.detect{|item| item.text == "Save"}
      save_button.click
    end

    # selects a tab on the profile page
    # @param name [string] the tab name to select
    def tab_select(name)
      tab = profile_tab.find(:css, 'a', text: "#{name}")
      tab.click
    end
  end
end
