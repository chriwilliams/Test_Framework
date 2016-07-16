require_relative '../common/base_page'
require_relative 'sections'

module Rave
  class Configurations < Common::BasePage

    set_url_matcher /\/medidatarave\//i

    # Wait for page to be displayed. Url matcher from above is used to verify that page is displayed.
    def initialize
      raise 'The page was not loaded' unless self.displayed?(30)
    end

    def other_settings_select
      other_settings_link = self.find_link("Other Settings")
      other_settings_link.click
      sleep 4
    end
  end
end