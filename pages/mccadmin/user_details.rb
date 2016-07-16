require_relative 'common_page'

module Mccadmin

  # Elements and methods for 'User Details page'
  class UserDetails < Mccadmin::CommonPage

    elements :environments, '.dropdown-menu > li > a'
    element :site_name, 'tr[id^=site] > td[id*=name]'
    element :assign_button, 'button[id^=study_env_site]'

    element :roles_env_dropdown, '#roles-env-dropdown'
    element :sites_env_dropdown, '#sites-env-dropdown'
    element :assign_sites, '#assign-sites'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Assigns site to user
    # @param params [Hash] is used to navigate in an environment, search for site and assign it to user
    # @return [String] the text on Assign button
    def assign_site_to_user(search_by, params={})
      assign_sites.click
      select_environment(params[:environment])
      search_and_assign_site(search_by, params[:site_name])
    end

    # Select an environment depending on the param
    # @param option [String] used to match and select environment
    def select_environment(option)
      sites_env_dropdown.click
      environment = environments.detect { |env| env.text.include?(option)}
      environment.click
    end

    # Search for site within selected environment and clicks assign button
    # @param by [String] the options to search for
    # @param identifier [String] to sort search by options provided
    def search_and_assign_site(by, identifier)
      search.search_by(by, identifier)
      assign_button.click if site_name.text.include?(identifier)
      sleep 5 # Wait for button text change
    end

  end
end
