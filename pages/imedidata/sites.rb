require_relative '../common/base_page'
require_relative 'sections'

module Imedidata
  class Sites < Common::BasePage

    section :header, Header, '#header'

    element :create_new_site, 'a[id*="create_sites"]'
    element :enter_first_site_name, 'input[id$="0_name"]'
    element :enter_first_site_number, 'input[id$="0_site_attributes_number"]'
    element :enter_first_study_site_number, 'input[id$="0_number"]'
    element :save_site, 'a[id*="active_submit"]'
    element :site_table, 'table[id*="study_sites_list"]'


    # Creates a site within a study once on the site page
    # @param site_name [String] name of site.  It's a good idea to randomize the site_name
    # @param site_number [String] number of site. It's a good idea to randomize the site_number
    # @param study_site_number [String] nil unless a value is provided since it's not required in iMedidata
    # @return site_number [String] will return site_number as
    def create_site(site_name, site_number, study_site_number = nil)
      create_new_site.click
      enter_first_site_name.set site_name
      enter_first_site_number.set site_number
      enter_first_study_site_number.set study_site_number unless study_site_number == nil?
      save_site.click
      wait_for_site_table
      $sticky[:ActiveSite1] = site_number
    end

  end
end

