require_relative '../common/base_section'

module Mccadmin

  # Header
  class Header < Common::BaseSection

    elements :help_dropdown_options, '#help > ul > li > a'
    elements :user_dropdown_options, '#user > ul > li > a'

    element :help_dropdown_button, '#help > a'
    element :user_dropdown_button, '#user > a'

    # Select help option from the header
    # @param help_option [string] Help Option
    def select_help_option(help_option)
      help_dropdown_button.click
      option = help_dropdown_options.detect { |inner_item| inner_item.text.downcase.include? help_option.downcase }
      option.click if option
    end

    # Select user option from the header
    # @param user_option [string] User Option
    def select_user_option(user_option)
      user_dropdown_button.click
      option = user_dropdown_options.detect { |inner_item| inner_item.text.downcase.include? user_option.downcase }
      option.click if option
    end

    # Log out of the application
    def logout
      select_user_option('Log Out')
    end

    # Navigates to MCCAdmin home
    def select_admin()
      user_dropdown_button.click
      admin_link = find_link("admin")
      admin_link.click if admin_link
    end

  end

  # MCC Admin left navigation
  class LeftNav <  Common::BaseSection

    elements :all_items, 'li a'

    # select a section from the left nav
    # @params option [string] text of navigation section (i.e. Manage Users)
    def select_nav(option)
      all_items.each do |item|
        if item.text.include?(option)
          item.click
          break
        end
      end
    end

  end

  # Checkmate Navigation Menu
  class Navigation <  Common::BaseSection

    element :home_button, '#navigation > a'
    element :actions, '#actions'
    element :client_divisions, '#client_divisions'
    element :studies, '#studies'
    element :study_env, '#study_environments'
    element :menu, 'div[class=dropdown-menu]'
    element :client_divisions_menu, '#client_divisions_menu'

    elements :menu_list, '.dropdown-menu a'

    # Go to homepage
    def go_home
      home_button.click
    end


    # Select client division from Navigation Menu
    # @param cd_option [String] Client Division option
    def select_client_division(cd_option)
      hover_and_select(client_divisions, cd_option)
    end

    # Select action from Navigation Menu
    # @param action_option [String] Action option
    def select_action(action_option)
      hover_and_select(actions, action_option)
    end

    # Select study from Navigation Menu
    # @param study_option [String] Study option
    def select_study(study_option)
      hover_and_select(studies, study_option)
    end

    # Select study from Navigation Menu
    # @param study_option [String] Study Environment option
    def select_study_environment(study_env_option)
      hover_and_select(study_env, study_env_option)
    end

    private

    # Hover over the breadcrumbs dropdown and clicks the option provided, raises if the option is nil
    # @param selection [String] CSS of the element
    # @param option [String] Action performed in the drop down menu
    def hover_and_select(selection, option)
      res = ''
      selection.hover
      self.wait_until_menu_visible
      within(selection) do
        res = menu_list.detect {|item| item.text==option}
      end
      res.click
    end

  end

  # Search Section
  class Search < Common::BaseSection

    elements :search_by_options, '#search-by-attribute > ul > li > a'

    element :search_by_dropdown_button, '#search-by-attribute > button'
    element :search_text, '#search_by'
    element :search_submit, '#search-list-submit'

    # Search by a particular option
    # @param by_option [string] Search by option
    # @param search_term [string] Search term
    def search_by (by_option, search_term)
      search_by_dropdown_button.click
      option = search_by_options.detect { |inner_item| inner_item.text.downcase.include? by_option.downcase }
      option.click if option
      search_text.set search_term
      search_submit.click
    end

  end

  # Main Menu
  class Main < Common::BaseSection
    element :message_text, '#notice'
    element :header_text, 'div.page-header-text'

    elements :user_options, '#add-users-dropdown'

    # Returns success or failure message in the page header
    def get_message
      message_text.text
    end

    # Returns page header
    def get_page_header
      header_text.text
    end
  end

  # Esignature
  class EsignatureFrame < Common::BaseSection

    element :esign_username, '#username'
    element :esign_password, '#password'
    element :esign_button, '#create_session_link'

    # Provides esign.
    # @param username[String]
    # @param password[String]
    def provide_esign(username, password)
      esign_username.set username
      esign_password.set password
      esign_button.click
    end
  end

  # filter panel for environments
  class EnvironmentPanel < Common::BaseSection

    elements :environments, '.filter-group a' #collection links

    # Clicks the environment in the filter panel
    # @param env_name [string] The name of the environment
    def select_environment(env_name)
      env_index = nil
      environments.each_with_index do |env, index|
        if env.text.include? env_name
          env_index = index
          break
        end
      end
      environments[env_index].click
    end
  end

end