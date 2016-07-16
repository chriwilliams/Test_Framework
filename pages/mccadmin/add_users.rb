require_relative 'common_page'

module Mccadmin

  # Add users to the study
  class AddUsers < Mccadmin::CommonPage

    element :env_role_site, 'div[class^="template-row"]'
    elements :all_multiselect_menus, 'div[class^="ui-multiselect-menu"]'

    element :study_environment, 'div[class*=environments-group] > button[class^=ui-multiselect]'

    element :user_email, '#user_email'
    element :user_first_name, '#user_first_name'
    element :user_last_name, '#user_last_name'
    element :user_phone, '#user_telephone'
    element :add_env_role_site, '#add-button'
    element :submit_button, '#add-user-submit'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Add personal info for users
    # @param email[string] User email address
    # @param first_name [string] user first name
    # @param last_name [string] user last name
    # @param phone [string] user phone number. Optional
    def add_user_personal_info(email, first_name, last_name, phone=nil)
      user_email.set email
      user_first_name.set first_name
      user_last_name.set last_name
      user_phone.set phone if phone
    end

    # Add Environment, role and site relationship for the user
    # @param envs [string] Environments
    # @param roles [string] Role
    # @param sites [string] Site
    def add_env_role_site(envs, roles, sites)
      { 'Environment' => envs, 'Role' => roles, 'Site' => sites }.each_pair do |kind, selection|
        select_item(kind, selection)
      end

    end

    # Press submit button
    def add_user_submit
      submit_button.click
    end

    private

    def select_item(button, collection)
      env_role_site.find_button(button).click
      menu = all_multiselect_menus.detect { |m| m.visible? }
      if collection
        collection.each do |col_item|
          if col_item.downcase.include? 'all'
            menu.find_link("All #{button}s").click
          else
            checkboxes = menu.all('input')
            checkbox = checkboxes.detect { |item| item[:title].downcase.include? col_item.strip.downcase }
            checkbox.set(true) if checkbox
          end
        end
       end
    end

  end
end
