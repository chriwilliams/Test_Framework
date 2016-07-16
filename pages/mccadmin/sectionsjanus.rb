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

  # Navigation Menu
  class Navigation <  Common::BaseSection

    element :home_button, '#navigation > a'

    # Go to homepage
    def go_home
      home_button.click
    end

    # Select client division from Navigation Menu
    # @param cd_option [string] Client Division option
    def select_client_division(cd_option)
      select_from_dropdown('#client_divisions', cd_option)
    end

    # Select action from Navigation Menu
    # @param action_option [string] Action option
    def select_action(action_option)
      # select_from_dropdown('#actions', action_option)
      select_from_dropdown('#actions_menu', action_option)
    end

    # Select study from Navigation Menu
    # @param study_option [string] Study option
    def select_study(study_option)
      select_from_dropdown('#studies', study_option)
    end

    private

    # Select from breadcrumbs dropdown
    # @param selector [string] css selector for the dropdown
    # @param option [string] option to select
    def select_from_dropdown(selector, option)
      # page.driver.execute_script("$(\'#{selector}\').find(\'ul.dropdown-menu\').show()")

      page.driver.execute_script("$(\'#{selector}\').find(\'.dropdown-menu\').show()")
      sleep 4
      puts"ok"
      within(selector + ' ul.search-results') { click_link(option) }
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

    # Returns success or failure message in the page header
    def get_message
      message_text.text
    end

    # Returns page header
    def get_page_header
      header_text.text
    end
  end

end