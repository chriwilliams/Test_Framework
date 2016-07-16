require_relative '../common/base_page'

module Rave
  class Study < Common::BasePage

    elements :tabs, 'a[id*="PgHeader_TabTextHyperlink"]'
    element :site_search_text, 'input[id*="ListDisplayNavigation_txtSearch"]'
    element :site_search_button, 'input[name$="ListDisplayNavigation:ibSearch"]'

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      # Wait for the page to be displayed with 30 seconds timeout
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    # verifies site tab with specified name
    # @param site_name [String] the name of the site
    def find_site_tab(site_name)
      site_tab = tabs.detect { |inner_item| inner_item.text == site_name }
      raise "Site #{site_name} tab is displayed." unless site_tab
      site_tab
    end

    # searches for the site tab
    # @param site_name [String] the name of the site
    def site_search(site_name)
      site_tab = tabs.detect { |inner_item| inner_item.text == site_name }
       unless site_tab
         site_search_text.set site_name
         site_search_button.click
       end
    end
  end
end