require_relative 'common_page'

module Mccadmin

  # Elements and methods for 'All Studies' page
  class ManageSites < Mccadmin::CommonPage

    section :main_nav, LeftNav, '#sidebar'
    section :env_filter, EnvironmentPanel, '#content-panel'

    element :site_name, 'tr[id^=site] > td[class=site-number]'
    element :clear_search, '#clear-search'
    element :add_new_site, '#add-site'

    set_url_matcher /.checkmate./

    def initialize
      super
    end

    # Search by option and select depending on the identifier
    # @param by [String] used to select option to search
    # @param identifier [String] used to select item to search
    def search_and_select_site(by, identifier)
      search.search_by(by, identifier)
      site_name.click if site_name.text.include?(identifier)
    end

  end
end